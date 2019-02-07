//
//  Questions.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/2/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

struct questions {
    //Store all the questions as structs so they can be easily saved in the QuizViewController
    struct competitiveEvents {
        static let question1 = Question(
            question: "How many different kinds of competitive events are there, when pertaining to the number of people involved.",
            answers: [
                Answer(answer: "3 (individual, team, chapter)", isRight: true),
                Answer(answer: "1 (individual)", isRight: false),
                Answer(answer: "4 (individual, quads, duos, chapter)", isRight: false),
                Answer(answer: "3 (individual, quads, duos)", isRight: false)
            ]
        )
       static let question2 = Question(
            question: "There are also certain events specifically for high school students of what grades?",
            answers: [
                Answer(answer: "9th", isRight: true),
                Answer(answer: "10th", isRight: true),
                Answer(answer: "11th", isRight: false),
                Answer(answer: "12th", isRight: false)
            ]
        )
        static let question3 = Question(
            question: "Individual and team events focus on what skills? (Best answer that fits all events)",
            answers: [
                Answer(answer: "Leadership and career development", isRight: true),
                Answer(answer: "Creativity and marketing development", isRight: false),
                Answer(answer: "Monetary development", isRight: false),
                Answer(answer: "Collaboration development", isRight: false)
            ]
        )
        static let question4 = Question(
            question: "Chapter events recognize what achievements?",
            answers: [
                Answer(answer: "Chapter management and growth", isRight: true),
                Answer(answer: "Business education and growth", isRight: false),
                Answer(answer: "Business management", isRight: false),
                Answer(answer: "Career exploration and growth", isRight: false)
            ]
        )
        static let question5 = Question(
            question: "How many total competitive events are there? ",
            answers: [
                Answer(answer: "72", isRight: true),
                Answer(answer: "59", isRight: false),
                Answer(answer: "78", isRight: false),
                Answer(answer: "87", isRight: false)
            ]
        )
    }
    
    struct businessSkills {
        
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
