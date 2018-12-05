//
//  ShowInfoImageTableViewCell.swift
//  CardScanner
//
//  Created by Hassan Shahbazi on 12/5/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class ShowInfoImageTableViewCell: UITableViewCell {

    @IBOutlet weak var userCard: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setup(_ item: HistoryObject) {
        if let card = item.image { self.userCard.image = card }
    }
}
