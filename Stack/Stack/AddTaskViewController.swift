//
//  AddTaskViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 11/18/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var importance: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var reminder: UITextField!
    var tasks: [String] = []
    var categoryOption = ["Homework", "Chores", "Errands", "Miscellaneous"]
    var importanceOption = ["1","2","3","4","5","6","7","8","9","10"]
    var reminderOption = ["1 Day","2 Days","3 Days","4 Days","5 Days", "6 Days", "7 Days"]
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let categoryView = UIPickerView()
    let importanceView = UIPickerView()
    let reminderView = UIPickerView()
    
    override func viewDidLoad() {
        if let myTasks = UserDefaults.standard.array(forKey: "tasks") {
            tasks = myTasks as! [String]
        }
        createDatePicker()
        createTimePicker()

        categoryView.delegate = self
        categoryView.dataSource = self
        category.inputView = categoryView
        importanceView.delegate = self
        importanceView.dataSource = self
        importance.inputView = importanceView
        reminderView.delegate = self
        reminderView.dataSource = self
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
        dateFormatter.dateStyle = .short
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
        else if pickerView == reminderView {
            return reminderOption.count
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
            return reminderOption[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryView {
            category.text = categoryOption[row]
            category.endEditing(true)
        }
        else if pickerView == importanceView {
            importance.text = importanceOption[row]
            importance.endEditing(true)
        }
        else if pickerView == reminderView {
            reminder.text = reminderOption[row]
            reminder.endEditing(true)
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
        //tasks.append(Task(name: taskName.text!, category: category.text!, importance: importance.text!, date: date.text!, time: time.text!, reminder: reminder.text!)
        //tasks.append(Task(name: "test", category: "test", importance: "test", date: "test", time: "test", reminder: "test"))
        tasks.append(taskName.text!)
        UserDefaults.standard.set(tasks, forKey: "tasks")
    }
}
