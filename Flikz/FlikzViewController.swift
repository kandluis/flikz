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
    
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Movie.fetchNowPlaying({[unowned self](movies) -> Void in
            self.movies = movies
            self.tableView.reloadData()
        }, error: {(error) -> Void in
            print("Error occurred retrieving data: \(error)")
        })
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
            
            // TODO: Add placeholder
            if let smallImageURL = movie.getPosterURL(342) {
                cell.posterView.setImageWithURL(smallImageURL, placeholderImage: nil)
            }
            
        }
        return cell
    }
}
