//
//  ViewController.swift
//  Stack
//
//  Created by David Lee-Tolley on 11/10/17.
//  Copyright © 2017 David Lee-Tolley. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuStackView: UIStackView!
    var menuIsHidden = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var newListOutlet: UIButton!
    @IBOutlet weak var dueDateOutlet: UIButton!
    var tasks: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
        menuStackView.backgroundColor = UIColor.gray
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
    
    override func viewWillAppear(_ animated: Bool) {
        if let myTasks = UserDefaults.standard.array(forKey: "tasks") {
            tasks = myTasks as! [String]
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTaskSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tasks[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            tasks.remove(at: indexPath.row)
            UserDefaults.standard.set(tasks, forKey: "tasks")
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let clickedTask = segue.destination as? EditTaskViewController,
            let taskIndex = tableView.indexPathForSelectedRow?.row,
            let send = sender as? Task {
            clickedTask.category = send.category
            clickedTask.taskName = tasks[taskIndex]
        }
    }
    
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue) {}
}


