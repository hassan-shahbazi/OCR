//
//  CaptureViewController.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Vision

let debugMode = false

class CaptureViewController: UIViewController {
    //Video Capture
    private var bufferSize: CGSize = .zero
    private let videoDataOutputQueue = DispatchQueue(label: "videoDataOutputQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //View outlets
    private let cancelButton = CircleButton()
    private var scanArea: ScanView!
    private var imgView: UIImageView!
    
    //Utilities
    private let detection = DetectionUtility()
    private let ocrUtility = OCRUtility()
    
    //Capture result
    private var capturedImage: UIImage!
    private var extractedTextError: Error? {
        didSet {
            self.performSegue(withIdentifier: "showError", sender: self)
        }
    }
    private var extractedTextBlocks: [String]? {
        didSet {
            if debugMode { print("extracted blocks: \(extractedTextBlocks!)") }
            self.performSegue(withIdentifier: "showInfo", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateCaptureSession()
        initiateVideoPreviewLayer()
        initiateBackgroundLayer()
        initaiteScanArea()
        
        initiateStatement()
        if debugMode { initaiteThumbnail() }
        detection.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initiateButton()
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    private func initiateCaptureSession() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .hd1920x1080
        if captureSession.canAddInput(input) { captureSession.addInput(input) }
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }
        initaiteCaptureConnection(device)
    }
    
    private func initaiteCaptureConnection(_ device: AVCaptureDevice) {
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        do {
            try? device.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            device.unlockForConfiguration()
        }
        captureSession.commitConfiguration()
    }
    
    private func initiateVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.backgroundColor = UIColor.red.cgColor
        
        view.layer.addSublayer(videoPreviewLayer!)
    }
    
    private func initiateBackgroundLayer() {
        let path = UIBezierPath(rect: getScanArea())
        path.append(UIBezierPath(rect: view.bounds))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        view.layer.insertSublayer(maskLayer, above: videoPreviewLayer)
    }
    
    private func initaiteScanArea() {
        scanArea = ScanView(frame: getScanArea())
        scanArea.shape()
        view.addSubview(scanArea)
    }
    
    private func initiateStatement() {
        let statementPoints = getStatementArea()
        let statementTitle = StatementLabel(frame: statementPoints.0)
        statementTitle.shape("Add ID Card.", font: UIFont.boldSystemFont(ofSize: 20))
        view.addSubview(statementTitle)
        
        let statementSubtitle = StatementLabel(frame: statementPoints.1)
        statementSubtitle.shape("Position your ID Card within the frame.", font: UIFont.systemFont(ofSize: 17))
        view.addSubview(statementSubtitle)
    }
    
    private func initiateButton() {
        cancelButton.frame = getButtonArea()
        cancelButton.setBackgroundImage(UIImage(named: "camera_button_off"), for: .normal)
        cancelButton.setImage(nil, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.analyzeCard), for:.touchUpInside)
        cancelButton.shapeButton()
        view.addSubview(cancelButton)
    }
    
    private func initaiteThumbnail() {
        let point = CGPoint(x: 0, y: view.frame.height - 100)
        let size = CGSize(width: 100, height: 100)
        imgView = UIImageView(frame: CGRect(origin: point, size: size))
        imgView.contentMode = .scaleAspectFit

        view.addSubview(imgView)
    }
    
    private func updateScanArea(_ found: Bool) {
        DispatchQueue.main.async {
            self.scanArea.layer.borderColor = (found) ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let btnImage = (found) ? "camera_button_on" : "camera_button_off"
            
            self.cancelButton.setBackgroundImage(UIImage(named: btnImage), for: .normal)
            self.cancelButton.isEnabled = found
        }
    }
    
    @objc func analyzeCard() {
        cancelButton.setBackgroundImage(UIImage(named: "camera_button_off"), for: .normal)
        cancelButton.setImage(UIImage(named: "loading_card"), for: .normal)
        cancelButton.rotateButton()
        ocrUtility.detectText(image: capturedImage) { (error, blocks) in
            if error != nil { self.extractedTextError = error }
            else if blocks != nil { self.extractedTextBlocks = blocks }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CaptureErrorViewController {
            destination.capturedImage = self.capturedImage
        }
        if let destination = segue.destination as? ShowInfoViewController {
            destination.textBlocks = self.extractedTextBlocks
        }
    }
}

extension CaptureViewController {
    private func getScanArea() -> CGRect {
        let width: CGFloat = view.frame.width - 24
        let height: CGFloat = 240.0
        let point = CGPoint(x: view.frame.midX - width/2, y: view.frame.midY - (width+60.0)/2)
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: point, size: size)
    }
    
    private func getStatementArea() -> (CGRect, CGRect) {
        let scanArea = getScanArea()
        let width: CGFloat = view.frame.width - 16
        let height: CGFloat = 24
        let size = CGSize(width: width, height: height)
        
        let y = scanArea.origin.y + scanArea.height + 16
        let titlePoint: CGPoint = CGPoint(x: view.frame.width/2 - width/2, y: y)
        let subtitlePoint: CGPoint = CGPoint(x: view.frame.width/2 - width/2, y: y + height + 8)
        
        return (CGRect(origin: titlePoint, size: size), CGRect(origin: subtitlePoint, size: size))
    }
    
    private func getButtonArea() -> CGRect {
        let height: CGFloat = 70.0
        let width: CGFloat = 70.0
        let point = CGPoint(x: view.frame.width/2 - width/2, y: view.frame.height - height - 36.0)
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: point, size: size)
    }
    
    private func getAcceptanceArea() -> CGRect {
        let point = CGPoint(x: 460.0, y: 40.0)
        let size = CGSize(width: 620.0, height: 1010.0)

        return CGRect(origin: point, size: size)
    }
}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate  {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        self.detection.detectRectangel(CIImage(cvPixelBuffer: pixelBuffer))
    }
}

extension CaptureViewController: DetectionUtilityDelegate {
    func didDetectImage(_ image: CIImage, at rect: CGRect) {
        let context = CIContext()
        let cgImage = context.createCGImage(image, from: image.extent)
        self.capturedImage = UIImage(cgImage: cgImage!)
        
        self.updateScanArea(self.scannedImageIsInAcceptanceArea(rect))
        if debugMode { self.imgView.image = capturedImage }
    }
    
    private func scannedImageIsInAcceptanceArea(_ scannedArea: CGRect) -> Bool {
        let acceptanceArea = self.getAcceptanceArea()
        
        let xDiff = (scannedArea.origin.x * 100) / acceptanceArea.origin.x
        let yDiff = (scannedArea.origin.y * 100) / acceptanceArea.origin.y
        let widthDiff = (scannedArea.width * 100) / acceptanceArea.width
        let heightDiff = (scannedArea.height * 100) / acceptanceArea.height
        
        return (xDiff >= 80.0) && (yDiff >= 80.0) && (widthDiff >= 80.0) && (heightDiff >= 80.0)
    }
}
