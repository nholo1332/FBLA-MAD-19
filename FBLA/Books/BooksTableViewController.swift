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

class BooksTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var snapshot: DataSnapshot!
    
    var totalCount: Int = 0
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        ref.child("Books").observeSingleEvent(of: .value, with: { (dataSnap) in
            self.snapshot = dataSnap
            self.totalCount = Int(dataSnap.childrenCount)
            //print("Data: \(snapshot.childSnapshot(forPath: "title").value)")
            //print("Data: \(value?["title"])")
        }) { (error) in
            print(error)
        }
        
        delayWithSeconds(2) {
            self.tableView.reloadData()
        }
        
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
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
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
        cell.snapshot = snapshot.childSnapshot(forPath: "/\(indexPath.row)")
        
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
