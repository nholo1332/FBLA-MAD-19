//
//  MainViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/19/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let eventsVC = MainTableViewController()
        //eventsVC.title = "Books"
        
        let stb = UIStoryboard(name: "BooksStoryboard", bundle: nil)
        let booksVC = stb.instantiateViewController(withIdentifier: "MainTableViewController") as! BooksTableViewController
        booksVC.title = "Books"
        
        booksVC.tabBarItem = UITabBarItem(title: "Books", image: UIImage(named: "event"), tag: 0)
        
        let controllers = [booksVC]
        self.viewControllers = controllers
    }
    
}
