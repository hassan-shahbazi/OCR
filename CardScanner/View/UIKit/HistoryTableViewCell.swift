//
//  HistoryTableViewCell.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var objectDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup(_ object: HistoryObject?) {
        guard let object = object else { return }
        
        self.objectImage.image = object.image
        self.objectName.text = (object.person?.firstName ?? "") + " " + (object.person?.sureName ?? "")
        self.objectDate.text = Utility.getString(from: object.date ?? Date())
    }

}
