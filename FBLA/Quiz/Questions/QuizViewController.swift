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
import FacebookShare

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
    //Load the questions based on the category that was passed to this view
    var category: String = "" {
        didSet {
            if category == "competitive events"{
                self.questionsToUse = [
                    questions.competitiveEvents.question1,
                    questions.competitiveEvents.question2,
                    questions.competitiveEvents.question3,
                    questions.competitiveEvents.question4,
                    questions.competitiveEvents.question5
                ]
            }else if category == "business skills"{
                self.questionsToUse = [
                    questions.businessSkills.question1,
                    questions.businessSkills.question2,
                    questions.businessSkills.question3,
                    questions.businessSkills.question4,
                    questions.businessSkills.question5
                ]
            }else if category == "sponsors"{
                self.questionsToUse = [
                    questions.sponsors.question1,
                    questions.sponsors.question2,
                    questions.sponsors.question3,
                    questions.sponsors.question4,
                    questions.sponsors.question5
                ]
            }else if category == "parlipro"{
                self.questionsToUse = [
                    questions.parlipro.question1,
                    questions.parlipro.question2,
                    questions.parlipro.question3,
                    questions.parlipro.question4,
                    questions.parlipro.question5
                ]
            }else if category == "history"{
                self.questionsToUse = [
                    questions.history.question1,
                    questions.history.question2,
                    questions.history.question3,
                    questions.history.question4,
                    questions.history.question5
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
        //Show the view at the bottom to confirm the user wants to take the quiz now.
        DispatchQueue.main.async(execute: { () -> Void in
            self.beginPage = BLTNPageItem(title: "Ready?")
            self.beginPage.image = UIImage(named: "book")
            self.beginPage.descriptionText = "Are you ready to start the quiz?  You will not be able to stop the quiz once started. Don't worry the quizzes are very short, only 5 questions."
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
        //Shuffle and load the questions and answers in a random order.
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
        //Actually present the question and answers.
        enableButtons()
        
        let selectedQuestion : Question = questionsToUse[questionId]
        question.text = selectedQuestion.question
        
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
        //Show the user if they answered correctly or incorrectly.
        disableButtons()
        
        let answer : Answer = questionsToUse[currentQuestion].answers[answerId]
        
        if (true == answer.isRight) {
            //Correct answer
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
            //Incorrect answer
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
        //Move to the next question
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
        //Finish the quiz. If the user got 5/5, then show the option to share their score to Facebook. If they didn't, just show a button to return to the home screen.
        quizEnded = true
        
        endPage = BLTNPageItem(title: "\(grade)/5")
        endPage.image = UIImage(named: "completed")
        endPage.descriptionText = "Congratulations, you finished the quiz!  Your quiz score will be added to your total score and appended to the leaderboard."
        endPage.actionButtonTitle = "Done"
        endPage.alternativeButtonTitle = "Done"
        endPage.requiresCloseButton = false
        endPage.isDismissable = false
        
        if grade == 5 {
            endPage.actionButtonTitle = "Share"
            endPage.alternativeButtonTitle = "Done"
            
            endPage.actionHandler = { (item: BLTNActionItem) in
                self.shareFacebook()
            }
            
            endPage.alternativeHandler = { (item: BLTNActionItem) in
                self.ref = Database.database().reference()
                self.ref.child("leaderboard").observeSingleEvent(of: .value, with: { (snapshot) in
                    //Add their current grade to their existing leaderboard score and update the database.
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
        }else{
            //Not a 5/5 so only show a button to go back home.
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
        }
        
        doneManager.showBulletin(above: self)
    }
    
    func shareFacebook() {
        //Present the Facebook share once the user has selected to share their score. Present as a web view in the app because their regular (integrated) modal seemed to have a bug.
        let content: LinkShareContent = LinkShareContent.init(url: URL.init(string: "http://nebraskafbla.org") ?? URL.init(fileURLWithPath: "http://nebraskafbla.org"), quote: "I got a 5/5 on the \(category) quiz in Noah Holoubek and Mitchel Beeson's FBLA HQ app!")
        
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .web
        
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            self.ref = Database.database().reference()
            self.ref.child("leaderboard").observeSingleEvent(of: .value, with: { (snapshot) in
                //Also add their new grade to their existing one in the database
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
        do {
            try shareDialog.show()
        } catch {
            print("Exception")
            
        }
        
    }
    
}

