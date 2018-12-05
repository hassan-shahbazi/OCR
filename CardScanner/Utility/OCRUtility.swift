//
//  OCRUtility.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/23/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLVision

typealias textDetectionCompletion = ((_ error: Error?, _ blocks: [String]?) -> Void)

class OCRUtility: NSObject {
    lazy var vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    let metadata = VisionImageMetadata()

    override init() {
        super.init()
    }
    
    func detectText (image: UIImage, _ completion: @escaping textDetectionCompletion) {
        textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            if let error = error {
                completion(error, nil);
            }
            
            else if let blocks = result?.blocks {
                completion(nil, blocks.map({ return $0.text }))
            }
        }
    }

}
