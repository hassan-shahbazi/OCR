//
//  DetectionUtility.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/23/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol CardDetectionUtilityDelegate {
    func didDetectCardImage(_ image: CIImage, at rect: CGRect)
}

class CardDetectionUtility: DetectionUtility {
    public var delegate: CardDetectionUtilityDelegate?
    private var rectangleQueue: DispatchQueue!
    private lazy var rectanglesRequest: VNDetectRectanglesRequest = {
        return VNDetectRectanglesRequest(completionHandler: self.handleRequest)
    }()
    
    override init() {
        super.init()
        
        rectangleQueue = DispatchQueue(label: "rectangle_detection_queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem, target: queueTarget)
    }
    
    override func detect(_ liveImage: CIImage) {
        self.inputImage = liveImage
        let handler = VNImageRequestHandler(ciImage: inputImage, orientation: .up)
        rectangleQueue.async {
            try? handler.perform([self.rectanglesRequest])
        }
    }
    
    override func handleRequest(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRectangleObservation] else { return }
        guard let detectedRectangle = observations.first else { return }
        let imageSize = inputImage.extent.size
        
        let boundingBox = detectedRectangle.boundingBox.scaled(to: imageSize)
        let topLeft = detectedRectangle.topLeft.scaled(to: imageSize)
        let topRight = detectedRectangle.topRight.scaled(to: imageSize)
        let bottomLeft = detectedRectangle.bottomLeft.scaled(to: imageSize)
        let bottomRight = detectedRectangle.bottomRight.scaled(to: imageSize)
        var correctedImage = inputImage
            .cropped(to: boundingBox)
            .applyingFilter("CIPerspectiveCorrection", parameters: [
                "inputTopLeft": CIVector(cgPoint: topLeft),
                "inputTopRight": CIVector(cgPoint: topRight),
                "inputBottomLeft": CIVector(cgPoint: bottomLeft),
                "inputBottomRight": CIVector(cgPoint: bottomRight)
                ])
        
        correctedImage = correctedImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
        DispatchQueue.main.async {
            self.delegate?.didDetectCardImage(correctedImage, at: boundingBox)
        }
    }
}


