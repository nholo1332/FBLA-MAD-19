//
//  LoginViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/26/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase
import TransitionButton
import TextFieldEffects
import PMAlertController

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: MadokaTextField!
    @IBOutlet weak var passwordField: MadokaTextField!
    @IBOutlet weak var loginButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       addKeyboardObservers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        let vcController = SignupViewController(nibName: "SignupViewController", bundle: nil)
        self.present(vcController, animated: false, completion: nil)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alertVC = PMAlertController(title: "Reset Password", description: "Enter the email below you wish to reset the password for.", image: nil, style: .alert)
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Email"
            textField?.keyboardType = .emailAddress
        }
        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: { () in
            Auth.auth().sendPasswordReset(withEmail: alertVC.textFields[0].text ?? "", completion: { (error) in
                if error == nil {
                    let errorVC = PMAlertController(title: "Sent", description: "Check your inbox for a reset email.", image: nil, style: .alert)
                    errorVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
                    self.present(errorVC, animated: true, completion: nil)
                }else{
                    let errorVC = PMAlertController(title: "Error", description: "There was an error: \(error!.localizedDescription)", image: nil, style: .alert)
                    errorVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
                    self.present(errorVC, animated: true, completion: nil)
                }
            })
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ button: TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            if (!self.fieldsAreFilled()) {
                DispatchQueue.main.async(execute: { () -> Void in
                    button.stopAnimation(animationStyle: .shake, completion: {
                        
                        let alertVC = PMAlertController(title: "Please fill fields", description: "Please make sure to fill all the fields with the correct information before logging in.", image: nil, style: .alert)
                        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    })
                })
                return
            }
            
            guard let email = self.emailField.text, let password = self.passwordField.text else { return }
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    DispatchQueue.main.async(execute: { () -> Void in
                        button.stopAnimation(animationStyle: .expand, completion: {
                            let mainVC = MainViewController()
                            let navigationVC = UINavigationController(rootViewController: mainVC)
                            self.present(navigationVC, animated: true, completion: nil)
                        })
                    })
                }else{
                    //self.presentSimpleAlert(title: "Error", message: "An error occurred.\r\(error!.localizedDescription)", completion: nil)
                    DispatchQueue.main.async(execute: { () -> Void in
                        button.stopAnimation(animationStyle: .shake, completion: {
                            
                            let alertVC = PMAlertController(title: "Error", description: "An error has occurred when attempting to log in.  Error: \(String(describing: error!.localizedDescription))", image: nil, style: .alert)
                            alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
                            self.present(alertVC, animated: true, completion: nil)
                        })
                    })
                }
            }
        })
    }
    
    private func fieldsAreFilled() -> Bool {
        return self.emailField.text != "" && self.passwordField.text != ""
    }
    
    @objc func dismissKeyboard() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    private func addKeyboardObservers() {
        // Add gesture recognizer to handle tapping outside of keyboard
        let dismissKeyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
