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

protocol bulletinb: class{
    
    func showBulletin(days: Int, returnDate: Date, bookID: Int)
    
}

extension Array {
    mutating func shuffle(){
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
