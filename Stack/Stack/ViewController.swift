//
//  ViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 11/10/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension UIColor {
    static func appleBlue() -> UIColor {
        return UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuStackView: UIStackView!
    var menuIsHidden = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allTasksList: UIButton!
    @IBOutlet weak var homeworkList: UIButton!
    @IBOutlet weak var errandsList: UIButton!
    @IBOutlet weak var miscellaneousList: UIButton!
    @IBOutlet weak var choresList: UIButton!
    @IBOutlet weak var completedTasksList: UIButton!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var dueDateOutlet: UIButton!
    @IBOutlet weak var listTypeLabel: UILabel!
    @IBOutlet weak var priorityScoreOutlet: UIButton!
    @IBOutlet weak var importanceOutlet: UIButton!
    @IBOutlet weak var tableLeadingConstraint: NSLayoutConstraint!
    var taskIDs = [String]()
    var taskTypes: [String] = []
    var userID: Int = -1
    var db: DatabaseReference!
    var userCountKey = [String]()
    var myTaskDict = [String: Task]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        db = Database.database().reference()
        
        if (userAlreadyExists()) {
            userID = UserDefaults.standard.integer(forKey: "userID")
            loadTasks()
        } else {
            let userCountRef = db.child("userCount")
            userCountRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let userCount = (child as AnyObject).key!
                    self.userCountKey.append(userCount)
                    UserDefaults.standard.set("White", forKey: "backgroundColor")
                    UserDefaults.standard.set("Black", forKey: "textColor")
                }
                
                for item in self.userCountKey {
                    self.db.child("userCount/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        var numUsers = (value?["userCount"] as? Int)!
                        numUsers = numUsers + 1
                        UserDefaults.standard.set(numUsers, forKey: "userID")
                        self.userID = numUsers
                        let resetUserCount = ["userCount": numUsers] as [String: Any]
                        self.db.child("userCount").child(self.userCountKey[0]).setValue(resetUserCount)
                    })
                }
            })
        }
        
        self.view.bringSubview(toFront: menuStackView)
        menuStackView.setCustomSpacing(15.0, after: listLabel)
        menuStackView.setCustomSpacing(15.0, after: filterLabel)
        menuStackView.setCustomSpacing(15.0, after: completedTasksList)
        menuStackView.setCustomSpacing(30.0, after: dueDateOutlet)
        //self.tableView.isEditing = true
        setColors()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            allTasksList.tintColor = UIColor.black
            priorityScoreOutlet.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            allTasksList.tintColor = UIColor.white
            priorityScoreOutlet.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            allTasksList.tintColor = UIColor.red
            priorityScoreOutlet.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            allTasksList.tintColor = UIColor.orange
            priorityScoreOutlet.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            allTasksList.tintColor = UIColor.yellow
            priorityScoreOutlet.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            allTasksList.tintColor = UIColor.green
            priorityScoreOutlet.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            allTasksList.tintColor = UIColor.blue
            priorityScoreOutlet.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            allTasksList.tintColor = UIColor.purple
            priorityScoreOutlet.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            allTasksList.tintColor = UIColor.gray
            priorityScoreOutlet.tintColor = UIColor.gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
    }
    func setColors() {
        let cells = self.tableView.visibleCells
        for cell in cells {
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Black" {
                cell.backgroundColor = UIColor.black
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "White" {
                cell.backgroundColor = UIColor.white
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Red" {
                cell.backgroundColor = UIColor.red
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Orange" {
                cell.backgroundColor = UIColor.orange
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Yellow" {
                cell.backgroundColor = UIColor.yellow
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Green" {
                cell.backgroundColor = UIColor.green
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Blue" {
                cell.backgroundColor = UIColor.blue
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Purple" {
                cell.backgroundColor = UIColor.purple
                
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Grey" {
                cell.backgroundColor = UIColor.gray
                
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Black" {
                cell.textLabel?.textColor = UIColor.black
            }
            if UserDefaults.standard.string(forKey: "textColor") == "White" {
                cell.textLabel?.textColor = UIColor.white
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Red" {
                cell.textLabel?.textColor = UIColor.red
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
                cell.textLabel?.textColor = UIColor.orange
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
                cell.textLabel?.textColor = UIColor.yellow
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Green" {
                cell.textLabel?.textColor = UIColor.green
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
                cell.textLabel?.textColor = UIColor.blue
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
                cell.textLabel?.textColor = UIColor.purple
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
                cell.textLabel?.textColor = UIColor.gray
                self.view.backgroundColor = UIColor.gray
            }
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Black" {
            tableView.backgroundColor = UIColor.black
            self.view.backgroundColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "White" {
            tableView.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Red" {
            tableView.backgroundColor = UIColor.red
            self.view.backgroundColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Orange" {
            tableView.backgroundColor = UIColor.orange
            self.view.backgroundColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Yellow" {
            tableView.backgroundColor = UIColor.yellow
            self.view.backgroundColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Green" {
            tableView.backgroundColor = UIColor.green
            self.view.backgroundColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Blue" {
            tableView.backgroundColor = UIColor.blue
            self.view.backgroundColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Purple" {
            tableView.backgroundColor = UIColor.purple
            self.view.backgroundColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Grey" {
            tableView.backgroundColor = UIColor.gray
        }
    }

    func loadTasks() {
        let taskListString = "tasks-" + String(userID)
        let userCountRef = db.child(taskListString)
        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let taskID = (child as AnyObject).key!
                self.taskIDs.append(taskID)
                self.tableView.reloadData()
            }
            
            for id in self.taskIDs {
                self.db.child(taskListString + "/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let name = (value?["name"] as? String)!
                    let category = (value?["category"] as? String)!
                    let importance = (value?["importance"] as? String)!
                    let date = (value?["date"] as? String)!
                    let time = (value?["time"] as? String)!
                    let reminder = (value?["reminder"] as? String)!
                    let task = Task(name: name, category: category, importance: importance, date: date, time: time, reminder: reminder)
                    self.myTaskDict[id] = task
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func userAlreadyExists() -> Bool {
        return UserDefaults.standard.object(forKey: "userID") != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if menuIsHidden {
            showMenu()
        }
        else {
            hideMenu()
        }
    }
    
    @IBAction func allTasksListClicked(_ sender: Any) {
        listTypeLabel.text = "All Tasks"
        hideMenu()
        taskIDs = []
        self.tableView.reloadData()
        loadTasks()
        homeworkList.tintColor = UIColor.appleBlue()
        choresList.tintColor = UIColor.appleBlue()
        errandsList.tintColor = UIColor.appleBlue()
        miscellaneousList.tintColor = UIColor.appleBlue()
        completedTasksList.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            allTasksList.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            allTasksList.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            allTasksList.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            allTasksList.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            allTasksList.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            allTasksList.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            allTasksList.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            allTasksList.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            allTasksList.tintColor = UIColor.gray
        }
    }
    @IBAction func homeworkClicked(_ sender: Any) {
        listTypeLabel.text = "Homework"
        hideMenu()
        taskIDs = []
        self.tableView.reloadData()
        let taskListString = "tasks-" + String(userID)
        let userCountRef = db.child(taskListString)
        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let taskID = (child as AnyObject).key!
                let childSnapshot = snapshot.childSnapshot(forPath: taskID).childSnapshot(forPath: "category")
                if childSnapshot.value as? String == "Homework" {
                    self.taskIDs.append(taskID)
                    self.tableView.reloadData()
                }
            }
        })
        allTasksList.tintColor = UIColor.appleBlue()
        choresList.tintColor = UIColor.appleBlue()
        errandsList.tintColor = UIColor.appleBlue()
        miscellaneousList.tintColor = UIColor.appleBlue()
        completedTasksList.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            homeworkList.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            homeworkList.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            homeworkList.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            homeworkList.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            homeworkList.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            homeworkList.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            homeworkList.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            homeworkList.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            homeworkList.tintColor = UIColor.gray
        }
    }
    
    @IBAction func choresClicked(_ sender: Any) {
        listTypeLabel.text = "Chores"
        hideMenu()
        taskIDs = []
        self.tableView.reloadData()
        let taskListString = "tasks-" + String(userID)
        let userCountRef = db.child(taskListString)
        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let taskID = (child as AnyObject).key!
                let childSnapshot = snapshot.childSnapshot(forPath: taskID).childSnapshot(forPath: "category")
                if childSnapshot.value as? String == "Chores" {
                    self.taskIDs.append(taskID)
                    self.tableView.reloadData()
                }
            }
        })
        allTasksList.tintColor = UIColor.appleBlue()
        homeworkList.tintColor = UIColor.appleBlue()
        errandsList.tintColor = UIColor.appleBlue()
        miscellaneousList.tintColor = UIColor.appleBlue()
        completedTasksList.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            choresList.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            choresList.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            choresList.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            choresList.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            choresList.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            choresList.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            choresList.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            choresList.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            choresList.tintColor = UIColor.gray
        }
    }
    @IBAction func errandsClicked(_ sender: Any) {
        listTypeLabel.text = "Errands"
        hideMenu()
        taskIDs = []
        self.tableView.reloadData()
        let taskListString = "tasks-" + String(userID)
        let userCountRef = db.child(taskListString)
        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let taskID = (child as AnyObject).key!
                let childSnapshot = snapshot.childSnapshot(forPath: taskID).childSnapshot(forPath: "category")
                if childSnapshot.value as? String == "Errands" {
                    self.taskIDs.append(taskID)
                    self.tableView.reloadData()
                }
            }
        })
        allTasksList.tintColor = UIColor.appleBlue()
        choresList.tintColor = UIColor.appleBlue()
        homeworkList.tintColor = UIColor.appleBlue()
        miscellaneousList.tintColor = UIColor.appleBlue()
        completedTasksList.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            errandsList.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            errandsList.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            errandsList.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            errandsList.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            errandsList.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            errandsList.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            errandsList.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            errandsList.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            errandsList.tintColor = UIColor.gray
        }
    }
    @IBAction func miscellaneousClicked(_ sender: Any) {
        listTypeLabel.text = "Miscellaneous"
        hideMenu()
        taskIDs = []
        self.tableView.reloadData()
        let taskListString = "tasks-" + String(userID)
        let userCountRef = db.child(taskListString)
        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let taskID = (child as AnyObject).key!
                let childSnapshot = snapshot.childSnapshot(forPath: taskID).childSnapshot(forPath: "category")
                if childSnapshot.value as? String == "Miscellaneous" {
                    self.taskIDs.append(taskID)
                    self.tableView.reloadData()
                }
            }
        })
        allTasksList.tintColor = UIColor.appleBlue()
        choresList.tintColor = UIColor.appleBlue()
        errandsList.tintColor = UIColor.appleBlue()
        homeworkList.tintColor = UIColor.appleBlue()
        completedTasksList.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            miscellaneousList.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            miscellaneousList.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            miscellaneousList.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            miscellaneousList.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            miscellaneousList.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            miscellaneousList.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            miscellaneousList.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            miscellaneousList.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            miscellaneousList.tintColor = UIColor.gray
        }
    }
    
    @IBAction func completedTasksClicked(_ sender: Any) {
        listTypeLabel.text = "Completed Tasks"
        hideMenu()
        taskIDs = []
        self.tableView.reloadData()
//        let taskListString = "tasks-" + String(userID)
//        let userCountRef = db.child(taskListString)
//        userCountRef.observeSingleEvent(of: .value, with: { snapshot in
//            for child in snapshot.children{
//                let taskID = (child as AnyObject).key!
//                let childSnapshot = snapshot.childSnapshot(forPath: taskID).childSnapshot(forPath: "category")
//                if childSnapshot.value as? String == "Miscellaneous" {
//                    self.taskIDs.append(taskID)
//                    self.tableView.reloadData()
//                }
//            }
//        })
        allTasksList.tintColor = UIColor.appleBlue()
        choresList.tintColor = UIColor.appleBlue()
        errandsList.tintColor = UIColor.appleBlue()
        homeworkList.tintColor = UIColor.appleBlue()
        miscellaneousList.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            completedTasksList.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            completedTasksList.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            completedTasksList.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            completedTasksList.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            completedTasksList.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            completedTasksList.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            completedTasksList.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            completedTasksList.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            completedTasksList.tintColor = UIColor.gray
        }
    }
    @IBAction func allTasksFilterClicked(_ sender: Any) {
        hideMenu()
        importanceOutlet.tintColor = UIColor.appleBlue()
        dueDateOutlet.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            priorityScoreOutlet.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            priorityScoreOutlet.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            priorityScoreOutlet.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            priorityScoreOutlet.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            priorityScoreOutlet.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            priorityScoreOutlet.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            priorityScoreOutlet.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            priorityScoreOutlet.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            priorityScoreOutlet.tintColor = UIColor.gray
        }
    }
    
    @IBAction func importanceClicked(_ sender: Any) {
        hideMenu()
        priorityScoreOutlet.tintColor = UIColor.appleBlue()
        dueDateOutlet.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            importanceOutlet.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            importanceOutlet.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            importanceOutlet.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            importanceOutlet.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            importanceOutlet.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            importanceOutlet.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            importanceOutlet.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            importanceOutlet.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            importanceOutlet.tintColor = UIColor.gray
        }
    }
    
    @IBAction func dueDateClicked(_ sender: Any) {
        hideMenu()
        priorityScoreOutlet.tintColor = UIColor.appleBlue()
        importanceOutlet.tintColor = UIColor.appleBlue()
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            dueDateOutlet.tintColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            dueDateOutlet.tintColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            dueDateOutlet.tintColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            dueDateOutlet.tintColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            dueDateOutlet.tintColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            dueDateOutlet.tintColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            dueDateOutlet.tintColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            dueDateOutlet.tintColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            dueDateOutlet.tintColor = UIColor.gray
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !menuIsHidden {
            guard let touchPoint = touches.first?.view else { return }
            if touchPoint != menuStackView {
                hideMenu()
            }
        }
    }
    
    func showMenu() {
        menuLeadingConstraint.constant = 16
        tableLeadingConstraint.constant += 120
        menuIsHidden = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideMenu() {
        menuLeadingConstraint.constant = -100
        tableLeadingConstraint.constant -= 120
        menuIsHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskIDs.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuIsHidden {
            performSegue(withIdentifier: "editTaskSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aTask")
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Black" {
            cell.backgroundColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "White" {
            cell.backgroundColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Red" {
            cell.backgroundColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Orange" {
            cell.backgroundColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Yellow" {
            cell.backgroundColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Green" {
            cell.backgroundColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Blue" {
            cell.backgroundColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Purple" {
            cell.backgroundColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Grey" {
            cell.backgroundColor = UIColor.gray
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            cell.textLabel?.textColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            cell.textLabel?.textColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            cell.textLabel?.textColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            cell.textLabel?.textColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            cell.textLabel?.textColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            cell.textLabel?.textColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            cell.textLabel?.textColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            cell.textLabel?.textColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            cell.textLabel?.textColor = UIColor.gray
        }
        cell.textLabel?.text = myTaskDict[taskIDs[indexPath.row]]?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //FIXME delete from Firebase
            // Create a reference to the file to delete
            db = Database.database().reference()
            let taskListString = "tasks-" + String(userID)
            let deletedTask = db.child(taskListString).child(taskIDs[indexPath.row])
            
            // Delete the file
            deletedTask.removeValue()
            taskIDs.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.taskIDs[sourceIndexPath.row]
//        taskIDs.remove(at: sourceIndexPath.row)
//        taskIDs.insert(movedObject, at: destinationIndexPath.row)
//        // To check for correctness enable: self.tableView.reloadData()
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let clickedTask = segue.destination as? EditTaskViewController,
            let taskIndex = tableView.indexPathForSelectedRow?.row,
            let send = sender as? Task {
            clickedTask.category = send.category
            clickedTask.taskName = taskIDs[taskIndex]
        }
    }
    
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue) {}
}


