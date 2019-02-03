//
//  Questions.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

struct questions {
    
    struct competitiveEvents {
        
    }
    
    struct businessSkills {
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
    
    struct sponsors {
        
    }
    
    struct parlipro {
        
    }
    
    struct history {
        static let question1 = Question(
            question: "In 1940, what national council sponsored the proposed student organization naming it the Future Business Leaders of America? ",
            answers: [
                Answer(answer: "The National Council for Business Education", isRight: true),
                Answer(answer: "National Business Education Association", isRight: true),
                Answer(answer: "National Organization for Students", isRight: false),
                Answer(answer: "Council for Highschooler Businesses", isRight: false)
            ]
        )
    }
    
}
