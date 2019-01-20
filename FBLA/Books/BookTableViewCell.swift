//
//  BookTableViewCell.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/19/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import FoldingCell
import UIKit
import Firebase
import fluid_slider

class BookTableViewCell: FoldingCell {
    
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet weak var slider: Slider!
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }
    
    var data = [String]() {
        didSet{
            
        }
    }
    
    var intData = [Int]() {
        didSet{
            
        }
    }
    
    var dateData = [Date]() {
        didSet{
            
        }
    }
    
    var boolData = [Bool]() {
        didSet{
            
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        
        let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
        slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 10) as NSNumber) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
        }
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "1", attributes: labelTextAttributes))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "10", attributes: labelTextAttributes))
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 7)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = UIColor.init(named: "PrimaryBlue")
            //UIColor(red: 0/255.0, green: 82/255.0, blue: 155/255.0, alpha: 1)
        slider.valueViewColor = .white
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension BookTableViewCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
