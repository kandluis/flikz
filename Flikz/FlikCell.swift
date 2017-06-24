//
//  FlikCell.swift
//  Flikz
//
//  Created by Luis Perez on 10/16/16.
//  Copyright © 2016 Luis PerezBunnyLemon. All rights reserved.
//

import UIKit

class FlikCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Better cell layout
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
