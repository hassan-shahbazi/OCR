//
//  DatabaseManager.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    private static let managedContext = DatabaseInstance.SharedInstance().managedObjectContext()
    private static let persistentCoordinator = DatabaseInstance.SharedInstance().persistentStoreCoordinator

    public class func getAllObjects() -> [HistoryObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryEntity")
        let fetchResults = try? managedContext.fetch(fetchRequest)
        guard let objects = fetchResults as? [HistoryManagedObject] else { return [] }
    
        return objects.map({ return $0.object })
    }
        
    public class func saveNewObject(object: PersonObject, image: UIImage) -> Bool {
        guard let newObject = NSEntityDescription.insertNewObject(forEntityName: "HistoryEntity", into: managedContext) as? HistoryManagedObject else { return false }
        newObject.id = getNewID()
        
        newObject.idNumber = object.idNumber
        newObject.firstName = object.firstName
        newObject.sureName = object.sureName
        newObject.sureNameBirthDate = object.sureNameBirthDate
        newObject.gender = object.gender?.rawValue
        newObject.birthdate = object.birthdate
        newObject.signature = object.signature
        newObject.nationality = object.nationality
        
        newObject.image = image.pngData()
        newObject.date = getDate()
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    private class func getNewID() -> NSNumber {
        let lastID = getAllObjects().count + 1
        return NSNumber(value: lastID)
    }
    
    private class func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "d MMM, yyyy"
        
        let dateStr = formatter.string(from: Date())
        return formatter.date(from: dateStr) ?? Date()
    }
}
