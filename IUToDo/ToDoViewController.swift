//
//  ViewController.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import UIKit
import CoreData

protocol ToDoViewControllerDelegate {
    func onTodoUpdated()
    func onTodoUpdatedRemote()
}

class ToDoViewController: UIViewController {
    var delegate:ToDoViewControllerDelegate?
    @IBOutlet weak var fieldTitle: UITextField!
    @IBOutlet weak var fieldSubject: UITextField!
    
    var todo:ToDo?
    
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
        
        fieldTitle.text = todo?.title
        fieldSubject.text = todo?.subject
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveLocalDone() {
        self.delegate?.onTodoUpdated()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func saveRemoteDone() {
        self.delegate?.onTodoUpdatedRemote()
    }
    
    @IBAction func saveToDo(sender: AnyObject) {
        var id:NSNumber? = nil
        if let todo = todo? {
            todo.title = fieldTitle.text
            todo.subject = fieldSubject.text
            DataManager.updateToDo(todo, context: managedObjectContext!, callback: saveRemoteDone)
            saveLocalDone()
        } else {
            DataManager.addToDo(fieldTitle.text, subject: fieldSubject.text, context: managedObjectContext!, saveRemoteDone)
            saveLocalDone()
        }
    }
    
}

