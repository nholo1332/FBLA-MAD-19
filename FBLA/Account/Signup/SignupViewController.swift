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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let controller = UIAlertController()
    
    let userRef = Database.database().reference().child("users")

    override func viewDidLoad() {
        super.viewDidLoad()
        //Some setup here (very similar to the login view)
        addKeyboardObservers()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let controller = UIAlertController(title: "Loading", message: "", preferredStyle: .alert)
        let loading = NVActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.init(named: "PrimaryBlue"), padding: 10)
        loading.startAnimating()
        controller.view.addSubview(loading)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let vcController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.present(vcController, animated: false, completion: nil)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        present(controller, animated: true, completion: nil)
        if (!fieldsAreFilled()) {
            showError(title: "Field error", message: "Please fill all the fiels before attempting to signup for an account.")
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        if (profileSettingsAreAdequate()) {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if let error = error {
                    self.showError(title: "Error", message: "Error: \(error.localizedDescription)")
                    self.controller.dismiss(animated: true, completion: nil)
                    return
                }
                
                self.userRef.child((user?.user.uid)!).setValue(
                    ["firstName" : self.firstNameField.text!,
                     "lastName" : self.lastNameField.text!
                    ]
                ) {
                    (error:Error?, ref:DatabaseReference) in
                    //code here to send user to another View
                    let mainVC = MainViewController()
                    let navigationVC = UINavigationController(rootViewController: mainVC)
                    self.present(navigationVC, animated: true, completion: nil)
                }
            }
                
            )}
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
    
    func showError(title: String, message: String){
        let alertVC = PMAlertController(title: title, description: message, image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel, action: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func fieldsAreFilled() -> Bool {
        
        return emailField.text != "" && firstNameField.text != "" && lastNameField.text != "" && passwordField.text != ""
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
