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
    
    class var SERVER: String { return "http://192.168.0.138:9000/" }
    
    // Local
    
    class func loadToDos(context: NSManagedObjectContext) -> [ToDo]? {
        var fetchRequest = NSFetchRequest(entityName: ToDo.ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        return context.executeFetchRequest(fetchRequest, error: nil) as [ToDo]?
    }
    
    class func addToDo(title:String, subject:String, context: NSManagedObjectContext, callback: () -> Void) {
        let todo = (NSEntityDescription.insertNewObjectForEntityForName(ToDo.ENTITY_NAME, inManagedObjectContext: context) as ToDo)
        todo.title = title
        todo.subject = subject
        context.save(nil)
        syncToDoFromLocalToRemote(todo, context: context, callback: callback)
    }
    
    class func updateToDo(todo:ToDo, context: NSManagedObjectContext, callback: () -> Void) {
        context.save(nil)
        syncToDoFromLocalToRemote(todo, context: context, callback: callback)
    }
    
    class func doneToDo(todo:ToDo, context: NSManagedObjectContext, callback: () -> Void) {
        todo.doneDate = NSDate()
        context.save(nil)
        syncToDoFromLocalToRemote(todo, context: context, callback: callback)
    }
    
    // Sync
    
    class func syncToDos(context: NSManagedObjectContext, callback: () -> Void) {
        syncToDosFromLocalToRemote(context, callback: { () -> Void in
            self.syncToDosFromRemoteToLocal(context, callback: callback)
        })
    }
    
    class func syncToDoFromLocalToRemote(todo:ToDo, context: NSManagedObjectContext, callback: () -> Void) {
       Alamofire.request(.POST, SERVER,
            parameters: ["id": todo.externalID, "title": todo.title, "subject": todo.subject, "doneDate": todo.doneDateString()]
            ).responseSwiftyJSON { (request, response, json, error) in
                todo.update(json)
                context.save(nil)
                //NSLog("synced todo from local to remote: %@", todo)
                callback()
        }
    }
    
    class func syncToDosFromLocalToRemote(context: NSManagedObjectContext, callback: () -> Void) {
        if let todos = loadToDos(context)? {
            var todosCount = todos.count
            if todosCount > 0 {
                for(todo:ToDo) in todos {
                    syncToDoFromLocalToRemote(todo, context: context, callback: { () -> Void in
                        if --todosCount == 0 {
                            callback()
                        }
                    })
                }
            } else {
                callback()
            }
        }
    }
    
    class func syncToDosFromRemoteToLocal(context: NSManagedObjectContext, callback: () -> Void) {
        Alamofire.request(.GET, SERVER).responseSwiftyJSON { (request, response, json, error) in
            for (key: String, todoJson: JSON) in json {
                var todo:ToDo?
                
                var fetchRequest = NSFetchRequest(entityName: ToDo.ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "externalID = %i", todoJson["id"].int64Value)
                if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [ToDo] {
                    if fetchResults.count == 1 {
                        todo = fetchResults[0]
                    }
                }
                
                if todo == nil {
                    todo = (NSEntityDescription.insertNewObjectForEntityForName(ToDo.ENTITY_NAME, inManagedObjectContext: context) as ToDo)
                }
                
                todo!.update(todoJson)
                context.save(nil)
                //NSLog("synced todo from remote to local: %@", todo!)
            }
            
            callback()
        }
    }

}