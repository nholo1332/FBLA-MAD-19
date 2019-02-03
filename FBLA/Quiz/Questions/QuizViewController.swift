//
//  QuizViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import BLTNBoard
import PMAlertController
import NVActivityIndicatorView
import Firebase

class QuizViewController: UIViewController {
    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var quizProgressView: UIProgressView!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    var questionsToUse : [Question]!
    var currentQuestion = 0
    var grade = 0
    var quizEnded = false
    
    var ref: DatabaseReference!
    
    var beginPage = BLTNPageItem()
    var endPage = BLTNPageItem()

    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = beginPage
        return BLTNItemManager(rootItem: rootItem)
    }()
    lazy var doneManager: BLTNItemManager = {
        let rootItem: BLTNItem = endPage
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    //TODO: Add more questions
    var category: String = "" {
        didSet {
            if category == "competitiveEvents"{
                
            }else if category == "businessSkills"{
                
            }else if category == "sponsors"{
                
            }else if category == "parlipro"{
                
            }else if category == "history"{
                self.questionsToUse = [
                    questions.history.question1
                ]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(execute: { () -> Void in
            self.beginPage = BLTNPageItem(title: "Ready?")
            self.beginPage.image = UIImage(named: "book")
            self.beginPage.descriptionText = "Are you ready to start the quiz?  You will not be able to stop the quiz once started.  Don't worry the quizzes are very short, only 5 questions."
            self.beginPage.actionButtonTitle = "Go!"
            self.beginPage.alternativeButtonTitle = "Cancel"
            self.beginPage.requiresCloseButton = false
            self.beginPage.isDismissable = false
            
            self.beginPage.actionHandler = { (item: BLTNActionItem) in
                self.startQuiz()
                self.bulletinManager.dismissBulletin()
            }
            
            self.beginPage.alternativeHandler = { (item: BLTNActionItem) in
                self.bulletinManager.dismissBulletin()
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.bulletinManager.showBulletin(above: self)
        })
    }
    
    @IBAction func chooseAnswer1(_ sender: AnyObject) {
        selectAnswer(0)
    }
    
    @IBAction func chooseAnswer2(_ sender: AnyObject) {
        selectAnswer(1)
    }
    
    @IBAction func chooseAnswer3(_ sender: AnyObject) {
        selectAnswer(2)
    }
    
    @IBAction func chooseAnswer4(_ sender: AnyObject) {
        selectAnswer(3)
    }
    
    func startQuiz() -> Void {
        questionsToUse.shuffle()
        
        for i in 0 ..< questionsToUse.count {
            questionsToUse[i].answers.shuffle()
        }
        
        quizEnded = false
        grade = 0
        currentQuestion = 0
        
        currentQuestionLabel.text = "1/5"
        quizProgressView.setProgress(1.0/5.0, animated: true)
        
        showQuestion(0)
    }
    
    func showQuestion(_ questionId : Int) -> Void {
        enableButtons()
        
        let selectedQuestion : Question = questionsToUse[questionId]
        question.text = selectedQuestion.question
        
        /*var questionNums = [0, 1, 2, 3]
        questionNums.shuffle()*/
        
        answer1.setTitle(selectedQuestion.answers[0].response, for: UIControl.State())
        answer2.setTitle(selectedQuestion.answers[1].response, for: UIControl.State())
        answer3.setTitle(selectedQuestion.answers[2].response, for: UIControl.State())
        answer4.setTitle(selectedQuestion.answers[3].response, for: UIControl.State())
    }
    
    func disableButtons() -> Void {
        answer1.isEnabled = false
        answer2.isEnabled = false
        answer3.isEnabled = false
        answer4.isEnabled = false
        question.isHidden = true
    }
    
    func enableButtons() -> Void {
        answer1.isEnabled = true
        answer2.isEnabled = true
        answer3.isEnabled = true
        answer4.isEnabled = true
        question.isHidden = false
    }
    
    func selectAnswer(_ answerId : Int) -> Void {
        disableButtons()
        
        let answer : Answer = questionsToUse[currentQuestion].answers[answerId]
        
        if (true == answer.isRight) {
            grade += 1
            
            let feedbackAlert = PMAlertController(title: "Correct!", description: "", image: UIImage(named: "correct"), style: .alert)
            feedbackAlert.addAction(PMAlertAction(title: "Yay", style: .default, action: { () in
                if (true == self.quizEnded) {
                    self.startQuiz()
                } else {
                    self.nextQuestion()
                }
            }))
            self.present(feedbackAlert, animated: true, completion: nil)
        } else {
            let feedbackAlert = PMAlertController(title: "Incorrect", description: "", image: UIImage(named: "incorrect"), style: .alert)
            feedbackAlert.addAction(PMAlertAction(title: "Ok", style: .default, action: { () in
                if (true == self.quizEnded) {
                    self.startQuiz()
                } else {
                    self.nextQuestion()
                }
            }))
            self.present(feedbackAlert, animated: true, completion: nil)
        }
    }
    
    func nextQuestion() {
        currentQuestion += 1
        currentQuestionLabel.text = "\(currentQuestion + 1)/5"
        let progress: Float = (Float(currentQuestion) + 1.0)/5.0
        quizProgressView.setProgress(progress, animated: true)
        
        if (currentQuestion < questionsToUse.count) {
            showQuestion(currentQuestion)
        } else {
            endQuiz()
        }
    }
    
    func endQuiz() {
        quizEnded = true
        
        endPage = BLTNPageItem(title: "\(grade)/5")
        endPage.image = UIImage(named: "completed")
        endPage.descriptionText = "Congratulations, you finished the quiz!  Your quiz score will be added to your total score and appended to the leaderboard."
        endPage.actionButtonTitle = "Done"
        endPage.requiresCloseButton = false
        endPage.isDismissable = false
        
        endPage.actionHandler = { (item: BLTNActionItem) in
            self.ref = Database.database().reference()
            self.ref.child("leaderboard").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.childSnapshot(forPath: "\(Auth.auth().currentUser!.uid)").exists() {
                    let leaderboardGrade = (snapshot.childSnapshot(forPath: "\(Auth.auth().currentUser!.uid)").value as! Int) + self.grade
                    self.ref.child("leaderboard/\(Auth.auth().currentUser!.uid)").setValue(leaderboardGrade)
                }else{
                    self.ref.child("leaderboard/\(Auth.auth().currentUser!.uid)").setValue(self.grade)
                }
            })
                
            self.doneManager.dismissBulletin()
            self.navigationController?.popToRootViewController(animated: true)
        }
        doneManager.showBulletin(above: self)
    }
    
}

