//
//  SettingsViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/5/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import TransitionButton
import PMAlertController
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: TransitionButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var librariesButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var versionLabel: UITextView!
    
    var ref: DatabaseReference!
    var snapshot = DataSnapshot()
    
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = version
        
        //Get user data and save current bugs (to count children in the database).
        self.ref = Database.database().reference()
        self.ref.child("users/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value, with: { (dataSnap) in
            self.welcomeLabel.text = "Hello, \(dataSnap.childSnapshot(forPath: "firstName").value as! String)"
        })
        self.ref.child("bugs").observeSingleEvent(of: .value, with: { (dataSnap) in
            self.snapshot = dataSnap
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        privacyButton.isEnabled = true
        librariesButton.isEnabled = true
        
        //Add the bug report button and also configure the navigation bar (just how we want it; to look nice and match the view).
        let mainvc = self.parent as! MainViewController
        mainvc.navigationItem.title = "Settings"
        mainvc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Bug?", style: .done, target: self, action: #selector(reportBug))
    }
    
    @objc func reportBug() {
        //Show the alert to present the user with the fields to fill the big report out.
        let alertVC = PMAlertController(title: "Report Bug", description: "Find a bug?  Please use the form below to send in a bug report.", image: nil, style: .alert)
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Bug title"
        }
        alertVC.addTextField { (textField) in
            textField?.placeholder = "View affected"
        }
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Description"
        }
        alertVC.addAction(PMAlertAction(title: "Send", style: .default, action: { () in
            //Send that data nice and safely to the server so we can check that bug report out and fix it ASAP (as long as the user has entered all the data, of course).
            if alertVC.textFields[0].text != "" && alertVC.textFields[1].text != "" && alertVC.textFields[2].text != "" {
                let bugNumber = Int(self.snapshot.childrenCount)
                self.ref.child("bugs/\(bugNumber)/title").setValue(alertVC.textFields[0].text ?? "")
                self.ref.child("bugs/\(bugNumber)/view").setValue(alertVC.textFields[1].text ?? "")
                self.ref.child("bugs/\(bugNumber)/description").setValue(alertVC.textFields[2].text ?? "")
                self.ref.child("bugs/\(bugNumber)/user").setValue("\(Auth.auth().currentUser!.uid)")
                self.showAlert(title: "Completed", message: "Your bug report has been successfully sent!")
            }else{
                self.showAlert(title: "Field error", message: "Please make sure to fill out all the fields in order to send a bug report.")
            }
        }))
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String){
        let alertVC = PMAlertController(title: title, description: message, image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ button: TransitionButton) {
        //If the user wants to signout, handle their request here.
        privacyButton.isEnabled = false
        librariesButton.isEnabled = false
        logoutButton.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                self.navigationController?.popViewController(animated: true)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                button.stopAnimation(animationStyle: .expand, completion: {
                    let vcController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    self.present(vcController, animated: false, completion: nil)
                })
            })
        })
    }
    
    @IBAction func privacyAction(_ sender: Any) {
        //Show the privacy and terms of service page (in case the user is bored and wants to do some reading).
        let termsVC = termsViewController(nibName: "termsViewController", bundle: nil)
        termsVC.navigationItem.title = "TOS & Privacy"
        termsVC.navigationItem.rightBarButtonItem = nil
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @IBAction func librariesAction(_ sender: Any) {
        //Show the libraries so we can give credit to those awesome people who make dependencies and allow others to use then for free.
        let librariesVC = LibrariesViewController(nibName: "LibrariesViewController", bundle: nil)
        librariesVC.navigationItem.title = "Libraries"
        librariesVC.navigationItem.rightBarButtonItem = nil
        librariesVC.navigationController?.view.backgroundColor = UIColor.white
        librariesVC.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.pushViewController(librariesVC, animated: true)
    }
    
}
