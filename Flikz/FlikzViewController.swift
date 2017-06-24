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
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Disable seperator
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.separatorStyle = .none
        
        // Add background black color
        self.tableView.backgroundView = nil;
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.backgroundColor = UIColor.black
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(loadNetworkData(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        loadNetworkData(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlikCell", for: indexPath) as! FlikCell
        if let movie = movies?[indexPath.row] {
            cell.titleLabel.text = movie.title ?? "No Title"
            cell.descriptionLabel.text = movie.description ?? "No Description"
            cell.selectionStyle = .none
            
            movie.setPosterThumbail(cell.posterView)
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                tableView.deselectRow(at: indexPath, animated: true)
                if let movie = movies?[indexPath.row] {
                    if let detailViewController = segue.destination as? DetailViewController {
                        detailViewController.movie = movie
                    }
                }
            }
            
        }
    }
    
    func loadNetworkData(_ refreshControl: UIRefreshControl){
        // Clear error
        errorView.isHidden = true
        
        // Attempt a fetch!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Movie.fetchEndpoint(endpoint, successCallback: {[unowned self](movies) -> Void in
            self.movies = movies
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: {[unowned self] (error) -> Void in
                // TODO: Add image
                self.showError("Network Error", errorImg: nil)
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                MBProgressHUD.hide(for: self.view, animated: true)
            })
    }
    
    func showError(_ errorText: String, errorImg: UIImage?){
        errorLabel.text = errorText
        
        // Animate
        errorView.alpha = 0
        errorView.isHidden = false
        UIView.animate(withDuration: fadeDuration, animations: {[unowned self] in
            self.errorView.alpha = 0.9
        })
        // TODO - Implement image
    }
    func hideError(){
        self.errorView.alpha = 0.9
        UIView.animate(withDuration: fadeDuration, animations: {[unowned self] in
            self.errorView.alpha = 0
        })
        errorView.isHidden = true
    }
}
