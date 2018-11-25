//
//  RoundedButton.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/25/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shapeButton()
    }

    private func shapeButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
    }
}
