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
        //Setup the tab bar at the bottom of the screen (to navigate to different views).
        let quizVC = QuizSelectorViewController(nibName: "QuizSelectorViewController", bundle: nil)
        quizVC.title = "Quizzes"
        let booksSTB = UIStoryboard(name: "BooksStoryboard", bundle: nil)
        let booksVC = booksSTB.instantiateViewController(withIdentifier: "MainTableViewController") as! BooksTableViewController
        booksVC.title = "Books"
        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        settingsVC.title = "Settings"
        
        quizVC.tabBarItem = UITabBarItem(title: "Quizzes", image: UIImage(named: "quiz"), tag: 0)
        booksVC.tabBarItem = UITabBarItem(title: "Books", image: UIImage(named: "book-icon"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 2)
        
        //Load them as controllers and add them to the navigation as a child of this view controller.
        let controllers = [quizVC, booksVC, settingsVC]
        self.viewControllers = controllers
    }
    
}
