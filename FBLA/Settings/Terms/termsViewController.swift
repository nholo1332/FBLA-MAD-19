//
//  termsViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/5/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import WebKit

class termsViewController: UIViewController {

    @IBOutlet weak var termsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")
        let request = URLRequest(url: url!)
        termsWebView.loadRequest(request)
    }

}
