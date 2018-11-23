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

protocol DetectionUtilityDelegate {
    func imageDidDetected(_ image: UIImage, at rect: CGRect)
}

class DetectionUtility: NSObject {
    public var delegate: DetectionUtilityDelegate?
    private var inputImage: CIImage!
    private let rectangleQueue = DispatchQueue(label: "rectangleRequestQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    private lazy var rectanglesRequest: VNDetectRectanglesRequest = {
        return VNDetectRectanglesRequest(completionHandler: self.handleRectangles)
    }()
    
    public func detectRectangel(_ liveImage: CIImage) {
        self.inputImage = liveImage
        
        let uiImage = UIImage(ciImage: inputImage)
        let orientation = Int32(uiImage.imageOrientation.rawValue)
        inputImage = inputImage.oriented(forExifOrientation: orientation)
        
        guard let cgImageOrientation = CGImagePropertyOrientation(rawValue: UInt32(orientation)) else { return }
        let handler = VNImageRequestHandler(ciImage: inputImage, orientation: cgImageOrientation)
        rectangleQueue.async {
            try? handler.perform([self.rectanglesRequest])
        }

    }
    
    private func handleRectangles(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRectangleObservation] else { return }
        guard let detectedRectangle = observations.first else { return }
        let imageSize = inputImage.extent.size
        
        let boundingBox = detectedRectangle.boundingBox.scaled(to: imageSize)
        let topLeft = detectedRectangle.topLeft.scaled(to: imageSize)
        let topRight = detectedRectangle.topRight.scaled(to: imageSize)
        let bottomLeft = detectedRectangle.bottomLeft.scaled(to: imageSize)
        let bottomRight = detectedRectangle.bottomRight.scaled(to: imageSize)
        let correctedImage = inputImage
            .cropped(to: boundingBox)
            .applyingFilter("CIPerspectiveCorrection", parameters: [
                "inputTopLeft": CIVector(cgPoint: topLeft),
                "inputTopRight": CIVector(cgPoint: topRight),
                "inputBottomLeft": CIVector(cgPoint: bottomLeft),
                "inputBottomRight": CIVector(cgPoint: bottomRight)
                ])
        
        DispatchQueue.main.async {
            self.delegate?.imageDidDetected(UIImage(ciImage: correctedImage), at: boundingBox)
        }
        
    }

}
