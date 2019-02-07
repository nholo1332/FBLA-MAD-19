//
//  signupTermsViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/7/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class signupTermsViewController: UIViewController {

    @IBOutlet weak var termsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 272, height: 400)
        
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")
        let request = URLRequest(url: url!)
        termsWebView.loadRequest(request)
    }

}
