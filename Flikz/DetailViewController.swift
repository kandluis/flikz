//
//  DetailViewController.swift
//  Flikz
//
//  Created by Luis Perez on 10/16/16.
//  Copyright © 2016 Luis PerezBunnyLemon. All rights reserved.
//
import UIKit

class DetailViewController: UIViewController {
    
    var movie: Movie?

    @IBOutlet weak var posterBackgroundImage: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = scrollView.frame.size.width
        let height = detailsView.frame.height + scrollView.frame.size.height
        scrollView.contentSize = CGSize(width: width, height: height)
        
        if let movie = movie {
            titleLabel.text = movie.title
            detailsLabel.text = movie.description
            
            // Fit text size! 
            detailsLabel.sizeToFit()
            if let posterURL = movie.getOriginalPosterURL() {
                posterBackgroundImage.setImageWithURL(posterURL)
            }
        }

    }
}
