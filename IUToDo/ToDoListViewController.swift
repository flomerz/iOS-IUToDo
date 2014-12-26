//
//  ViewController.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import UIKit
import CoreData

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
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        var fetchRequest = NSFetchRequest(entityName: ToDo.ENTITY_NAME)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ToDo] {
            todos = fetchResults
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
                    todo.doneDate = NSDate()
                    managedObjectContext!.save(nil)
                    toDoList.reloadData()
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
    
    func onTodosUpdated() {
        loadData()
        toDoList.reloadData()
    }
    
}

