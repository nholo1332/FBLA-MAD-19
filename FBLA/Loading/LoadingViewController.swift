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
    
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Detect if user is logged in and has completed the onboarding view. If they are signed in and have viewed the onboarding, bring them to the home.  If they haven't viewed the onboarding, show it now.  Also if they aren't signed in but have viewed the onboarding, bring them to the login.
        DispatchQueue.main.async(execute: { () -> Void in
            if UserDefaults.standard.bool(forKey: "oboarding-shown-\(self.version)") {
                if Auth.auth().currentUser != nil {
                    //Home
                    let mainVC = MainViewController()
                    let navigationVC = UINavigationController(rootViewController: mainVC)
                    self.present(navigationVC, animated: false, completion: nil)
                }else{
                    //Login
                    let vcController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    self.present(vcController, animated: false, completion: nil)
                }
            }else{
                //Onboarding view
                let vcController = IntroViewController(nibName: "IntroViewController", bundle: nil)
                self.present(vcController, animated: false, completion: nil)
            }
        })
    }
    
}
