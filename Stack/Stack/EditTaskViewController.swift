//
//  EditTaskViewController.swift
//  Stack
//
//  Created by Marc VandenBerg on 11/19/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import UserNotifications

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var taskName: String?
    var category: String?
    var importance: Int?
    var date: String?
    var time: String?
    var categoryOption = ["","Homework", "Chores", "Errands", "Miscellaneous"]
    var importanceOption = ["","1","2","3","4","5","6","7","8","9","10"]

    var db: DatabaseReference!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var importanceField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let categoryView = UIPickerView()
    let importanceView = UIPickerView()
    @IBOutlet weak var backgroundView: UIView!
    let userID = UserDefaults.standard.integer(forKey: "userID")
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPicker()
        createDatePicker()
        createTimePicker()
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryField.inputView = categoryView
        importanceView.delegate = self
        importanceView.dataSource = self
        importanceField.inputView = importanceView
        taskNameField.delegate = self
        db = Database.database().reference()
        taskNameField.layer.borderWidth = 2.0
        taskNameField.layer.borderColor = UIColor.black.cgColor
        taskNameField.layer.cornerRadius = 5.0
        categoryField.layer.borderWidth = 2.0
        categoryField.layer.borderColor = UIColor.black.cgColor
        categoryField.layer.cornerRadius = 5.0
        importanceField.layer.borderWidth = 2.0
        importanceField.layer.borderColor = UIColor.black.cgColor
        importanceField.layer.cornerRadius = 5.0
        dateField.layer.borderWidth = 2.0
        dateField.layer.borderColor = UIColor.black.cgColor
        dateField.layer.cornerRadius = 5.0
        timeField.layer.borderWidth = 2.0
        timeField.layer.borderColor = UIColor.black.cgColor
        timeField.layer.cornerRadius = 5.0
        if (task != nil) {
            taskNameField.text = task.name
            categoryField.text = task.category
            importanceField.text = String(task.importance)
            if (task.date == "April 24, 3000") {
                dateField.text = "Date"
            } else {
                dateField.text = task.date
            }
            timeField.text = task.time
        }
        var selectedName: String {
            return taskNameField.text ?? ""
        }
        var selectedCategory: String {
            return categoryField.text ?? ""
        }
        var selectedImportance: String {
            return importanceField.text ?? ""
        }
        var selectedDate: String {
            return dateField.text ?? ""
        }
        var selectedTime: String {
            return timeField.text ?? ""
        }
        if let categoryRow = categoryOption.index(of: selectedCategory) {
            categoryView.selectRow(categoryRow, inComponent: 0, animated: false)
        }
        if let importanceRow = importanceOption.index(of: selectedImportance) {
            importanceView.selectRow(importanceRow, inComponent: 0, animated: false)
        }
        let dateString = dateField.text
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        let date = df.date(from: dateString!)
        if let unwrappedDate = date {
            datePicker.setDate(unwrappedDate, animated: false)
        }
        let timeString = timeField.text
        let tf = DateFormatter()
        tf.dateFormat = "h:mm a"
        let time = tf.date(from: timeString!)
        if let unwrappedTime = time {
            timePicker.setDate(unwrappedTime, animated: false)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        db = Database.database().reference()
        let taskListString = "tasks-" + String(userID)
        let deletedTask = db.child(taskListString).child(task.id)

        // Delete the file
        deletedTask.removeValue()
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        if ((taskNameField.text?.isEmpty)! || taskNameField.text == "Task Name") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have a task name!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if ((categoryField.text?.isEmpty)! || categoryField.text == "Category") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have a category!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if ((importanceField.text?.isEmpty)! || importanceField.text == "Importance") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have an importance level!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            // push new task to database
            var timeDifference = 0.0
            var dateString = ""
            if (dateField.text == "" || dateField.text == "Date") {
                timeDifference = 5
                dateString = "April 24, 3000"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                let formattedDate = dateFormatter.date(from: dateField.text!)
                let currentDate = Date()
                timeDifference = (formattedDate?.timeIntervalSince(currentDate))! / 1000000.0
                dateString = dateField.text!
            }
        let tempImportance = importanceField.text!
        let priority = abs(Double(tempImportance)! / timeDifference)
        let intImportance = Int(tempImportance)
        let newTask = [
            "name": taskNameField.text as Any,
            "category": categoryField.text as Any,
            "importance": intImportance as Any,
            "date": dateString as Any,
            "time": timeField.text as Any,
            "priority": priority as Any
            ] as [String: Any]
        
        let myTaskString = "tasks-" + String(UserDefaults.standard.integer(forKey: "userID"))
        self.db.child(myTaskString).child(task.id).setValue(newTask)
            
            // alert for SUCCESS
            let alert = UIAlertController(title: "Task Updated!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in self.performSegue(withIdentifier: "backToTasksEdit", sender: self)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        let newTask = [
            "name": taskNameField.text as Any
            ] as [String: Any]
        
        let myTaskString = "completedTasks-" + String(UserDefaults.standard.integer(forKey: "userID"))
        self.db.child(myTaskString).childByAutoId().setValue(newTask)
        db = Database.database().reference()
        let taskListString = "tasks-" + String(userID)
        let deletedTask = db.child(taskListString).child(task.id)
        
        // Delete the file
        deletedTask.removeValue()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
    }
    
    func setColors() {
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Black" {
            backgroundView.backgroundColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "White" {
            backgroundView.backgroundColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Red" {
            backgroundView.backgroundColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Orange" {
            backgroundView.backgroundColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Yellow" {
            backgroundView.backgroundColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Green" {
            backgroundView.backgroundColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Blue" {
            backgroundView.backgroundColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Purple" {
            backgroundView.backgroundColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "backgroundColor") == "Grey" {
            backgroundView.backgroundColor = UIColor.gray
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Black" {
            importanceField.textColor = UIColor.black
            categoryField.textColor = UIColor.black
            dateField.textColor = UIColor.black
            timeField.textColor = UIColor.black
            taskNameField.textColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            importanceField.textColor = UIColor.white
            categoryField.textColor = UIColor.white
            dateField.textColor = UIColor.white
            timeField.textColor = UIColor.white
            taskNameField.textColor = UIColor.white
            importanceField.backgroundColor = UIColor.black
            categoryField.backgroundColor = UIColor.black
            dateField.backgroundColor = UIColor.black
            timeField.backgroundColor = UIColor.black
            taskNameField.backgroundColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            importanceField.textColor = UIColor.red
            categoryField.textColor = UIColor.red
            dateField.textColor = UIColor.red
            timeField.textColor = UIColor.red
            taskNameField.textColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            importanceField.textColor = UIColor.orange
            categoryField.textColor = UIColor.orange
            dateField.textColor = UIColor.orange
            timeField.textColor = UIColor.orange
            taskNameField.textColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            importanceField.textColor = UIColor.yellow
            categoryField.textColor = UIColor.yellow
            dateField.textColor = UIColor.yellow
            timeField.textColor = UIColor.yellow
            taskNameField.textColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            importanceField.textColor = UIColor.green
            categoryField.textColor = UIColor.green
            dateField.textColor = UIColor.green
            timeField.textColor = UIColor.green
            taskNameField.textColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            importanceField.textColor = UIColor.blue
            categoryField.textColor = UIColor.blue
            dateField.textColor = UIColor.blue
            timeField.textColor = UIColor.blue
            taskNameField.textColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            importanceField.textColor = UIColor.purple
            categoryField.textColor = UIColor.purple
            dateField.textColor = UIColor.purple
            timeField.textColor = UIColor.purple
            taskNameField.textColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            importanceField.textColor = UIColor.gray
            categoryField.textColor = UIColor.gray
            dateField.textColor = UIColor.gray
            timeField.textColor = UIColor.gray
            taskNameField.textColor = UIColor.gray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameField.resignFirstResponder()
        return true
    }
    
    func createPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerPressed))
        toolBar.setItems([doneButton], animated: false)
        categoryField.inputAccessoryView = toolBar
        categoryField.inputView = categoryView
        importanceField.inputAccessoryView = toolBar
        importanceField.inputView = importanceView
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: false)
        dateField.inputAccessoryView = toolBar
        dateField.inputView = datePicker
    }
    
    func createTimePicker() {
        timePicker.datePickerMode = .time
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneTimeButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTimePressed))
        toolBar.setItems([doneTimeButton], animated: false)
        timeField.inputAccessoryView = toolBar
        timeField.inputView = timePicker
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneTimePressed() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeField.text = timeFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func donePickerPressed() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryView {
            return categoryOption.count
        }
        else if pickerView == importanceView {
            return importanceOption.count
        }
        return 10
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryView {
            return categoryOption[row]
        }
        else if pickerView == importanceView {
            return importanceOption[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryView {
            if (categoryOption[row] != "") {
                categoryField.text = categoryOption[row]
            }
            else {
                categoryField.text = "Category"
            }
        }
        else if pickerView == importanceView {
            if (importanceOption[row] != "") {
                importanceField.text = importanceOption[row]
            }
            else {
                importanceField.text = "Importance"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        importanceField.resignFirstResponder()
        categoryField.resignFirstResponder()
        dateField.resignFirstResponder()
        timeField.resignFirstResponder()
        taskNameField.resignFirstResponder()
    }
}
