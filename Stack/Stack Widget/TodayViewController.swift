//
//  TodayViewController.swift
//  Stack Widget
//
//  Created by Marc VandenBerg on 11/20/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
import FirebaseDatabase

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var importance: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var taskName: UILabel!
    var userID: Int = -1
    var db: DatabaseReference!
    var userCountKey = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        db = Database.database().reference()
        if (userAlreadyExists()) {
            userID = UserDefaults.standard.integer(forKey: "userID")
            loadTasks()
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults(suiteName: "group.Stack")
        defaults?.synchronize()
        let name = defaults!.string(forKey: "highestPriorityTask")
        let taskImportance = defaults!.string(forKey: "highestPriorityTaskImportance")
        let taskDate = defaults!.string(forKey: "highestPriorityTaskDate")
        let taskCategory = defaults!.string(forKey: "highestPriorityTaskCategory")
        self.taskName.text = name
        if (taskImportance! != "") {
            self.importance.text = "Importance: " + taskImportance!
        } else {
            self.importance.text = ""
        }
        self.category.text = taskCategory
        if (taskDate == "Date" || taskDate == "April 24, 3000") {
            self.dueDate.text = "No Due Date"
        }
        else {
            self.dueDate.text = taskDate
        }
    }
    
    func userAlreadyExists() -> Bool {
        return UserDefaults.standard.object(forKey: "userID") != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
    
        completionHandler(NCUpdateResult.newData)
    }
    
}
