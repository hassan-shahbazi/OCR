//
//  HistoryModel.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import CoreData

class PersonObject: NSObject {
    var firstName:  String?
    var sureName:   String?
    var birthdate:  Date?
    var gender:     Gender?
    var nationaliy: String?
}

class HistoryObject: NSObject {
    var person:     PersonObject?
    var date:       Date?
    var image:      UIImage?
}

class HistoryManagedObject: NSManagedObject {
    @NSManaged var firstName:  String?
    @NSManaged var sureName:   String?
    @NSManaged var birthdate:  Date?
    @NSManaged var gender:     String?
    @NSManaged var nationaliy: String?
    @NSManaged var date:       Date?
    @NSManaged var image:      Data?
}

extension HistoryManagedObject {
    var object: HistoryObject {
        let object = HistoryObject()
        object.person?.firstName = self.firstName
        object.person?.sureName = self.sureName
        object.person?.birthdate = self.birthdate
        if let gndr = self.gender { object.person?.gender = Gender(rawValue: gndr) }
        object.person?.nationaliy = self.nationaliy
        
        object.date = self.date
        if let img = self.image { object.image = UIImage(data: img) }
        
        return object
    }
}

enum Gender: String {
    case Male   = "Male"
    case Female = "Female"
    case X      = "X"
}
