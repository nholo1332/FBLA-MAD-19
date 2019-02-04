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
        
        let quizVC = QuizSelectorViewController(nibName: "QuizSelectorViewController", bundle: nil)
        quizVC.title = "Quizzes"
        let booksSTB = UIStoryboard(name: "BooksStoryboard", bundle: nil)
        let booksVC = booksSTB.instantiateViewController(withIdentifier: "MainTableViewController") as! BooksTableViewController
        booksVC.title = "Books"
        let leaderboardVC = LeaderboardTableViewController(nibName: "LeaderboardTableViewController", bundle: nil)
        leaderboardVC.title = "Leaderboard"
        
        quizVC.tabBarItem = UITabBarItem(title: "Quizzes", image: UIImage(named: "quiz"), tag: 0)
        leaderboardVC.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(named: "leaderboard"), tag: 1)
        booksVC.tabBarItem = UITabBarItem(title: "Books", image: UIImage(named: "book-icon"), tag: 2)
        
        let controllers = [quizVC, leaderboardVC, booksVC]
        self.viewControllers = controllers
    }
    
}
