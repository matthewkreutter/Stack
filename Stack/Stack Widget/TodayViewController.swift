//
//  TodayViewController.swift
//  Stack Widget
//
//  Created by Marc VandenBerg on 11/20/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var taskTable: UITableView!
    var taskIDs = [String]()
    var userID: Int = -1
    //var db: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.dataSource = self
        taskTable.delegate = self
        userID = UserDefaults.standard.integer(forKey: "userID")
        loadTasks()
        // Do any additional setup after loading the view from its nib.
    }
    
    func loadTasks() {
        //let userCountRef = db.child("tasks-" + String(userID))
        //userCountRef.observeSingleEvent(of: .value, with: { snapshot in
        //    for child in snapshot.children{
        //        let userCount = (child as AnyObject).key!
        //        self.taskIDs.append(userCount)
        //    }
        //})
        taskTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = taskIDs[indexPath.row]
        print("test")
        //FIXME change to FireBase
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
