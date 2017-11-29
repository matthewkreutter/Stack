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

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
}

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
        UserDefaults.standard.string(forKey: "backgroundColor")
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = myTaskDict[taskIDs[indexPath.row]]?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //FIXME delete from Firebase
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


