//
//  CaptureErrorViewController.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/25/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class CaptureErrorViewController: UIViewController {
    @IBOutlet weak var captureImageView: UIImageView!
    public var capturedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateView()
    }
    
    private func initiateView() {
        self.captureImageView.image = capturedImage
    }

    @IBAction func retakeThePhoto(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
