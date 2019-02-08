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
import BLTNBoard

class BookTableViewCell: FoldingCell {
    
    //Closed cell info
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet weak var closeMaxReserve: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var requestCount: UILabel!
    @IBOutlet weak var closedReference: UILabel!
    @IBOutlet weak var closedDateInfo: UILabel!
    @IBOutlet weak var closedDateInfo2: UILabel!
    @IBOutlet weak var closedDate: UILabel!
    @IBOutlet weak var closedDate2: UILabel!
    
    //Open cell info
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
    @IBOutlet weak var openImage: UIImageView!
    
    var bulletinDelegate : bulletinb?
    
    let formatter = DateFormatter()
    let stringFormatter = DateFormatter()
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
        }
    }
    
    //Run a didSet function so these updates happen when the snapshot is sent to the cell.
    var snapshot = DataSnapshot() {
        didSet {
            //Setup our date formatters. As I said before, Firebase can't store the raw NSDate so we had to make it a string. This first formatter is to convert the database Date into an NSDate. The second is to convert it to a Date format that is easier (and makes more sense for book reserving) to read.
            stringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            formatter.dateFormat = "MM-dd-yyyy"
            
            //Closed cell info
            closeMaxReserve.text = "\(snapshot.childSnapshot(forPath: "maxDays").value as! Int) days"
            requestCount.text = "\(snapshot.childSnapshot(forPath: "requestedAmount").value as! Int)"
            closedReference.text = (snapshot.childSnapshot(forPath: "reference").value as! String).uppercased()
            
            //Open cell info
            maxReserve.text = "\(snapshot.childSnapshot(forPath: "maxDays").value as! Int) days"
            openNumberLabel.text = (snapshot.childSnapshot(forPath: "title").value as! String)
            openRequests.text = "\(snapshot.childSnapshot(forPath: "requestedAmount").value as! Int)"
            openReference.text = (snapshot.childSnapshot(forPath: "reference").value as! String)
            openBookCount.text = "\(snapshot.childSnapshot(forPath: "amount").value as! Int)"
            openInfoSubject.text = "Subject: \(snapshot.childSnapshot(forPath: "subject").value as! String)"
            openInfoType.text = "Type: \(snapshot.childSnapshot(forPath: "type").value as! String)"
            openRemaingBooks.text = "\((snapshot.childSnapshot(forPath: "amount").value as! Int) - (snapshot.childSnapshot(forPath: "requestedAmount").value as! Int))"
            openPeopleReserve.text = "\((snapshot.childSnapshot(forPath: "requestedAmount").value as! Int)) people have reserved a book"
            
            
            //Other setup for the cool slider we can use to select the amount of days we want to reserve the book for.
            let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
            slider.attributedTextForFraction = { fraction in
                let formatter = NumberFormatter()
                formatter.maximumIntegerDigits = 3
                formatter.maximumFractionDigits = 0
                let string = formatter.string(from: (fraction * CGFloat(self.snapshot.childSnapshot(forPath: "maxDays").value as! Int) as NSNumber)) ?? ""
                return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
            }
            slider.setMinimumLabelAttributedText(NSAttributedString(string: "1", attributes: labelTextAttributes))
            slider.setMaximumLabelAttributedText(NSAttributedString(string: String(self.snapshot.childSnapshot(forPath: "maxDays").value as! Int), attributes: labelTextAttributes))
            slider.fraction = 0.5
            slider.shadowOffset = CGSize(width: 0, height: 7)
            slider.shadowBlur = 5
            slider.shadowColor = UIColor(white: 0, alpha: 0.1)
            slider.contentViewColor = UIColor.init(named: "PrimaryBlue")
            slider.valueViewColor = .white
            
            //Run some checks on the recieved data to see if the user has already reserved the book. If they have, then show the appropriate information that would be helpful (such as the return date).
            if snapshot.childSnapshot(forPath: "users").exists() {
                if (snapshot.childSnapshot(forPath: "users").value as! [String]).contains((Auth.auth().currentUser?.uid)!){
                    
                    message.text = "RETURN BY: \(formatter.string(from: stringFormatter.date(from: snapshot.childSnapshot(forPath: "reservations/\(Auth.auth().currentUser!.uid)/end").value as! String)!))"
                    
                    openRequestButton.isEnabled = false
                    slider.isEnabled = false
                    openRequestButton.alpha = 0.3
                    slider.alpha = 0.3
                }else if ((snapshot.childSnapshot(forPath: "amount").value as! Int) == (snapshot.childSnapshot(forPath: "requestedAmount").value as! Int)){
                    message.text = "BOOK NOT AVAILABLE"
                    openRequestButton.isEnabled = false
                    slider.isEnabled = false
                    openRequestButton.alpha = 0.3
                    slider.alpha = 0.3
                }else{
                    message.text = "RESERVE THIS BOOK NOW"
                    openRequestButton.isEnabled = true
                    slider.isEnabled = true
                    openRequestButton.alpha = 1
                    slider.alpha = 1
                }
                
                if (snapshot.childSnapshot(forPath: "users").value as! [String]).contains((Auth.auth().currentUser?.uid)!) {
                    
                    openInfoBottom.text = "RETURN BY"
                    openInfoBottom1.text = "\(formatter.string(from: stringFormatter.date(from: snapshot.childSnapshot(forPath: "reservations/\((Auth.auth().currentUser?.uid)!)/end").value as! String)!))"
                    
                    closedDateInfo.text = "RESERVE START"
                    closedDate.text = "\(formatter.string(from: stringFormatter.date(from: snapshot.childSnapshot(forPath: "reservations/\((Auth.auth().currentUser?.uid)!)/start").value as! String)!))"
                    closedDateInfo2.text = "RESERVE END"
                    closedDate2.text = "\(formatter.string(from: stringFormatter.date(from: snapshot.childSnapshot(forPath: "reservations/\((Auth.auth().currentUser?.uid)!)/end").value as! String)!))"
                }else{
                    openInfoBottom.text = "SOONEST AVAILABLE"
                    openInfoBottom1.text = "\(formatter.string(from: stringFormatter.date(from: snapshot.childSnapshot(forPath: "soonestAvailable").value as! String)!))"
                    
                    closedDateInfo.text = "SOONEST AVAILABLE"
                    closedDate.text = "\(formatter.string(from: stringFormatter.date(from: snapshot.childSnapshot(forPath: "soonestAvailable").value as! String)!))"
                    closedDateInfo2.text = "RESERVE UNTIL"
                    closedDate2.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: (snapshot.childSnapshot(forPath: "maxDays").value as! Int), to: stringFormatter.date(from: snapshot.childSnapshot(forPath: "soonestAvailable").value as! String)!)!)
                }
            }else{
                message.text = "RESERVE THIS BOOK NOW"
                
                openInfoBottom.text = "AVAILABLE NOW"
                openInfoBottom1.text = "\(formatter.string(from: Date()))"
                
                closedDateInfo.text = "AVAILABLE NOW"
                closedDate.text = "\(formatter.string(from: Date()))"
                closedDateInfo2.text = "RESERVE UNTIL"
                closedDate2.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: (snapshot.childSnapshot(forPath: "maxDays").value as! Int), to: Date())!)
            }
        }
    }
    
    override func awakeFromNib() {
        //Make sure the cell is being formatted correctly whenever the app may temporarily transition it to the background.
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

extension BookTableViewCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        //Becuase the Bulletin can't be called on a TableViewCell, we needed to make a custom protocol and function for it to be ran on the BooksTableViewControler, since that is also the ViewController.
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            
            let numFormatter = NumberFormatter()
            numFormatter.maximumIntegerDigits = 3
            numFormatter.maximumFractionDigits = 0
            
            let days = numFormatter.string(from: (self.slider.fraction * CGFloat(self.snapshot.childSnapshot(forPath: "maxDays").value as! Int) as NSNumber)) ?? ""
            
            let newDate = Calendar.current.date(byAdding: .day, value: Int(truncating: numFormatter.number(from: days)!), to: Date())
        
            self.bulletinDelegate!.showBulletin(days: Int(truncating: numFormatter.number(from: days)!), returnDate: newDate!, bookID: self.number)
    }
}
