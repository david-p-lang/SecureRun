//
//  ResultsViewCell.swift
//  Secure Run
//
//  Created by David Lang on 7/28/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class ResultsViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var maximumPace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
