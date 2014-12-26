//
//  ToDo.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import Foundation
import CoreData

@objc(ToDo)
class ToDo : NSManagedObject {
    class var ENTITY_NAME: String { return "ToDo" }
    
    @NSManaged var title: String
    @NSManaged var subject: String
    @NSManaged var doneDate: NSDate
}