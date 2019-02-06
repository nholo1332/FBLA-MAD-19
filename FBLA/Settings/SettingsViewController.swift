//
//  SettingsViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/5/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import TransitionButton
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: TransitionButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var librariesButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        self.ref.child("users/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            self.welcomeLabel.text = "Hello, \(snapshot.childSnapshot(forPath: "firstName").value as! String)"
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        privacyButton.isEnabled = true
        librariesButton.isEnabled = true
        
        let mainvc = self.parent as! MainViewController
        mainvc.navigationItem.title = "Settings"
    }
    
    @IBAction func logoutAction(_ button: TransitionButton) {
        privacyButton.isEnabled = false
        librariesButton.isEnabled = false
        logoutButton.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print(error.localizedDescription)
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
        let termsVC = termsViewController(nibName: "termsViewController", bundle: nil)
        termsVC.navigationItem.title = "TOS & Privacy"
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @IBAction func librariesAction(_ sender: Any) {
        let librariesVC = LibrariesViewController(nibName: "LibrariesViewController", bundle: nil)
        librariesVC.navigationItem.title = "Libraries"
        librariesVC.navigationController?.view.backgroundColor = UIColor.white
        librariesVC.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.pushViewController(librariesVC, animated: true)
    }
    
}
