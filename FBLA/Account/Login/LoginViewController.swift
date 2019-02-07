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
        
        //Add keyboard observers to make sure the view behaves as it should when editing the fields.
        addKeyboardObservers()
    }
    
    @IBAction func signupAction(_ sender: Any) {
        //Move to the signup view.
        let vcController = SignupViewController(nibName: "SignupViewController", bundle: nil)
        self.present(vcController, animated: false, completion: nil)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        //To reduce the number of views the user needs to navigate through, the reset password can be easily changed to an alert.
        let alertVC = PMAlertController(title: "Reset Password", description: "Enter the email below you wish to reset the password for.", image: nil, style: .alert)
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Email"
            textField?.keyboardType = .emailAddress
        }
        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: { () in
            Auth.auth().sendPasswordReset(withEmail: alertVC.textFields[0].text ?? "", completion: { (error) in
                if error == nil {
                    //Sent the reset password email successfully
                    let errorVC = PMAlertController(title: "Sent", description: "Check your inbox for a reset email.", image: nil, style: .alert)
                    errorVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
                    self.present(errorVC, animated: true, completion: nil)
                }else{
                    //Oops. There must have been an error; show it to the user now.
                    let errorVC = PMAlertController(title: "Error", description: "There was an error: \(error!.localizedDescription)", image: nil, style: .alert)
                    errorVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
                    self.present(errorVC, animated: true, completion: nil)
                }
            })
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ button: TransitionButton) {
        //Use the cool effect of the buttons. We need to start the loading animation and disable the other buttons. It is easiest to disable all touches on the view while the app processes the login data.
        button.startAnimation()
        self.view.isUserInteractionEnabled = false
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            if (!self.fieldsAreFilled()) {
                DispatchQueue.main.async(execute: { () -> Void in
                    button.stopAnimation(animationStyle: .shake, completion: {
                        //An error occured to allow touches again and show an error for the fields not being completed.
                        self.view.isUserInteractionEnabled = true
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
                           //Whew. The request went through. Show the user to their new home view.
                            let mainVC = MainViewController()
                            let navigationVC = UINavigationController(rootViewController: mainVC)
                            self.present(navigationVC, animated: true, completion: nil)
                        })
                    })
                }else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        button.stopAnimation(animationStyle: .shake, completion: {
                            //Darn, an error occurred. Show an error and allow view touches again.
                            self.view.isUserInteractionEnabled = true
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
        //There seems to be a bug when testing if the text fields are filled (.text returns nil and having an optional does not fix)
        return true
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

}
