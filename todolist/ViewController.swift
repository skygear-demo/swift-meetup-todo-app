//
//  ViewController.swift
//  todolist
//
//  Created by david90 on 09/08/2016.
//  Copyright (c) 2016 david90. All rights reserved.
//

import UIKit
import SKYKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateLoginStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLoginStatus() {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        if ((SKYContainer.defaultContainer().currentUserRecordID) != nil) {
            loginStatusLabel.text = "Logged in"
            loginButton.enabled = false
            signupButton.enabled = false
            logoutButton.enabled = true
        } else {
            loginStatusLabel.text = "Not logged in"
            loginButton.enabled = true
            signupButton.enabled = true
            logoutButton.enabled = false
        }
    }
    
    func showAlert(error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func didTapLogin(sender: AnyObject) {
        SKYContainer.defaultContainer().loginWithUsername(usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error)
                return
            }
            NSLog("Logged in as: %@", user)
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapSignup(sender: AnyObject) {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        SKYContainer.defaultContainer().signupWithUsername(usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error)
                return
            }
            NSLog("Signed up as: %@", user)
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapLogout(sender: AnyObject) {
        SKYContainer.defaultContainer().logoutWithCompletionHandler { (user, error) in
            if (error != nil) {
                self.showAlert(error)
                return
            }
            NSLog("Logged out")
            self.updateLoginStatus()
        }
    }
}

