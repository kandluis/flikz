//
//  FlikzViewController.swift
//  Flikz
//
//  Created by Luis Perez on 10/16/16.
//  Copyright © 2016 Luis PerezBunnyLemon. All rights reserved.
//

import UIKit
import MBProgressHUD

private let fadeDuration: Double = 2

class FlikzViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var movies: [Movie]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change color of navigation controller
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Disable seperator
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.separatorStyle = .None
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadNetworkData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadNetworkData(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlikCell", forIndexPath: indexPath) as! FlikCell
        if let movie = movies?[indexPath.row] {
            cell.titleLabel.text = movie.title ?? "No Title"
            cell.descriptionLabel.text = movie.description ?? "No Description"
            cell.selectionStyle = .None
            
            movie.setPosterThumbail(cell.posterView)
        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                if let movie = movies?[indexPath.row] {
                    if let detailViewController = segue.destinationViewController as? DetailViewController {
                        detailViewController.movie = movie
                    }
                }
            }
            
        }
    }
    
    func loadNetworkData(refreshControl: UIRefreshControl){
        // Clear error
        errorView.hidden = true
        
        // Attempt a fetch!
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchEndpoint(endpoint, successCallback: {[unowned self](movies) -> Void in
            self.movies = movies
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            }, error: {[unowned self] (error) -> Void in
                // TODO: Add image
                self.showError("Network Error", errorImg: nil)
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
    }
    
    func showError(errorText: String, errorImg: UIImage?){
        errorLabel.text = errorText
        
        // Animate
        errorView.alpha = 0
        errorView.hidden = false
        UIView.animateWithDuration(fadeDuration, animations: {[unowned self] in
            self.errorView.alpha = 0.5
        })
        // TODO - Implement image
    }
    func hideError(){
        self.errorView.alpha = 0.5
        UIView.animateWithDuration(fadeDuration, animations: {[unowned self] in
            self.errorView.alpha = 0
        })
        errorView.hidden = true
    }
}
