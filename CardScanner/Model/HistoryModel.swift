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
    var idNumber:   String?
    var firstName:  String?
    var sureName:   String?
    var sureNameBirthDate: String?
    var birthdate:  Date?
    var gender:     Gender?
    var signature:  String?
    var nationality:String?
}

class HistoryObject: NSObject {
    var id:         Int?
    var person:     PersonObject?
    var date:       Date?
    var image:      UIImage?
}

class HistoryManagedObject: NSManagedObject {
    @NSManaged var id:  NSNumber?
    @NSManaged var idNumber:   String?
    @NSManaged var firstName:  String?
    @NSManaged var sureName:   String?
    @NSManaged var sureNameBirthDate: String?
    @NSManaged var birthdate:  Date?
    @NSManaged var gender:     String?
    @NSManaged var signature:  String?
    @NSManaged var nationality: String?
    @NSManaged var date:       Date?
    @NSManaged var image:      Data?
}

extension HistoryManagedObject {
    var object: HistoryObject {
        let person = PersonObject()
        person.idNumber = self.idNumber
        person.firstName = self.firstName
        person.sureName = self.sureName
        person.sureNameBirthDate = self.sureNameBirthDate
        person.birthdate = self.birthdate
        if let gndr = self.gender { person.gender = Gender(rawValue: gndr) }
        person.signature = self.signature
        person.nationality = self.nationality
        
        let object = HistoryObject()
        object.id = self.id?.intValue
        object.person = person
        object.date = self.date
        if let img = self.image { object.image = UIImage(data: img) }
        
        return object
    }
}

enum Gender: String {
    case Male   = "M"
    case Female = "F"
    case X      = "X"
    
    var description: String {
        switch self {
            case .Male: return "Male"
            case .Female: return "Female"
            case .X: return "X"
        }
    }
}
