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
            backgroundColorField.text = backgroundColorOption[row]
            backgroundColorField.endEditing(true)
        }
        else if pickerView == textColorView {
            textColorField.text = textColorOption[row]
            textColorField.endEditing(true)
        }
    }
}
