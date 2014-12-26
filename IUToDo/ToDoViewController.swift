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
    func onTodosUpdated()
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
    
    @IBAction func saveToDo(sender: AnyObject) {
        if todo == nil {
            todo = (NSEntityDescription.insertNewObjectForEntityForName(ToDo.ENTITY_NAME, inManagedObjectContext: managedObjectContext!) as ToDo)
        }
        
        todo!.title = fieldTitle.text
        todo!.subject = fieldSubject.text
                
        managedObjectContext!.save(nil)

        delegate?.onTodosUpdated()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

