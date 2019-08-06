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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(distance)
        self.addSubview(time)
        
        distance.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0).isActive = true
        distance.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
