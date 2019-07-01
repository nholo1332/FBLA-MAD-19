//
//  LeaderboardTableViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/5/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var snapshot = DataSnapshot()
    
    var totalCount: Int = 0
    
    var uids = [String]()
    var scores = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register the leaderboard cell to this view controller
        self.tableView.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
        
        //Request a big height in the UIAlertController
        self.preferredContentSize = CGSize(width: 272, height: 400)
        //Some customization for the tableview
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.init(named: "PrimaryTableView")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.ref = Database.database().reference()
            self.ref.observe(DataEventType.value, with: { (dataSnap) in
                //Retrieve the data from the leaderboard child table from the database. This saves it as a variable so all leaderboard data can be accessed later without making another call to the database.
                self.snapshot = dataSnap
                for child in dataSnap.childSnapshot(forPath: "leaderboard").children {
                    //Append each score as an array to make it more efficient for the tableview to load and present.
                    let myChild = child as! DataSnapshot
                    self.uids.append(myChild.key)
                    self.scores.append(myChild.value as! Int)
                }
                self.totalCount = Int(dataSnap.childSnapshot(forPath: "leaderboard").childrenCount)
                self.uids.reverse()
                self.scores.reverse()
                self.tableView.reloadData()
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        //Pass the user's name to the cell for it to display.
        let name = "\(snapshot.childSnapshot(forPath: "users/\(uids[indexPath.row])/firstName").value as! String) \((snapshot.childSnapshot(forPath: "users/\(uids[indexPath.row])/lastName").value as! String).prefix(1))."
        cell.setInfo(name: name, scores: scores, rank: indexPath.row)
        return cell
    }
}
