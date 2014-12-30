//
//  ViewController.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ToDoViewControllerDelegate {
    @IBOutlet weak var toDoList: UITableView!
    
    var todos: [ToDo] = [ToDo]()
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toDoList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        DataManager.syncToDos(managedObjectContext!, callback: { () -> Void in
            NSLog("2-way synced todos with remote")
            self.loadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        if let results = DataManager.loadToDos(managedObjectContext!)? {
            self.todos = results
            toDoList.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = toDoList.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var todo = self.todos[indexPath.row]
        var cellText = todo.title
        
        if let doneDate = todo.doneDate as NSDate? {
            cellText += " - DONE! - " + NSDateFormatter.localizedStringFromDate(doneDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        
        cell.textLabel?.text = cellText

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = self.todos[indexPath.item]
        if let doneDate = todo.doneDate as NSDate? {
            let date = NSDateFormatter.localizedStringFromDate(doneDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
            let alert = UIAlertView(title: "ToDo", message: todo.title+": "+todo.subject+"\n"+date, delegate: self, cancelButtonTitle: "Cancel")
            alert.show()
        } else {
            let alert = UIAlertView(title: "ToDo", message: todo.title+": "+todo.subject, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Done", "Edit")
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if let index = toDoList.indexPathForSelectedRow()?.item {
            let todo = self.todos[index]
            switch buttonIndex {
                case 0: // cancel
                    break
                case 1: // done
                    DataManager.doneToDo(todo, context: managedObjectContext!, callback: { () -> Void in
                        NSLog("synced with remote - set done to todo")
                        self.toDoList.reloadData()
                    })
                    break
                case 2: // edit
                    var ctrl = storyboard?.instantiateViewControllerWithIdentifier("ToDoViewController") as ToDoViewController
                    ctrl.delegate = self
                    ctrl.todo = todo
                    navigationController?.pushViewController(ctrl, animated: true)
                    break
                default: break
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "addToDo") {
            let controller:ToDoViewController = segue.destinationViewController as ToDoViewController;
            controller.delegate = self
        }
    }
    
    func onTodoUpdated() {
        loadData()
    }
    
    func onTodoUpdatedRemote() {
        NSLog("added todo to remote")
        DataManager.syncToDosFromRemoteToLocal(managedObjectContext!, callback: { () -> Void in
            NSLog("synced remote todos to local")
        })
    }
    
}

