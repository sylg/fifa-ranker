//
//  GameLogTableViewCell.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 10/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import UIKit

class GameLogTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
