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

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var taskName: String?
    var category: String?
    var importance: Int?
    var date: String?
    var time: String?
    var reminder: String?
    var categoryOption = ["","Homework", "Chores", "Errands", "Miscellaneous"]
    var importanceOption = ["","1","2","3","4","5","6","7","8","9","10"]
    var reminderNumOption = ["","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60",]
    var reminderOption = ["","Minutes","Hours","Days","Weeks"]
    var db: DatabaseReference!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var importanceField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var reminderField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let categoryView = UIPickerView()
    let importanceView = UIPickerView()
    let reminderView = UIPickerView()
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
        reminderView.delegate = self
        reminderView.dataSource = self
        reminderField.inputView = reminderView
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
        reminderField.layer.borderWidth = 2.0
        reminderField.layer.borderColor = UIColor.black.cgColor
        reminderField.layer.cornerRadius = 5.0
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
            reminderField.text = task.reminder
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        db = Database.database().reference()
//        let taskListString = "tasks-" + String(userID)
//        let deletedTask = db.child(taskListString).child(taskIDs[indexPath.row])
//
//        // Delete the file
//        deletedTask.removeValue()
//        taskIDs.remove(at: indexPath.row)
//        tableView.reloadData()
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
            reminderField.textColor = UIColor.black
            dateField.textColor = UIColor.black
            timeField.textColor = UIColor.black
            taskNameField.textColor = UIColor.black
        }
        if UserDefaults.standard.string(forKey: "textColor") == "White" {
            importanceField.textColor = UIColor.white
            categoryField.textColor = UIColor.white
            reminderField.textColor = UIColor.white
            dateField.textColor = UIColor.white
            timeField.textColor = UIColor.white
            taskNameField.textColor = UIColor.white
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Red" {
            importanceField.textColor = UIColor.red
            categoryField.textColor = UIColor.red
            reminderField.textColor = UIColor.red
            dateField.textColor = UIColor.red
            timeField.textColor = UIColor.red
            taskNameField.textColor = UIColor.red
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Orange" {
            importanceField.textColor = UIColor.orange
            categoryField.textColor = UIColor.orange
            reminderField.textColor = UIColor.orange
            dateField.textColor = UIColor.orange
            timeField.textColor = UIColor.orange
            taskNameField.textColor = UIColor.orange
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Yellow" {
            importanceField.textColor = UIColor.yellow
            categoryField.textColor = UIColor.yellow
            reminderField.textColor = UIColor.yellow
            dateField.textColor = UIColor.yellow
            timeField.textColor = UIColor.yellow
            taskNameField.textColor = UIColor.yellow
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Green" {
            importanceField.textColor = UIColor.green
            categoryField.textColor = UIColor.green
            reminderField.textColor = UIColor.green
            dateField.textColor = UIColor.green
            timeField.textColor = UIColor.green
            taskNameField.textColor = UIColor.green
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Blue" {
            importanceField.textColor = UIColor.blue
            categoryField.textColor = UIColor.blue
            reminderField.textColor = UIColor.blue
            dateField.textColor = UIColor.blue
            timeField.textColor = UIColor.blue
            taskNameField.textColor = UIColor.blue
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Purple" {
            importanceField.textColor = UIColor.purple
            categoryField.textColor = UIColor.purple
            reminderField.textColor = UIColor.purple
            dateField.textColor = UIColor.purple
            timeField.textColor = UIColor.purple
            taskNameField.textColor = UIColor.purple
        }
        if UserDefaults.standard.string(forKey: "textColor") == "Grey" {
            importanceField.textColor = UIColor.gray
            categoryField.textColor = UIColor.gray
            reminderField.textColor = UIColor.gray
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
        reminderField.inputAccessoryView = toolBar
        reminderField.inputView = reminderView
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
        else if pickerView == reminderView {
            let num = reminderView.selectedRow(inComponent: 0)
            let numType = reminderView.selectedRow(inComponent: 1)
            let number = reminderNumOption[num]
            let numberType = reminderOption[numType]
            if (number != "" && numberType != "") {
                reminderField.text = number + " " + numberType
            }
            else if (number == "" && numberType == "") {
                reminderField.text = "Reminder"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        importanceField.resignFirstResponder()
        categoryField.resignFirstResponder()
        reminderField.resignFirstResponder()
        dateField.resignFirstResponder()
        timeField.resignFirstResponder()
        taskNameField.resignFirstResponder()
    }
}
