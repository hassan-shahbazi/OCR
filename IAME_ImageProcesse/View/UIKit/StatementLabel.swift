//
//  StatementLabel.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class StatementLabel: UILabel {

    public func shape(_ txt: String, font: UIFont) {
        self.font = font
        self.text = txt
        self.textColor = UIColor.white
        self.textAlignment = .center
    }

}
