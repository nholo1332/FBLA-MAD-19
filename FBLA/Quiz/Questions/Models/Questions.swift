//
//  Questions.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

struct questions {
    
    struct business {
        static let question1 = Question(
            question: "Quantos anos em média vive um elefante africano?",
            answers: [
                Answer(answer: "120 anos", isRight: true),
                Answer(answer: "80 anos", isRight: false),
                Answer(answer: "140 anos", isRight: false),
                Answer(answer: "54 km/h", isRight: false)
            ]
        )
    }
    
}
