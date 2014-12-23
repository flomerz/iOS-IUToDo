//
//  ViewController.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var toDoList: UITableView!
    
    var todos: [ToDo] = [ToDo]()
    
   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        var t = ToDo(title: "iu", subject: "iuuuuuuuu")
        t.done()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.toDoList.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var todo = self.todos[indexPath.row]
        var cellText = todo.title
        
        if todo.doneDate != nil {
            cellText += " - DONE! - " + NSDateFormatter.localizedStringFromDate(todo.doneDate!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        
        cell.textLabel.text = cellText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var todo = self.todos[indexPath.item]
        
        var alert = UIAlertController(title: "ToDo", message: todo.title+": "+todo.subject, preferredStyle: .Alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .Default) { (action: UIAlertAction!) -> Void in
            todo.done()
            self.toDoList.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func addToDo(sender: AnyObject) {
        var alert = UIAlertController(title: "New ToDo", message: "Add a title and a subject", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (title: UITextField!) -> Void in }
        alert.addTextFieldWithConfigurationHandler { (subject: UITextField!) -> Void in }
        
        let saveAction = UIAlertAction(title: "Add", style: .Default) { (action: UIAlertAction!) -> Void in
            let titleField = alert.textFields![0] as UITextField
            let subjectField = alert.textFields![1] as UITextField
            self.todos.append(ToDo(title: titleField.text, subject: subjectField.text))
            self.toDoList.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

