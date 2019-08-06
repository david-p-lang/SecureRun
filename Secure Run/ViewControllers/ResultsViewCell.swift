//
//  ResultsViewCell.swift
//  Secure Run
//
//  Created by David Lang on 7/28/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class ResultsViewCell: UITableViewCell {

    //@IBOutlet weak var date: UILabel!
    
    var date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    //@IBOutlet weak var distance: UILabel!
    
    var distance:UILabel = {
        let distance = UILabel()
        distance.translatesAutoresizingMaskIntoConstraints = false
        return distance
    }()
    
    var time : UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    //@IBOutlet weak var time: UILabel!
    //@IBOutlet weak var calories: UILabel!
    
    var calories: UILabel = {
        let calories = UILabel()
        calories.translatesAutoresizingMaskIntoConstraints = false
        return calories
    }()
    
    var maximumPace : UILabel = {
        let maximumPace = UILabel()
        maximumPace.translatesAutoresizingMaskIntoConstraints = false
        return maximumPace
    }()
    
    //@IBOutlet weak var maximumPace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
