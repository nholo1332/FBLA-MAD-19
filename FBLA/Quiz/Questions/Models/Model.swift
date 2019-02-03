//
//  Model.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class Question {
    var question : String?
    var answers : [Answer]!
    
    init (question: String, answers: [Answer]) {
        self.question = question
        self.answers = answers
    }
}

class Answer {
    var response: String!
    var isRight: Bool!
    
    init(answer: String, isRight: Bool) {
        self.response  = answer
        self.isRight = isRight
    }
}
