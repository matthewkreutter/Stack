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

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var taskTable: UITableView!
    
    var taskIDs = [String]()
    var taskTypes: [String] = []
    var userID: Int = -1
    var db: DatabaseReference!
    var userCountKey = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.dataSource = self
        taskTable.delegate = self
        db = Database.database().reference()
        if (userAlreadyExists()) {
            userID = UserDefaults.standard.integer(forKey: "userID")
            loadTasks()
        }
    }
    
    func loadTasks() {
        let userCountRef = db.child("tasks-" + String(userID))
        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let userCount = (child as AnyObject).key!
                self.taskIDs.append(userCount)
            }
            self.taskTable.reloadData()
        })
    }
    
    func userAlreadyExists() -> Bool {
        return UserDefaults.standard.object(forKey: "userID") != nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aTask")
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = taskIDs[indexPath.row]
        return cell
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
