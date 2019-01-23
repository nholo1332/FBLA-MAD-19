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
    
    //closed info
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet weak var closeMaxReserve: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var requestCount: UILabel!
    @IBOutlet weak var closedReference: UILabel!
    
    //open info
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet weak var slider: Slider!
    @IBOutlet weak var maxReserve: UILabel!
    @IBOutlet weak var openRequests: UILabel!
    @IBOutlet weak var openReference: UILabel!
    @IBOutlet weak var openBookCount: UILabel!
    @IBOutlet weak var openInfoSubject: UILabel!
    @IBOutlet weak var openInfoType: UILabel!
    @IBOutlet weak var openRemaingBooks: UILabel!
    @IBOutlet weak var openRequestButton: UIButton!
    @IBOutlet weak var openPeopleReserve: UILabel!
    @IBOutlet weak var openInfoBottom: UILabel!
    @IBOutlet weak var openInfoBottom1: UILabel!
    
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
        }
    }
    
    var snapshot = DataSnapshot() {
        didSet {
            //closed info
            closeMaxReserve.text = "\(snapshot.childSnapshot(forPath: "/maxDays").value as! String) days"
            requestCount.text = (snapshot.childSnapshot(forPath: "/requestedCount").value as! String)
            closedReference.text = (snapshot.childSnapshot(forPath: "/reference").value as! String).uppercased()
            
            //open info
            maxReserve.text = "\(snapshot.childSnapshot(forPath: "/maxDays").value as! String) days"
            openNumberLabel.text = (snapshot.childSnapshot(forPath: "/title").value as! String)
            openRequests.text = (snapshot.childSnapshot(forPath: "/requestedCount").value as! String)
            openReference.text = (snapshot.childSnapshot(forPath: "/reference").value as! String)
            openBookCount.text = (snapshot.childSnapshot(forPath: "/amount").value as! String)
            openInfoSubject.text = (snapshot.childSnapshot(forPath: "/subject").value as! String)
            openInfoType.text = (snapshot.childSnapshot(forPath: "/type").value as! String)
            openRemaingBooks.text = "\((snapshot.childSnapshot(forPath: "/amount").value as! Int) - (snapshot.childSnapshot(forPath: "/requestedAmount").value as! Int))"
            openPeopleReserve.text = "\((snapshot.childSnapshot(forPath: "/requestedAmount").value as! Int)) people have reserved a book"
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
            let string = formatter.string(from: (fraction * (self.snapshot.childSnapshot(forPath: "/maxDays").value as! CGFloat) as NSNumber)) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
        }
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "1", attributes: labelTextAttributes))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: String(self.snapshot.childSnapshot(forPath: "/maxDays").value as! Int), attributes: labelTextAttributes))
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 7)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = UIColor.init(named: "PrimaryBlue")
        slider.valueViewColor = .white
        
        if (snapshot.childSnapshot(forPath: "/users").value as! [String]).contains((Auth.auth().currentUser?.uid)!){
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            message.text = "RETURN BY: \(formatter.string(from: snapshot.childSnapshot(forPath: "/reservations/\((Auth.auth().currentUser?.uid)!)").value as! Date))"
        }else if ((snapshot.childSnapshot(forPath: "/amount").value as! Int) - (snapshot.childSnapshot(forPath: "/requestedAmount").value as! Int)) == 0{
            message.text = "BOOK NOT AVAILABLE"
        }else{
            message.text = "RESERVE THIS BOOK NOW"
        }
        
        if (snapshot.childSnapshot(forPath: "/users").value as! [String]).contains((Auth.auth().currentUser?.uid)!) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            openInfoBottom.text = "RETURN BY"
            openInfoBottom1.text = "RETURN BY: \(formatter.string(from: snapshot.childSnapshot(forPath: "/reservations/\((Auth.auth().currentUser?.uid)!)").value as! Date))"
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            openInfoBottom.text = "SOONEST AVAILABLE"
            openInfoBottom1.text = "RETURN BY: \(formatter.string(from: snapshot.childSnapshot(forPath: "/soonestAvailable").value as! Date))"
        }
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
