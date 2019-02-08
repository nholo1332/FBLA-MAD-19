//
//  LeaderboardTableViewCell.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/3/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    func setInfo(name: String, scores: [Int], rank: Int){
        //Display the data passed from the TableViewController.
        nameLabel.text = name
        pointsLabel.text = "\(scores[rank])"
        rankLabel.text = "#\(rank + 1)"
    }
    
}
