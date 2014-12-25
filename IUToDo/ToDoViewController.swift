//
//  ViewController.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import UIKit

protocol ToDoViewControllerDelegate
{
    func saveToDo(todo:ToDo, newToDo:Bool)
}

class ToDoViewController: UIViewController {
    var delegate:ToDoViewControllerDelegate?
    var todo:ToDo?
    var newToDo:Bool = false
    
    @IBOutlet weak var fieldTitle: UITextField!
    @IBOutlet weak var fieldSubject: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (todo == nil) {
            newToDo = true
            todo = ToDo(title: "", subject: "")
        }
        fieldTitle.text = todo?.title
        fieldSubject.text = todo?.subject
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveToDo(sender: AnyObject) {
        todo!.title = fieldTitle.text
        todo!.subject = fieldSubject.text
        
        delegate?.saveToDo(todo!, newToDo: newToDo)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

