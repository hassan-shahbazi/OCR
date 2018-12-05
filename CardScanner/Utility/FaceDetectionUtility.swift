//
//  FaceDetectionUtility.swift
//  CardScanner
//
//  Created by Hassan Shahbazi on 12/5/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol FaceDetectionUtilityDelegate {
    func didDetectFaceImage(_ image: CIImage, at rect: CGRect)
}

class FaceDetectionUtility: DetectionUtility {
    public var delegate: FaceDetectionUtilityDelegate?
    private var faceQueue: DispatchQueue!
    private lazy var facesRequest: VNDetectFaceRectanglesRequest = {
        return VNDetectFaceRectanglesRequest(completionHandler: self.handleRequest)
    }()
    
    override init() {
        super.init()
        
        faceQueue = DispatchQueue(label: "face_detection_queue", qos: .background, attributes: [], autoreleaseFrequency: .workItem, target: queueTarget)
    }
    
    override func detect(_ liveImage: CIImage) {
        self.inputImage = liveImage
        let handler = VNImageRequestHandler(ciImage: inputImage, orientation: .up)
        faceQueue.async {
            try? handler.perform([self.facesRequest])
        }
    }
    
    override func handleRequest(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else { return }
        guard let detectedFace = observations.first else { return }
        let imageSize = inputImage.extent.size
        
        let boundingBox = detectedFace.boundingBox.scaled(to: imageSize)
//        let topLeft = detectedFace.
//        let topRight = detectedRectangle.topRight.scaled(to: imageSize)
//        let bottomLeft = detectedRectangle.bottomLeft.scaled(to: imageSize)
//        let bottomRight = detectedRectangle.bottomRight.scaled(to: imageSize)
        var correctedImage = inputImage
            .cropped(to: boundingBox)
//            .applyingFilter("CIPerspectiveCorrection", parameters: [
//                "inputTopLeft": CIVector(cgPoint: topLeft),
//                "inputTopRight": CIVector(cgPoint: topRight),
//                "inputBottomLeft": CIVector(cgPoint: bottomLeft),
//                "inputBottomRight": CIVector(cgPoint: bottomRight)
//                ])
        
        correctedImage = correctedImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.up.rawValue))
        DispatchQueue.main.async {
            self.delegate?.didDetectFaceImage(correctedImage, at: boundingBox)
        }
    }
}
