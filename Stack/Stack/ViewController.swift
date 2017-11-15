//
//  ViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 11/10/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuStackView: UIStackView!
    var menuIsHidden = true
    
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var newListOutlet: UIButton!
    @IBOutlet weak var dueDateOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.bringSubview(toFront: menuStackView)
        menuStackView.setCustomSpacing(15.0, after: listLabel)
        menuStackView.setCustomSpacing(15.0, after: filterLabel)
        menuStackView.setCustomSpacing(15.0, after: newListOutlet)
        menuStackView.setCustomSpacing(30.0, after: dueDateOutlet)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if menuIsHidden {
            showMenu()
        }
        else {
            hideMenu()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !menuIsHidden {
            guard let touchPoint = touches.first?.view else { return }
            if touchPoint != menuStackView {
                hideMenu()
            }
        }
    }
    
    func showMenu() {
        menuLeadingConstraint.constant = 16
        menuIsHidden = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideMenu() {
        menuLeadingConstraint.constant = -100
        menuIsHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue) {}
}


