//
//  AddTaskViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 11/18/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var importance: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var reminder: UITextField!
    var tasks: [String] = []
    var categoryOption = ["","Homework", "Chores", "Errands", "Miscellaneous"]
    var importanceOption = ["","1","2","3","4","5","6","7","8","9","10"]
    var reminderNumOption = ["","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60",]
    var reminderOption = ["","Minutes","Hours","Days","Weeks"]
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let categoryView = UIPickerView()
    let importanceView = UIPickerView()
    let reminderView = UIPickerView()
    
    var db: DatabaseReference!
    
    override func viewDidLoad() {
        if let myTasks = UserDefaults.standard.array(forKey: "tasks") {
            tasks = myTasks as! [String]
        }
        createPicker()
        createDatePicker()
        createTimePicker()
        db = Database.database().reference()

        categoryView.delegate = self
        categoryView.dataSource = self
        category.inputView = categoryView
        importanceView.delegate = self
        importanceView.dataSource = self
        importance.inputView = importanceView
        reminderView.delegate = self
        reminderView.dataSource = self
        reminder.inputView = reminderView
        taskName.delegate = self
        taskName.layer.borderWidth = 2.0
        taskName.layer.borderColor = UIColor.black.cgColor
        taskName.layer.cornerRadius = 5.0
        category.layer.borderWidth = 2.0
        category.layer.borderColor = UIColor.black.cgColor
        category.layer.cornerRadius = 5.0
        importance.layer.borderWidth = 2.0
        importance.layer.borderColor = UIColor.black.cgColor
        importance.layer.cornerRadius = 5.0
        date.layer.borderWidth = 2.0
        date.layer.borderColor = UIColor.black.cgColor
        date.layer.cornerRadius = 5.0
        time.layer.borderWidth = 2.0
        time.layer.borderColor = UIColor.black.cgColor
        time.layer.cornerRadius = 5.0
        reminder.layer.borderWidth = 2.0
        reminder.layer.borderColor = UIColor.black.cgColor
        reminder.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
    }
    func setColors() {
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Black" {
                self.view.backgroundColor = UIColor.black
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "White" {
                self.view.backgroundColor = UIColor.white
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Red" {
                self.view.backgroundColor = UIColor.red
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Orange" {
                self.view.backgroundColor = UIColor.orange
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Yellow" {
                self.view.backgroundColor = UIColor.yellow
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Green" {
                self.view.backgroundColor = UIColor.green
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Blue" {
                self.view.backgroundColor = UIColor.blue
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Purple" {
                self.view.backgroundColor = UIColor.purple
            }
            if UserDefaults.standard.string(forKey: "backgroundColor") == "Grey" {
                self.view.backgroundColor = UIColor.gray
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Black" {
                importance.textColor = UIColor.black
                category.textColor = UIColor.black
                reminder.textColor = UIColor.black
                date.textColor = UIColor.black
                time.textColor = UIColor.black
                taskName.textColor = UIColor.black
            }
            if UserDefaults.standard.string(forKey: "textColor") == "White" {
                importance.textColor = UIColor.white
                category.textColor = UIColor.white
                reminder.textColor = UIColor.white
                date.textColor = UIColor.white
                time.textColor = UIColor.white
                taskName.textColor = UIColor.white
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Red" {
                importance.textColor = UIColor.red
                category.textColor = UIColor.red
                reminder.textColor = UIColor.red
                date.textColor = UIColor.red
                time.textColor = UIColor.red
                taskName.textColor = UIColor.red
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
                importance.textColor = UIColor.orange
                category.textColor = UIColor.orange
                reminder.textColor = UIColor.orange
                date.textColor = UIColor.orange
                time.textColor = UIColor.orange
                taskName.textColor = UIColor.orange
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
                importance.textColor = UIColor.yellow
                category.textColor = UIColor.yellow
                reminder.textColor = UIColor.yellow
                date.textColor = UIColor.yellow
                time.textColor = UIColor.yellow
                taskName.textColor = UIColor.yellow
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Green" {
                importance.textColor = UIColor.green
                category.textColor = UIColor.green
                reminder.textColor = UIColor.green
                date.textColor = UIColor.green
                time.textColor = UIColor.green
                taskName.textColor = UIColor.green
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
                importance.textColor = UIColor.blue
                category.textColor = UIColor.blue
                reminder.textColor = UIColor.blue
                date.textColor = UIColor.blue
                time.textColor = UIColor.blue
                taskName.textColor = UIColor.blue
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
                importance.textColor = UIColor.purple
                category.textColor = UIColor.purple
                reminder.textColor = UIColor.purple
                date.textColor = UIColor.purple
                time.textColor = UIColor.purple
                taskName.textColor = UIColor.purple
            }
            if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
                importance.textColor = UIColor.gray
                category.textColor = UIColor.gray
                reminder.textColor = UIColor.gray
                date.textColor = UIColor.gray
                time.textColor = UIColor.gray
                taskName.textColor = UIColor.gray
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskName.resignFirstResponder()
        return true
    }
    
    func createPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerPressed))
        toolBar.setItems([doneButton], animated: false)
        category.inputAccessoryView = toolBar
        category.inputView = categoryView
        importance.inputAccessoryView = toolBar
        importance.inputView = importanceView
        reminder.inputAccessoryView = toolBar
        reminder.inputView = reminderView
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: false)
        date.inputAccessoryView = toolBar
        date.inputView = datePicker
    }
    
    func createTimePicker() {
        timePicker.datePickerMode = .time
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneTimeButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTimePressed))
        toolBar.setItems([doneTimeButton], animated: false)
        time.inputAccessoryView = toolBar
        time.inputView = timePicker
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        date.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneTimePressed() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        time.text = timeFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func donePickerPressed() {
        let num = reminderView.selectedRow(inComponent: 0)
        let numType = reminderView.selectedRow(inComponent: 1)
        let number = reminderNumOption[num]
        let numberType = reminderOption[numType]
        if (number == "" && numberType != "") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have a value!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (number != "" && numberType == "") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have a unit!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.view.endEditing(true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == reminderView {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryView {
            return categoryOption.count
        }
        else if pickerView == importanceView {
            return importanceOption.count
        }
        else if pickerView == reminderView {
            if (component == 0) {
                return reminderNumOption.count
            }
            else if (component == 1){
                return reminderOption.count
            }
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
        else if pickerView == reminderView {
            if (component == 0) {
                return reminderNumOption[row]
            }
            else if (component == 1){
                return reminderOption[row]
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryView {
            if (categoryOption[row] != "") {
                category.text = categoryOption[row]
            }
            else {
                category.text = "Category"
            }
        }
        else if pickerView == importanceView {
            if (importanceOption[row] != "") {
                importance.text = importanceOption[row]
            }
            else {
                importance.text = "Importance"
            }
        }
        else if pickerView == reminderView {
            let num = reminderView.selectedRow(inComponent: 0)
            let numType = reminderView.selectedRow(inComponent: 1)
            let number = reminderNumOption[num]
            let numberType = reminderOption[numType]
            if (number != "" && numberType != "") {
                reminder.text = number + " " + numberType
            }
            else if (number == "" && numberType == "") {
                reminder.text = "Reminder"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        importance.resignFirstResponder()
        category.resignFirstResponder()
        reminder.resignFirstResponder()
        date.resignFirstResponder()
        time.resignFirstResponder()
        taskName.resignFirstResponder()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if ((taskName.text?.isEmpty)! || taskName.text == "Task Name") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have a task name!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if ((category.text?.isEmpty)! || category.text == "Category") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have a category!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if ((importance.text?.isEmpty)! || importance.text == "Importance") {
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure you have an importance level!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            // push new task to database
            var timeDifference = 0.0
            if (date.text == "" || date.text == "Date") {
                timeDifference = 2.6
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                let formattedDate = dateFormatter.date(from: date.text!)
                let currentDate = Date()
                timeDifference = (formattedDate?.timeIntervalSince(currentDate))! / 1000000.0
            }
            
            //The larget the priority number, the higher the priority
            let tempImportance = importance.text!
            let priority = abs(Double(tempImportance)! / timeDifference)
            let newTask = [
                "name": taskName.text as Any,
                "category": category.text as Any,
                "importance": importance.text as Any,
                "date": date.text as Any,
                "time": time.text as Any,
                "reminder": reminder.text as Any,
                "priority": priority as Any
                ] as [String: Any]
            
            let myTaskString = "tasks-" + String(UserDefaults.standard.integer(forKey: "userID"))
            self.db.child(myTaskString).childByAutoId().setValue(newTask)
            
            // alert for SUCCESS
            let alert = UIAlertController(title: "Task Posted!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in self.performSegue(withIdentifier: "backToTasks", sender: self)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
