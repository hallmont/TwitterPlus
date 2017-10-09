//
//  AccountsViewController.swift
//  TwitterApp
//
//  Created by John Nguyen on 10/5/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var parentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        
        let user = User.currentUser


        cell.user = user
        return cell
    }

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: parentView)
        
        if sender.state == .began {
            print("Gesture began at: \(point)")

            
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
            
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
