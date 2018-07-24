//
//  ConfigViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/23/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class ConfigViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    enum UnitType: String {
        case Metric
        case Imperial
    }
    
    var unitType: UnitType = UnitType.Imperial
    
    var voiceFeedback: Bool = false
    
    enum VoiceFeedbackInterval: Float {
        case Quarter = 0.25
        case Half = 0.5
        case Mile = 1.0
    }
    
    enum OptionalDisplay : String {
        case CurrentPace
        case HeartRate
        case AveragePace
        case MaximumPace
        case Calories
    }
    
    var delayStart : Bool = false
    
    enum DelayStartTime : Int {
        case short = 10
        case medium = 30
        case long = 60
    }
    
    var configSettings = ["Units", "Voice Feedback", "Configurable Displays", "Start Delay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    //MARK - Tableview Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configSettings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath)
        cell.textLabel?.text = configSettings[indexPath.row]
        return cell
        
    }
    
    
}
