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
        if let movie = movie {
            titleLabel.text = movie.title
            detailsLabel.text = movie.description
            
            // Fit text size! 
            detailsLabel.sizeToFit()
            
            // Fit subview
            resizeToFitSubvies(detailsView)
            
            // Load poster
            movie.setPoster(posterBackgroundImage)
        }
        
        // Add tab bar navigation.
        let width = scrollView.frame.size.width
        let height = detailsView.frame.origin.y + detailsView.frame.size.height + (self.tabBarController?.tabBar.bounds.height ?? 50) + 4
        scrollView.contentSize = CGSize(width: width, height: height)


    }
    
    func resizeToFitSubvies(view: UIView){
        var w: CGFloat = 0
        var h: CGFloat = 0
        
        for subview in view.subviews {
            let fw = subview.frame.origin.x + subview.frame.size.width
            let fh = subview.frame.origin.y + subview.frame.size.height
            w = max(fw, w)
            h = max(fh, h)
        }
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, w, h)
    }
}
