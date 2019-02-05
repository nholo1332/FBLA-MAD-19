//
//  LeaderboardTableViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/3/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class LeaderboardTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    /*@IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myScoreLabel: UILabel!*/
    
    var ref: DatabaseReference!
    var snapshot = DataSnapshot()
    
    var totalCount: Int = 0
    
    var uids = [String]()
    var scores = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let controller = UIAlertController(title: "Loading", message: "", preferredStyle: .alert)
        let loading = NVActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.init(named: "PrimaryBlue"), padding: 10)
        loading.startAnimating()
        controller.view.addSubview(loading)
        
        self.present(controller, animated: true, completion: nil)
        DispatchQueue.main.async(execute: { () -> Void in
            self.ref = Database.database().reference()
            self.ref.observe(DataEventType.value, with: { (dataSnap) in
                self.snapshot = dataSnap
                self.totalCount = Int(dataSnap.childSnapshot(forPath: "leaderboard").childrenCount)
                //self.myNameLabel.text = "\(dataSnap.childSnapshot(forPath: "users/\(Auth.auth().currentUser!.uid)/firstName").value as! String) \((dataSnap.childSnapshot(forPath: "users/\(Auth.auth().currentUser!.uid)/firstName").value as! String).prefix(1))."
                //self.myScoreLabel.text = "\(dataSnap.childSnapshot(forPath: "leaderboard/\(Auth.auth().currentUser!.uid)").value as! Int)"
                
                for child in dataSnap.childSnapshot(forPath: "leaderboard").children {
                    let myChild = child as! DataSnapshot
                    self.uids.append(myChild.key)
                    self.scores.append(myChild.value as! Int)
                }
                
                self.tableView.reloadData()
                controller.dismiss(animated: false, completion: nil)
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        let name = "\(snapshot.childSnapshot(forPath: "users/\(uids[indexPath.row])/firstName").value as! String) \((snapshot.childSnapshot(forPath: "users/\(uids[indexPath.row])/lastName").value as! String).prefix(1))"
        cell.setInfo(name: name, points: scores[indexPath.row])
        
        return cell
    }
    
}
