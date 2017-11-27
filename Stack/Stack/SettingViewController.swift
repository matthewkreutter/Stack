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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorView.delegate = self
        backgroundColorView.dataSource = self
        backgroundColorField.inputView = backgroundColorView
        textColorView.delegate = self
        textColorView.dataSource = self
        textColorField.inputView = textColorView
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
    
    @IBAction func signOutPressed(_ sender: Any) {
        let signOutPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signOutPopUpID") as! SigningOutViewController
        self.addChildViewController(signOutPopUp)
        signOutPopUp.view.frame = self.view.frame
        self.view.addSubview(signOutPopUp.view)
        signOutPopUp.didMove(toParentViewController: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
            if backgroundColorOption[row] == "Black" {
                backgroundColorField.backgroundColor = UIColor.black
            }
            if backgroundColorOption[row] == "White" {
                backgroundColorField.backgroundColor = UIColor.white
            }
            if backgroundColorOption[row] == "Red" {
                backgroundColorField.backgroundColor = UIColor.red
            }
            if backgroundColorOption[row] == "Orange" {
                backgroundColorField.backgroundColor = UIColor.orange
            }
            if backgroundColorOption[row] == "Yellow" {
                backgroundColorField.backgroundColor = UIColor.yellow
            }
            if backgroundColorOption[row] == "Green" {
                backgroundColorField.backgroundColor = UIColor.green
            }
            if backgroundColorOption[row] == "Blue" {
                backgroundColorField.backgroundColor = UIColor.blue
            }
            if backgroundColorOption[row] == "Purple" {
                backgroundColorField.backgroundColor = UIColor.purple
            }
            if backgroundColorOption[row] == "Grey" {
                backgroundColorField.backgroundColor = UIColor.gray
            }
            backgroundColorField.textColor = UIColor.white
            if backgroundColorOption[row] == "White" {
                backgroundColorField.textColor = UIColor.black
            }
            if backgroundColorOption[row] == "Yellow" {
                backgroundColorField.textColor = UIColor.black
            }
            backgroundColorField.text = backgroundColorOption[row]
            backgroundColorField.endEditing(true)
        }
        else if pickerView == textColorView {
            if textColorOption[row] == "Black" {
                textColorField.backgroundColor = UIColor.black
            }
            if textColorOption[row] == "White" {
                textColorField.backgroundColor = UIColor.white
            }
            if textColorOption[row] == "Red" {
                textColorField.backgroundColor = UIColor.red
            }
            if textColorOption[row] == "Orange" {
                textColorField.backgroundColor = UIColor.orange
            }
            if textColorOption[row] == "Yellow" {
                textColorField.backgroundColor = UIColor.yellow
            }
            if textColorOption[row] == "Green" {
                textColorField.backgroundColor = UIColor.green
            }
            if textColorOption[row] == "Blue" {
                textColorField.backgroundColor = UIColor.blue
            }
            if textColorOption[row] == "Purple" {
                textColorField.backgroundColor = UIColor.purple
            }
            if textColorOption[row] == "Grey" {
                textColorField.backgroundColor = UIColor.gray
            }
            textColorField.textColor = UIColor.white
            if textColorOption[row] == "White" {
                textColorField.textColor = UIColor.black
            }
            if textColorOption[row] == "Yellow" {
                textColorField.textColor = UIColor.black
            }
            textColorField.text = textColorOption[row]
            textColorField.endEditing(true)
        }
    }
}
