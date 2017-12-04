//
//  AboutViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 12/3/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
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
    }
}
