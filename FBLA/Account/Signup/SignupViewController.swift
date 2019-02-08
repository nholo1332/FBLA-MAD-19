//
//  SignupViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/26/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import TransitionButton
import TextFieldEffects
import PMAlertController
import NVActivityIndicatorView
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailField: MadokaTextField!
    @IBOutlet weak var firstNameField: MadokaTextField!
    @IBOutlet weak var lastNameField: MadokaTextField!
    @IBOutlet weak var passwordField: MadokaTextField!
    @IBOutlet weak var signupButton: TransitionButton!
    
    let controller = UIAlertController()
    
    let userRef = Database.database().reference().child("users")

    override func viewDidLoad() {
        super.viewDidLoad()
        //Some setup here (very similar to the login view)
        addKeyboardObservers()
    }
    
    @IBAction func termsPolicyAction(_ sender: Any) {
        //Allow the users to see our privacy policy before they decide to use the app and signup.
        let termsView = signupTermsViewController(nibName: "signupTermsViewController", bundle: nil)
        let alertController = UIAlertController(title: "Terms of Service and Privacy", message: "", preferredStyle: .alert)
        alertController.setValue(termsView, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let vcController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.present(vcController, animated: false, completion: nil)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        signupButton.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            if (!self.fieldsAreFilled()) {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.signupButton.stopAnimation(animationStyle: .shake, completion: {
                        self.showError(title: "Field error", message: "Please fill all the fiels before attempting to signup for an account.")
                    })
                })
                return
            }
            
            if (self.profileSettingsAreAdequate()) {
                Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                    
                    if let error = error {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                        self.signupButton.stopAnimation(animationStyle: .shake, completion: {
                                self.showError(title: "Error", message: "Error: \(error.localizedDescription)")
                            })
                        })
                        
                        return
                    }
                    
                    self.userRef.child((user?.user.uid)!).setValue(
                        ["firstName" : self.firstNameField.text!,
                         "lastName" : self.lastNameField.text!
                        ]
                    ) {
                        (error:Error?, ref:DatabaseReference) in
                        //code here to send user to another View
                        DispatchQueue.main.async(execute: { () -> Void in
                        self.signupButton.stopAnimation(animationStyle: .expand, completion: {
                                let mainVC = MainViewController()
                                let navigationVC = UINavigationController(rootViewController: mainVC)
                                self.present(navigationVC, animated: true, completion: nil)
                            })
                        })
                    }
                }
            )}
        })
    }
    
    
    @objc func dismissKeyboard() {
        emailField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    private func addKeyboardObservers() {
        // Add gesture recognizer to handle tapping outside of keyboard
        let dismissKeyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    func showError(title: String, message: String){
        let alertVC = PMAlertController(title: title, description: message, image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func fieldsAreFilled() -> Bool {
        return self.emailField.text != "" && self.firstNameField.text != "" && self.lastNameField.text != "" && self.passwordField.text != ""
    }
    
    
    private func profileSettingsAreAdequate() -> Bool {
            guard let fname = firstNameField.text,
            let lname = lastNameField.text,
            let password = passwordField.text else { return false }
        
        for field in [fname, lname] {
            
            
            if (field.contains(".") || field.contains("$") || field.contains("#") ||
                field.contains("[") || field.contains("]") || field.contains("/") || field.contains(" ")) {
                
                showError(title: "Invalid characters", message: "Please make sure to use valid characters in the name fields.  Do no include '.','$','#','[',']','/', or ' '.")
                controller.dismiss(animated: true, completion: nil)
                return false
            }
        }
        
        if (password.count < 6) {
            showError(title: "Password too weak", message: "Please make a new password that consists of atleast ")
            return false
        }
        
        return true
    }

}
