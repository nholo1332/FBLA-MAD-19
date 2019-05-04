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
        //load the terms from the html file.
        //the logo file needs to be placed in the same directory as the html
        //so we can use a relative path in the HTML file for the logo
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")
        let request = URLRequest(url: url!)
        termsWebView.loadRequest(request)
    }

}
