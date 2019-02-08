//
//  Functions.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/23/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase
import BLTNBoard

//Here is that custom class for the bulletin being shown on the BooksTableViewController rather than the cell.
protocol bulletinb: class{
    
    func showBulletin(days: Int, returnDate: Date, bookID: Int)
    
}

//Here we make a custom shuffle function for an array (we do this to ensure the questions are shuffled just how we like them).
extension Array {
    mutating func shuffle(){
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
