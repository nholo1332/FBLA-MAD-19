//
//  BooksTableViewController.swift
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
import NVActivityIndicatorView

class BooksTableViewController: UITableViewController, bulletinb {
    
    var ref: DatabaseReference!
    var snapshot: DataSnapshot!
    
    var totalCount: Int = 0
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    var reservePage = BLTNPageItem()
    var reserveDonePage = BLTNPageItem()
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = reservePage
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mainvc = self.parent as! MainViewController
        mainvc.navigationItem.title = "Books"
        mainvc.navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            mainvc.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        let controller = UIAlertController(title: "Loading", message: "", preferredStyle: .alert)
        let loading = NVActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.init(named: "PrimaryBlue"), padding: 10)
        loading.startAnimating()
        controller.view.addSubview(loading)
        
        self.present(controller, animated: true, completion: nil)
        DispatchQueue.main.async(execute: { () -> Void in
            self.ref = Database.database().reference()
            self.ref.observe(DataEventType.value, with: { (dataSnap) in
                self.snapshot = dataSnap
                self.totalCount = Int(dataSnap.childSnapshot(forPath: "Books").childrenCount)
                self.tableView.reloadData()
                controller.dismiss(animated: false, completion: nil)
            })
        })
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func showBulletin(days: Int, returnDate: Date, bookID: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        reserveDonePage = BLTNPageItem(title: "Reserve Completed")
        reserveDonePage.image = UIImage(named: "completed")
        reserveDonePage.descriptionText = "Your reservation was successfully completed!  You can now pick up your reserved book.  Make sure to return it by \(formatter.string(from: returnDate))."
        reserveDonePage.actionButtonTitle = "Done"
        reservePage.requiresCloseButton = false
        reservePage.isDismissable = true
        
        reserveDonePage.actionHandler = { (item: BLTNActionItem) in
            /*DispatchQueue.main.async(execute: { () -> Void in
                self.ref = Database.database().reference()
                self.ref.observe(DataEventType.value, with: { (dataSnap) in
                    self.snapshot = dataSnap
                    self.totalCount = Int(dataSnap.childSnapshot(forPath: "Books").childrenCount)
                    self.tableView.reloadData()
                })
            })*/
            self.bulletinManager.dismissBulletin()
        }
        
        reservePage = BLTNPageItem(title: "Confirm Reservation")
        reservePage.image = UIImage(named: "book")
        reservePage.descriptionText = "Confirm you would like to reserve this book for \(days) days.  You will need to return it by \(formatter.string(from: returnDate))."
        reservePage.actionButtonTitle = "Reserve"
        reservePage.alternativeButtonTitle = "Cancel"
        reservePage.requiresCloseButton = false
        reservePage.isDismissable = false
        reservePage.next = reserveDonePage
        
        reservePage.actionHandler = { (item: BLTNActionItem) in
            item.manager?.displayActivityIndicator()
            
            if self.snapshot.childSnapshot(forPath: "Books").childSnapshot(forPath: "\(bookID)").childSnapshot(forPath: "users").exists() {
                
                var currentUsers = (self.snapshot.childSnapshot(forPath: "Books/\(bookID)/users").value as! [String])
                
                self.ref.child("Books").child("\(bookID)").child("users").setValue(currentUsers.append("\(Auth.auth().currentUser!.uid)"))
            }else{
                let users = ["\(Auth.auth().currentUser!.uid)"]
                self.ref.child("Books/\(bookID)/users").setValue(users)
            }
            
            if self.snapshot.childSnapshot(forPath: "Books/\(bookID)/soonestAvailable").exists() {
                if (self.snapshot.childSnapshot(forPath: "Books/\(bookID)/soonestAvailable").value as! Date) < returnDate {
                    self.ref.child("Books/\(bookID)/soonestAvailable").setValue("\(returnDate)")
                }
            }else{
                self.ref.child("Books/\(bookID)/soonestAvailable").setValue("\(returnDate)")
            }
            
            self.ref.child("Books/\(bookID)/reservations/\(Auth.auth().currentUser!.uid)/end").setValue("\(returnDate)")
            self.ref.child("Books/\(bookID)/reservations/\(Auth.auth().currentUser!.uid)/start").setValue("\(Date())")
            
            if self.snapshot.childSnapshot(forPath: "Books/\(bookID)/requestedAmount").exists() {
                self.ref.child("Books/\(bookID)/requestedAmount").setValue((self.snapshot.childSnapshot(forPath: "Books/\(bookID)/requestedAmount").value as! Int) + 1)
            }else{
                self.ref.child("Books/\(bookID)/requestedAmount").setValue(1)
            }
            
            item.manager?.displayNextItem()
        }
        
        reservePage.alternativeHandler = { (item: BLTNActionItem) in
            self.bulletinManager.dismissBulletin()
        }
        
        bulletinManager.showBulletin(above: self)
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.async(execute: { () -> Void in
            self.ref = Database.database().reference()
            self.ref.observe(DataEventType.value, with: { (dataSnap) in
                self.snapshot = dataSnap
                self.totalCount = Int(dataSnap.childSnapshot(forPath: "Books").childrenCount)
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
                    self!.tableView.refreshControl?.endRefreshing()
                })
            })
        })
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return totalCount
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as BookTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
        /*cell.data = [
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/title").value as! String,
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/subject").value as! String,
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/type").value as! String,
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/target").value as! String]
        cell.intData = [
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/amount").value as! Int,
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/available").value as! Int,
            snapshot.childSnapshot(forPath: "/\(indexPath.row)/maxDays").value as! Int]
        cell.usersReserved = snapshot.childSnapshot(forPath: "/\(indexPath.row)/users").value as! [String]*/
        cell.snapshot = snapshot.childSnapshot(forPath: "Books/\(indexPath.row)")
        cell.bulletinDelegate = self
        
        //Title (string)
        //Subject (string)
        //What type of book (manual, informational, etc.) (string)
        //For who (teacher, student, manager) (string)
        //Total amount (Int)
        //Current available (Int)
        //Max days for reserve
        //Soonest reserve ending date (Date)
        //If you already reserved the book (Bool)
        //When your reservation ends (Date)
        //When your reservation started (Date)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
}
