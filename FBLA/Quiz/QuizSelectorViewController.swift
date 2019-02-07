//
//  QuizSelectorViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase

class QuizSelectorViewController: UIViewController {
    
    var ref: DatabaseReference!
    var snapshot = DataSnapshot()
    
    @IBOutlet weak var leaderboardButton: UIButton!
    
    
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
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.leaderboardButton.isEnabled = false
            self.leaderboardButton.alpha = 0.8
            self.ref = Database.database().reference()
            self.ref.child("leaderboard").observe(DataEventType.value, with: { (dataSnap) in
                self.snapshot = dataSnap
                self.leaderboardButton.isEnabled = true
                self.leaderboardButton.alpha = 1
            })
        })
    }
    
    @IBAction func showLeaderboards(_ sender: Any) {
        //Present the leaderboards (in a UIViewAlert to make the view easier to navigate).
        var message = String()
        if snapshot.childSnapshot(forPath: "\(Auth.auth().currentUser!.uid)").exists() {
            message = "You have \(snapshot.childSnapshot(forPath: "\(Auth.auth().currentUser!.uid)").value as! Int) points"
        }else{
            message = "Take some quizzes to create a spot on the leaderboard!"
        }
        let tableViewController = LeaderboardTableViewController()
        let alertController = UIAlertController(title: "Leaderboards", message: message, preferredStyle: .alert)
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
