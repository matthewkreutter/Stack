//
//  AddTaskViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 11/18/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var importance: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var reminder: UITextField!
    var tasks: [String] = []
    
    override func viewDidLoad() {
        if let myTasks = UserDefaults.standard.array(forKey: "tasks") {
            tasks = myTasks as! [String]
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        //tasks.append(Task(name: taskName.text!, category: category.text!, importance: importance.text!, date: date.text!, time: time.text!, reminder: reminder.text!)
        //tasks.append(Task(name: "test", category: "test", importance: "test", date: "test", time: "test", reminder: "test"))
        tasks.append(taskName.text!)
        UserDefaults.standard.set(tasks, forKey: "tasks")
    }
}
