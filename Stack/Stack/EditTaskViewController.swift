//
//  EditTaskViewController.swift
//  Stack
//
//  Created by Marc VandenBerg on 11/19/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var taskName: String?
    var category: String?
    var importance: Int?
    var date: String?
    var time: String?
    var reminder: String?
    var categoryOption = ["Homework", "Chores", "Errands", "Miscellaneous"]
    var importanceOption = ["1","2","3","4","5","6","7","8","9","10"]
    var reminderOption = ["1 Day","2 Days","3 Days","4 Days","5 Days", "6 Days", "7 Days"]
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var importanceField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var reminderField: UITextField!
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let categoryView = UIPickerView()
    let importanceView = UIPickerView()
    let reminderView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        dateFormatter.dateStyle = .short
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
            categoryField.text = categoryOption[row]
            categoryField.endEditing(true)
        }
        else if pickerView == importanceView {
            importanceField.text = importanceOption[row]
            importanceField.endEditing(true)
        }
        else if pickerView == reminderView {
            reminderField.text = reminderOption[row]
            reminderField.endEditing(true)
        }
    }
}
