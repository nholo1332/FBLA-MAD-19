//
//  QuizViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import BLTNBoard
import Firebase

class QuizViewController: UIViewController {
    
    @IBOutlet weak var question: UITextView!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    var questionsToUse : [Question]!
    var currentQuestion = 0
    var grade = 0.0
    var quizEnded = false
    
    var beginPage = BLTNPageItem()

    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = beginPage
        return BLTNItemManager(rootItem: rootItem)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        beginPage = BLTNPageItem(title: "Ready?")
        beginPage.image = UIImage(named: "book")
        beginPage.descriptionText = "Are you ready to start the quiz?  You will not be able to stop the quiz once started.  Don't worry the quizzes are very short, only 5 questions."
        beginPage.actionButtonTitle = "Go!"
        beginPage.alternativeButtonTitle = "Cancel"
        beginPage.requiresCloseButton = false
        beginPage.isDismissable = false
        
        beginPage.actionHandler = { (item: BLTNActionItem) in
            self.startQuiz()
        }
        
        beginPage.alternativeHandler = { (item: BLTNActionItem) in
            //move to main view
        }
        
        bulletinManager.showBulletin(above: self)
    }
    
    func setQuizCategory(category: String) {
        if category == "competitiveEvents"{
            self.questionsToUse = [
                questions.business.question1
            ]
        }else if category == "businessSkills"{
            
        }else if category == "sponsors"{
            
        }else if category == "parlipro"{
            
        }else if category == "history"{
            
        }
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
        grade = 0.0
        currentQuestion = 0
        viewFeddback.isHidden = true
        
        showQuestion(0)
    }
    
    func showQuestion(_ questionId : Int) -> Void {
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
        disableButtons()
        
        let answer : Answer = questionsToUse[currentQuestion].answers[answerId]
        
        if (true == answer.isRight) {
            grade += 1.0
            feedbackText.text = answer.response + "\n\nResposta correta!"
            viewFeddback.backgroundColor = UIColor.green
            feedbackText.textColor = UIColor.black
        } else {
            viewFeddback.backgroundColor = UIColor.red
            feedbackText.text = answer.response + "\n\nResposta incorreta!"
            feedbackText.textColor = UIColor.white
        }
        
        if (currentQuestion < questionsToUse.count-1) {
            feedbackButton.setTitle("Próxima", for: UIControlState())
        } else {
            feedbackButton.setTitle("Ver pontuação", for: UIControlState())
        }
        
        viewFeddback.isHidden = false
    }
    
    @IBAction func sendFeedback(_ sender: AnyObject) {
        viewFeddback.isHidden = true
        
        if (true == quizEnded) {
            startQuiz()
        } else {
            nextQuestion()
        }
    }
    
    func nextQuestion() {
        currentQuestion += 1
        
        if (currentQuestion < questionsToUse.count) {
            showQuestion(currentQuestion)
        } else {
            endQuiz()
        }
    }
    
    func endQuiz() {
        grade = grade / Double(questionsToUse.count) * 100.0
        quizEnded = true
        viewFeddback.isHidden = false
        
        viewFeddback.backgroundColor = UIColor.white
        feedbackText.textColor = UIColor.black
        
        
        feedbackText.text = "Sua pontuação \(round(grade))"
        feedbackButton.setTitle("Refazer", for: UIControlState())
    }
    
}

