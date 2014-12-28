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
    
    @NSManaged var title: String
    @NSManaged var subject: String
    @NSManaged var doneDate: NSDate

    func update(json: JSON) {
        self.title = json["title"].string!
        self.subject = json["subject"].string!
    }
}