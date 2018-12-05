//
//  ScanView.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class ScanView: UIView {

    public func shape() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}
