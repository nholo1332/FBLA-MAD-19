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
    
    func setInfo(name: String, points: Int){
        nameLabel.text = name
        pointsLabel.text = "\(points)"
    }
    
}
