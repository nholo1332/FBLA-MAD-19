//
//  QuizSelectorViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class QuizSelectorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Don't show the view name because we handled that in the view (.xib) file. Also configure anything else that is different for this view in the navigation bar
        let mainvc = self.parent as! MainViewController
        mainvc.navigationItem.title = ""
        mainvc.navigationItem.rightBarButtonItem = nil
        mainvc.navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            mainvc.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    @IBAction func showLeaderboards(_ sender: Any) {
        //Present the leaderboards (in a UIViewAlert to make the view easier to navigate).
        let tableViewController = LeaderboardTableViewController()
        let alertController = UIAlertController(title: "Leaderboards", message: "Message", preferredStyle: .alert)
        alertController.setValue(tableViewController, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Move the user to the quiz view and pass the quiz, they want to take, as string variable.
    @IBAction func competitiveEvents(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "competitive events"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func businessSkills(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "business skills"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sponsors(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "sponsors"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func parlipro(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "parlipro"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func history(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "history"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
