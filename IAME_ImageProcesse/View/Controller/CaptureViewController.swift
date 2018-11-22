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

class CaptureViewController: UIViewController {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let cancelButton = CircleButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateCaptureSession()
        initiateVideoPreviewLayer()
        initiateBackgroundLayer()
        initaiteScanArea()
        
        initiateStatement()
        initiateButton()
    }
    
    private func initiateCaptureSession() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }

        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        captureSession?.startRunning()
    }
    
    private func initiateVideoPreviewLayer() {
        guard let captureSession = self.captureSession else { return }
        
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
        let scanArea = UIView(frame: getScanArea())
        scanArea.backgroundColor = UIColor.clear
        scanArea.layer.masksToBounds = true
        scanArea.layer.cornerRadius = 5.0
        scanArea.layer.borderWidth = 1.0
        scanArea.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(scanArea)
    }
    
    private func initiateStatement() {
        let statementPoints = getStatementArea()
        let statementTitle = UILabel(frame: statementPoints.0)
        statementTitle.font = UIFont.boldSystemFont(ofSize: 20)
        statementTitle.text = "Add ID Card"
        statementTitle.textColor = UIColor.white
        statementTitle.textAlignment = .center
        view.addSubview(statementTitle)
        
        let statementSubtitle = UILabel(frame: statementPoints.1)
        statementSubtitle.font = UIFont.systemFont(ofSize: 17)
        statementSubtitle.text = "Position your ID Card within the frame."
        statementSubtitle.textColor = UIColor.white
        statementSubtitle.textAlignment = .center
        view.addSubview(statementSubtitle)
    }
    
    private func initiateButton() {
        cancelButton.frame = getButtonArea()
        cancelButton.setBackgroundImage(UIImage(named: "camera_button_off"), for: .normal)
        cancelButton.addTarget(self, action: #selector(startScanning), for:.touchUpInside)
        cancelButton.shapeButton()
        view.addSubview(cancelButton)
    }
    
    @objc func startScanning() {
        cancelButton.setBackgroundImage(UIImage(named: "camera_button_off"), for: .normal)
        cancelButton.setImage(UIImage(named: "loading_card"), for: .normal)
        cancelButton.rotateButton()
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
}

extension CaptureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
}
