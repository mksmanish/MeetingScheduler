//
//  DatabaseHelper.swift
//  MeetingScheduler
//
//  Created by manish on 31/07/21.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    static var sharedInstance = DatabaseHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    func saveData(object : [meetingDetails]) {
        for user in object {
            let meet = NSEntityDescription.insertNewObject(forEntityName: "CoreMeet", into: context!) as! CoreMeet
            meet.startTime = user.startTime
            meet.endTime = user.endTime
            meet.title = user.welcomeDescription
            meet.participant = stringArrayToData(stringArray: user.participants)
            
          }
        do {
            try context?.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stringArrayToData(stringArray: [String]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }
    
    func getData() -> [CoreMeet]{
        var meetData = [CoreMeet]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreMeet")
        do {
            meetData = try context?.fetch(fetchRequest) as! [CoreMeet]
        } catch let error  {
            print(error.localizedDescription)
        }
        return meetData

    }
    
}
