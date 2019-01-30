//
//  LoadingViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/30/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase

class LoadingViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(execute: { () -> Void in
            if Auth.auth().currentUser != nil {
                let mainVC = MainViewController()
                let navigationVC = UINavigationController(rootViewController: mainVC)
                self.present(navigationVC, animated: false, completion: nil)
            }else{
                let vcController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                self.present(vcController, animated: false, completion: nil)
            }
        })
    }
    
}
