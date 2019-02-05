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
        self.tableView.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
        
        self.preferredContentSize = CGSize(width: 272, height: 400)
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.init(named: "PrimaryTableView")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.ref = Database.database().reference()
            self.ref.observe(DataEventType.value, with: { (dataSnap) in
                self.snapshot = dataSnap
                self.totalCount = Int(dataSnap.childSnapshot(forPath: "leaderboard").childrenCount)
                
                for child in dataSnap.childSnapshot(forPath: "leaderboard").children {
                    let myChild = child as! DataSnapshot
                    self.uids.append(myChild.key)
                    self.scores.append(myChild.value as! Int)
                }
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
        let name = "\(snapshot.childSnapshot(forPath: "users/\(uids[indexPath.row])/firstName").value as! String) \((snapshot.childSnapshot(forPath: "users/\(uids[indexPath.row])/lastName").value as! String).prefix(1))."
        cell.setInfo(name: name, points: scores[indexPath.row])
        return cell
    }
}
