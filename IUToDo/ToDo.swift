//
//  ToDo.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

@objc(ToDo)
class ToDo : NSManagedObject {
    class var ENTITY_NAME: String { return "ToDo" }
    
    lazy var dateFormat : NSDateFormatter = {
        var df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.FullStyle
        df.timeStyle = NSDateFormatterStyle.FullStyle
        return df
    }()
    
    @NSManaged var externalID: NSNumber
    @NSManaged var title: String
    @NSManaged var subject: String
    @NSManaged var doneDate: NSDate?

    func update(json: JSON) {
        self.externalID = json["id"].numberValue
        self.title = json["title"].stringValue
        self.subject = json["subject"].stringValue
        self.doneDate = dateFormat.dateFromString(json["doneDate"].stringValue)?
    }
    
    func doneDateString() -> String {
        if let date = doneDate? {
            return dateFormat.stringFromDate(date)
        }
        return "";
    }
}