//
//  DataManager.swift
//  IUToDo
//
//  Created by Flo on 28/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class DataManager {
    class func syncToDos(context: NSManagedObjectContext, callback: () -> Void) {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"]).responseSwiftyJSON { (request, response, json, error) in
            for (key: String, subJson: JSON) in json {
                var todo = (NSEntityDescription.insertNewObjectForEntityForName(ToDo.ENTITY_NAME, inManagedObjectContext: context) as ToDo)
                todo.update(subJson)
                context.save(nil)
            }
        }
    }
}