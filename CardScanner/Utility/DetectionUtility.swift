//
//  DetectionUtility.swift
//  CardScanner
//
//  Created by Hassan Shahbazi on 12/5/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import CoreML
import Vision

class DetectionUtility: NSObject {
    internal var inputImage: CIImage!
    internal let queueTarget = DispatchQueue(label: "detection_queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem)
    
    override init() {
        super.init()
    }
    
    public func detect(_ liveImage: CIImage) { }
    
    internal func handleRequest(request: VNRequest, error: Error?) { }
}
