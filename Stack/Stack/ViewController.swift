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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuStackView: UIStackView!
    var menuIsHidden = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var newListOutlet: UIButton!
    @IBOutlet weak var dueDateOutlet: UIButton!
    @IBOutlet weak var listTypeLabel: UILabel!
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
        menuStackView.setCustomSpacing(15.0, after: newListOutlet)
        menuStackView.setCustomSpacing(30.0, after: dueDateOutlet)
        setColors()
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
            }
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Black" {
            tableView.backgroundColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "White" {
            tableView.backgroundColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Red" {
            tableView.backgroundColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Orange" {
            tableView.backgroundColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Yellow" {
            tableView.backgroundColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Green" {
            tableView.backgroundColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Blue" {
            tableView.backgroundColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Purple" {
            tableView.backgroundColor = UIColor.purple
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
    
    @IBAction func newListClicked(_ sender: Any) {
        let newListPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newListPopUpID") as! AddListViewController
        self.addChildViewController(newListPopUp)
        newListPopUp.view.frame = self.view.frame
        self.view.addSubview(newListPopUp.view)
        newListPopUp.didMove(toParentViewController: self)
        hideMenu()
    }
    
    @IBAction func allTasksListClicked(_ sender: Any) {
        listTypeLabel.text = "All Tasks"
    }
    @IBAction func homeworkClicked(_ sender: Any) {
        listTypeLabel.text = "Homework"
//        taskIDs = []
//        let taskListString = "tasks-" + String(userID)
//        let homework = taskListString.observe(.value, with: { snapshot in
//            for child in snapshot.children {
//                let childSnapshot = snapshot.childSnapshotForPath(child.key)
//                if childSnapshot.value["Category"] as? String == "Homework" {
//                    let taskName = snapshot.childSnapshotForPath(child.key).value["name"] as? String
//                    taskIDs.append(taskName)
//                }
//            }
//        })
        
    }
    
    @IBAction func choresClicked(_ sender: Any) {
        listTypeLabel.text = "Chores"
    }
    @IBAction func errandsClicked(_ sender: Any) {
        listTypeLabel.text = "Errands"
    }
    @IBAction func miscellaneousClicked(_ sender: Any) {
        listTypeLabel.text = "Miscellaneous"
    }
    
    @IBAction func allTasksFilterClicked(_ sender: Any) {
        
    }
    
    @IBAction func importanceClicked(_ sender: Any) {
        
    }
    
    @IBAction func dueDateClicked(_ sender: Any) {
        
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


