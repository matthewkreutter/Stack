//
//  EditTaskViewController.swift
//  Stack
//
//  Created by Marc VandenBerg on 11/19/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var taskName: String?
    var category: String?
    var importance: Int?
    var date: String?
    var time: String?
    var reminder: String?
    var categoryOption = ["Homework", "Chores", "Errands", "Miscellaneous"]
    var importanceOption = ["1","2","3","4","5","6","7","8","9","10"]
    var reminderNumOption = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60",]
    var reminderOption = ["Minutes","Hours","Days","Weeks"]
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == categoryField) {
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolBar.sizeToFit()
//            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditTaskViewController.donePickerClick))
            toolBar.setItems([doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            categoryField.inputAccessoryView = toolBar
        }
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
            categoryField.text = categoryOption[row]
            categoryField.endEditing(true)
        }
        else if pickerView == importanceView {
            importanceField.text = importanceOption[row]
            importanceField.endEditing(true)
        }
        else if pickerView == reminderView {
            reminderField.text = reminderNumOption[row] + " " + reminderOption[row]
            reminderField.endEditing(true)
        }
    }
}
