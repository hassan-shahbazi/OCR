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

class OCRUtility: NSObject {
    lazy var vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    let metadata = VisionImageMetadata()

    override init() {
        super.init()
    }
    
    func detectText (image: UIImage) {
        textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                // ...
                return
            }
            
            for block in result.blocks {
                print(block.text)
//                let blockText = block.text
                
                
//                let blockConfidence = block.confidence
//                let blockLanguages = block.recognizedLanguages
//                let blockCornerPoints = block.cornerPoints
//                let blockFrame = block.frame
//                for line in block.lines {
//                    let lineText = line.text
//                    let lineConfidence = line.confidence
//                    let lineLanguages = line.recognizedLanguages
//                    let lineCornerPoints = line.cornerPoints
//                    let lineFrame = line.frame
//                    for element in line.elements {
//                        let elementText = element.text
//                        let elementConfidence = element.confidence
//                        let elementLanguages = element.recognizedLanguages
//                        let elementCornerPoints = element.cornerPoints
//                        let elementFrame = element.frame
//                    }
//                    print(line)
//                }
            }
        }
    }

}
