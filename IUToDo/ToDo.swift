//
//  ToDo.swift
//  IUToDo
//
//  Created by Flo on 22/12/14.
//  Copyright (c) 2014 Flo. All rights reserved.
//

import Foundation

class ToDo {
    var title: String
    var subject: String
    var doneDate: NSDate?
    
    init(title: String, subject: String) {
        self.title = title
        self.subject = subject
    }
    
    func done() {
        doneDate = NSDate()
    }
}