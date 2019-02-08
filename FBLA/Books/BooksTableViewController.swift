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
    
    var bulletinShown = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Customize the navigation controller because it looks much nicer with the navigation like this.
        let mainvc = self.parent as! MainViewController
        mainvc.navigationItem.title = "Books"
        mainvc.navigationItem.rightBarButtonItem = nil
        mainvc.navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            mainvc.navigationController?.navigationBar.prefersLargeTitles = false
        }
        //Show an alert so the user knows the app is fetching data from the database.
        let controller = UIAlertController(title: "Loading", message: "", preferredStyle: .alert)
        let loading = NVActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.init(named: "PrimaryBlue"), padding: 10)
        loading.startAnimating()
        controller.view.addSubview(loading)
        
        self.present(controller, animated: true, completion: nil)
        DispatchQueue.main.async(execute: { () -> Void in
            self.ref = Database.database().reference()
            self.ref.observe(DataEventType.value, with: { (dataSnap) in
                //Again, save the data as a variable so it can be accessed and passed around later without another call.
                self.snapshot = dataSnap
                self.totalCount = Int(dataSnap.childSnapshot(forPath: "Books").childrenCount)
                self.tableView.reloadData()
                controller.dismiss(animated: false, completion: nil)
            })
        })
    }
    
    private func setup() {
        //Because the cells animate their size, we need to store and array of the possible cell sizes. We also want to have a custom refresh handler (to fetch new data from the database when the user requests.
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
        if bulletinShown {
            reloadManager()
        }
        //Handle the call from the cell to present the book reserving process.
        let formatter = DateFormatter()
        let stringFormatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        stringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
            self.reservePage.descriptionText = "Confirm you would like to reserve this book for \(days) days. You will need to return it by \(formatter.string(from: returnDate))."
            self.reserveDonePage = BLTNPageItem(title: "Reserve Completed")
            self.reserveDonePage.image = UIImage(named: "completed")
            self.reserveDonePage.descriptionText = "Your reservation was successfully completed!  You can now pick up your reserved book. Make sure to return it by \(formatter.string(from: returnDate))."
            self.reserveDonePage.actionButtonTitle = "Done"
            self.reservePage.requiresCloseButton = false
            self.reservePage.isDismissable = true
            
            self.reserveDonePage.actionHandler = { (item: BLTNActionItem) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.ref = Database.database().reference()
                    self.ref.observe(DataEventType.value, with: { (dataSnap) in
                        //Reload the data to show new changes after a reserve has completed.
                        self.snapshot = dataSnap
                        self.totalCount = Int(dataSnap.childSnapshot(forPath: "Books").childrenCount)
                        self.tableView.reloadData()
                    })
                })
                self.bulletinManager.dismissBulletin(animated: true)
            }
            
            self.reservePage = BLTNPageItem(title: "Confirm Reservation")
            self.reservePage.image = UIImage(named: "book")
            self.reservePage.descriptionText = "Confirm you would like to reserve this book for \(days) days. You will need to return it by \(formatter.string(from: returnDate))."
            self.reservePage.actionButtonTitle = "Reserve"
            self.reservePage.alternativeButtonTitle = "Cancel"
            self.reservePage.requiresCloseButton = false
            self.reservePage.isDismissable = false
            self.reservePage.next = self.reserveDonePage
            
            self.reservePage.actionHandler = { (item: BLTNActionItem) in
                item.manager?.displayActivityIndicator()
                //Save the required data for the book reserve to the database. Because lovely Firebase Database can't store a raw NSDate, we need to save it as a string and later convert it to a date and then format how we want.
                if self.snapshot.childSnapshot(forPath: "Books").childSnapshot(forPath: "\(bookID)").childSnapshot(forPath: "users").exists() {
                    
                    var currentUsers = (self.snapshot.childSnapshot(forPath: "Books/\(bookID)/users").value as! [String])
                    currentUsers.append("\(Auth.auth().currentUser!.uid)")
                    self.ref.child("Books").child("\(bookID)").child("users").setValue(currentUsers)
                }else{
                    let users = ["\(Auth.auth().currentUser!.uid)"]
                    self.ref.child("Books/\(bookID)/users").setValue(users)
                }
                
                if self.snapshot.childSnapshot(forPath: "Books/\(bookID)/soonestAvailable").exists() {
                    if stringFormatter.date(from: self.snapshot.childSnapshot(forPath: "Books/\(bookID)/soonestAvailable").value as! String)! < returnDate {
                        self.ref.child("Books/\(bookID)/soonestAvailable").setValue("\(returnDate)")
                    }
                }else{
                    self.ref.child("Books/\(bookID)/soonestAvailable").setValue("\(returnDate)")
                }
                
                self.ref.child("Books/\(bookID)/reservations/\(Auth.auth().currentUser!.uid)/end").setValue("\(returnDate)")
                print("4")
                self.ref.child("Books/\(bookID)/reservations/\(Auth.auth().currentUser!.uid)/start").setValue("\(Date())")
                
                if self.snapshot.childSnapshot(forPath: "Books/\(bookID)/requestedAmount").exists() {
                    self.ref.child("Books/\(bookID)/requestedAmount").setValue((self.snapshot.childSnapshot(forPath: "Books/\(bookID)/requestedAmount").value as! Int) + 1)
                }else{
                    self.ref.child("Books/\(bookID)/requestedAmount").setValue(1)
                }
                
                item.manager?.displayNextItem()
            }
            
            self.reservePage.alternativeHandler = { (item: BLTNActionItem) in
                self.bulletinManager.dismissBulletin(animated: true)
            }
            bulletinShown = true
            self.bulletinManager.showBulletin(above: self)
    }
    
    func reloadManager() {
        bulletinManager = BLTNItemManager(rootItem: reservePage)
    }
    
    @objc func refreshHandler() {
        //Here is where we actually refresh the data. We want to run this as async because it needs to take control of the main thread so we can esnure it actually makes a call to the database to retrieve all the data.
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
        //As I stated earlier, we may want to pass the DataSnapshot as a variable to decrease the number of server calls. This would be very detrimental to the speed of the app if in the cell view had to call to the server to retrieve the data for each book (think if you had around 30 books...). This way it is also easier to implement new data into the database (because we don't have to create a whole other variable to pass into the cell view, it already exists in the snapshot).
        cell.number = indexPath.row
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
        //Set some of the animation variables so we can run some of those cool animations later on.
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Handle the cool animations you see when the cell folds and unfolds.
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
