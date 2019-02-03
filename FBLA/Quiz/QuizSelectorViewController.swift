//
//  QuizSelectorViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import CollectionKit

class QuizSelectorViewController: UIViewController {
    
    //TODO: Add scroll view for the xib view
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func competitiveEvents(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "competitiveEvents"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func businessSkills(_ sender: Any) {
        let vc = QuizViewController(nibName: "QuizViewController", bundle: nil)
        vc.category = "businessSkills"
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
