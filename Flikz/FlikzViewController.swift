//
//  FlikzViewController.swift
//  Flikz
//
//  Created by Luis Perez on 10/16/16.
//  Copyright © 2016 Luis PerezBunnyLemon. All rights reserved.
//

import UIKit

class FlikzViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlikCell", forIndexPath: indexPath)
        cell.textLabel?.text = "row \(indexPath.row)"
        return cell
    }
}
