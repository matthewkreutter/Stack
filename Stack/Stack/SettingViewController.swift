//
//  SettingViewController.swift
//  Stack
//
//  Created by Marc VandenBerg on 11/20/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var backgroundColorField: UITextField!
    @IBOutlet weak var textColorField: UITextField!
    let backgroundColorView = UIPickerView()
    let textColorView = UIPickerView()
    
    var backgroundColorOption = ["Black", "White", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Grey"]
    var textColorOption = ["Black", "White", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Grey"]
    var selectedBackground: String {
        return UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    }
    var selectedText: String {
        return UserDefaults.standard.string(forKey: "textColor") ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundColorView.delegate = self
        backgroundColorView.dataSource = self
        backgroundColorField.inputView = backgroundColorView
        textColorView.delegate = self
        textColorView.dataSource = self
        textColorField.inputView = textColorView
        backgroundColorField.text = UserDefaults.standard.string(forKey: "backgroundColor")
        textColorField.text = UserDefaults.standard.string(forKey: "textColor")
        setBackgroundColor()
        setTextColor()
        createPicker()
        if let backgroundRow = backgroundColorOption.index(of: selectedBackground) {
            backgroundColorView.selectRow(backgroundRow, inComponent: 0, animated: false)
        }
        if let textRow = textColorOption.index(of: selectedText) {
            textColorView.selectRow(textRow, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func resetSettingsPressed(_ sender: Any) {
        let resetSettingsPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resetSettingsPopUpID") as! ResetSettingsViewController
        self.addChildViewController(resetSettingsPopUp)
        resetSettingsPopUp.view.frame = self.view.frame
        self.view.addSubview(resetSettingsPopUp.view)
        resetSettingsPopUp.didMove(toParentViewController: self)
    }
    
    @IBAction func resetTasksPressed(_ sender: Any) {
        let resetTasksPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resetTasksPopUpID") as! ResetTasksViewController
        self.addChildViewController(resetTasksPopUp)
        resetTasksPopUp.view.frame = self.view.frame
        self.view.addSubview(resetTasksPopUp.view)
        resetTasksPopUp.didMove(toParentViewController: self)
    }
    
    func createPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerPressed))
        toolBar.setItems([doneButton], animated: false)
        backgroundColorField.inputAccessoryView = toolBar
        backgroundColorField.inputView = backgroundColorView
        textColorField.inputAccessoryView = toolBar
        textColorField.inputView = textColorView
    }
    
    @objc func donePickerPressed() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func setBackgroundColor() {
        if backgroundColorField.text == "Black" {
            backgroundColorField.backgroundColor = UIColor.black
        }
        if backgroundColorField.text == "White" {
            backgroundColorField.backgroundColor = UIColor.white
        }
        if backgroundColorField.text == "Red" {
            backgroundColorField.backgroundColor = UIColor.red
        }
        if backgroundColorField.text == "Orange" {
            backgroundColorField.backgroundColor = UIColor.orange
        }
        if backgroundColorField.text == "Yellow" {
            backgroundColorField.backgroundColor = UIColor.yellow
        }
        if backgroundColorField.text == "Green" {
            backgroundColorField.backgroundColor = UIColor.green
        }
        if backgroundColorField.text == "Blue" {
            backgroundColorField.backgroundColor = UIColor.blue
        }
        if backgroundColorField.text == "Purple" {
            backgroundColorField.backgroundColor = UIColor.purple
        }
        if backgroundColorField.text == "Grey" {
            backgroundColorField.backgroundColor = UIColor.gray
        }
        backgroundColorField.textColor = UIColor.white
        if backgroundColorField.text == "White" {
            backgroundColorField.textColor = UIColor.black
        }
        if backgroundColorField.text == "Yellow" {
            backgroundColorField.textColor = UIColor.black
        }
    }
    
    func setTextColor() {
        if textColorField.text == "Black" {
            textColorField.backgroundColor = UIColor.black
        }
        if textColorField.text == "White" {
            textColorField.backgroundColor = UIColor.white
        }
        if textColorField.text == "Red" {
            textColorField.backgroundColor = UIColor.red
        }
        if textColorField.text == "Orange" {
            textColorField.backgroundColor = UIColor.orange
        }
        if textColorField.text == "Yellow" {
            textColorField.backgroundColor = UIColor.yellow
        }
        if textColorField.text == "Green" {
            textColorField.backgroundColor = UIColor.green
        }
        if textColorField.text == "Blue" {
            textColorField.backgroundColor = UIColor.blue
        }
        if textColorField.text == "Purple" {
            textColorField.backgroundColor = UIColor.purple
        }
        if textColorField.text == "Grey" {
            textColorField.backgroundColor = UIColor.gray
        }
        textColorField.textColor = UIColor.white
        if textColorField.text == "White" {
            textColorField.textColor = UIColor.black
        }
        if textColorField.text == "Yellow" {
            textColorField.textColor = UIColor.black
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == backgroundColorView {
            return backgroundColorOption.count
        }
        else if pickerView == textColorView {
            return textColorOption.count
        }
        return 10
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == backgroundColorView {
            return backgroundColorOption[row]
        }
        else if pickerView == textColorView {
            return textColorOption[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == backgroundColorView {
            backgroundColorField.text = backgroundColorOption[row]
            UserDefaults.standard.set(backgroundColorOption[row], forKey: "backgroundColor")
            setBackgroundColor()
        }
        else if pickerView == textColorView {
            textColorField.text = textColorOption[row]
            UserDefaults.standard.set(textColorOption[row], forKey: "textColor")
            setTextColor()
        }
    }
}
