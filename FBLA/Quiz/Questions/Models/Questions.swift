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
        static let question1 = Question(
            question: "True or false, FBLA is sponsored by Allstate Insurance.",
            answers: [
                Answer(answer: "False ", isRight: true),
                Answer(answer: "True", isRight: false),
                Answer(answer: "", isRight: false),
                Answer(answer: "", isRight: false)
            ]
        )
        static let question2 = Question(
            question: "True or false, FBLA is sponsored by VISA.",
            answers: [
                Answer(answer: "True ", isRight: true),
                Answer(answer: "False", isRight: false),
                Answer(answer: "", isRight: false),
                Answer(answer: "", isRight: false)
            ]
        )
        static let question3 = Question(
            question: "True or false, FBLA is sponsored by Geico.",
            answers: [
                Answer(answer: "True ", isRight: true),
                Answer(answer: "False", isRight: false),
                Answer(answer: "", isRight: false),
                Answer(answer: "", isRight: false)
            ]
        )
        static let question4 = Question(
            question: "Name two household companies or groups that give discounts to FBLA members.",
            answers: [
                Answer(answer: "Alamo car rental, Geico, Amazon, Hyatt hotels, HP inc.", isRight: true),
                Answer(answer: "Men’s Wearhouse, and Office Depot / Office Max", isRight: true),
                Answer(answer: "Alamo car rental, Geico, Google, HP inc.", isRight: false),
                Answer(answer: "Office Depot, Geico, Google, Microsoft", isRight: false)
            ]
        )
        static let question5 = Question(
            question: "How many national officers does the FBLA organization currently have?",
            answers: [
                Answer(answer: "9", isRight: true),
                Answer(answer: "7", isRight: false),
                Answer(answer: "11", isRight: false),
                Answer(answer: "10", isRight: false)
            ]
        )
    }
    
    struct parlipro {
        static let question1 = Question(
            question: "Only the top how many top scoring teams in parliamentary procedure will move on to the final round?",
            answers: [
                Answer(answer: "15", isRight: true),
                Answer(answer: "18", isRight: false),
                Answer(answer: "20", isRight: false),
                Answer(answer: "14", isRight: false)
            ]
        )
        static let question2 = Question(
            question: "The highest scoring underclassman on the parliamentary procedures exam who submits an official application and meets all appropriate criteria becomes the new what seat of national officers?",
            answers: [
                Answer(answer: "National Parliamentarian", isRight: true),
                Answer(answer: "National Chairman", isRight: false),
                Answer(answer: "National President", isRight: false),
                Answer(answer: "National Sentinel", isRight: false)
            ]
        )
        static let question3 = Question(
            question: "What award recognizes PBL members who demonstrate knowledge of parliamentary procedure principles along with an understanding of PBL’s organization and procedure?",
            answers: [
                Answer(answer: "The Dorothy L. Travis Award", isRight: true),
                Answer(answer: "The PBL Parli Pro Award", isRight: false),
                Answer(answer: "The Dorothy L. Parli Pro Award", isRight: false),
                Answer(answer: "The National Parli Pro Award", isRight: false)
            ]
        )
        static let question4 = Question(
            question: "A single state may submit how many teams of four or five persons?",
            answers: [
                Answer(answer: "Two teams", isRight: true),
                Answer(answer: "Three teams", isRight: false),
                Answer(answer: "1 team", isRight: false),
                Answer(answer: "Five teams", isRight: false)
            ]
        )
        static let question5 = Question(
            question: "The scenario for Parliamentary Procedure will be given to simulate a regular, what? ",
            answers: [
                Answer(answer: "Chapter meeting", isRight: true),
                Answer(answer: "Team meeting", isRight: false),
                Answer(answer: "Officer meeting", isRight: false),
                Answer(answer: "Instructor meeting", isRight: false)
            ]
        )
    }
    
    struct history {
        static let question1 = Question(
            question: "In 1940, what national council sponsored the proposed student organization naming it the Future Business Leaders of America?",
            answers: [
                Answer(answer: "The National Council for Business Education", isRight: true),
                Answer(answer: "National Business Education Association", isRight: true),
                Answer(answer: "National Organization for Students", isRight: false),
                Answer(answer: "Council for Highschooler Businesses", isRight: false)
            ]
        )
        static let question2 = Question(
            question: "When was the first high school chapter chartered and in what state was it in? ",
            answers: [
                Answer(answer: "1942, Tennessee", isRight: true),
                Answer(answer: "1987, Arkansas", isRight: true),
                Answer(answer: "1942, South Carolina", isRight: false),
                Answer(answer: "1970, Tennessee", isRight: false)
            ]
        )
    }
    
}
