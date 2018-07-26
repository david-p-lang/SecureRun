//
//  ConfigViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/23/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class ConfigViewController: UITableViewController {
    
    //MARK - Custom Cell Classes
    
    class StartDelayCell : UITableViewCell {
        @IBOutlet weak var startDelayLabel: UILabel!
    }
    
    class UnitsCell : UITableViewCell {
        @IBOutlet weak var unitsLabel: UILabel!
    }
    
    class VoiceFeedbackCell : UITableViewCell {
        @IBOutlet weak var voiceFeedbackLabel: UILabel!
        
    }
    
    class ConfigureDisplaysCell : UITableViewCell {
        @IBOutlet weak var configureDisplaysLabel: UILabel!
    
    }
    
    //MARK - Variables
    
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

    @IBOutlet weak var configTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ConfigViewController.UnitsCell.self, forCellReuseIdentifier: "Units")
        self.tableView.register(ConfigViewController.VoiceFeedbackCell.self, forCellReuseIdentifier: "VoiceFeedback")
        self.tableView.register(ConfigViewController.ConfigureDisplaysCell.self, forCellReuseIdentifier: "configureDisplay")
        self.tableView.register(ConfigViewController.StartDelayCell.self, forCellReuseIdentifier: "StartDelay")


    }
    
    //MARK - Tableview Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configSettings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch configSettings[indexPath.row] {
        case "Units":
            let cell:UnitsCell = self.configTableView.dequeueReusableCell(withIdentifier: "Units", for: indexPath) as! ConfigViewController.UnitsCell
            cell.unitsLabel?.text = "Units"
            cell.textLabel?.text = "Units"

            return cell
        case "Voice Feedback":
            let cell:VoiceFeedbackCell = self.configTableView.dequeueReusableCell(withIdentifier: "VoiceFeedback", for: indexPath) as! ConfigViewController.VoiceFeedbackCell
            cell.voiceFeedbackLabel?.text = "VoiceFeedback"
            cell.textLabel?.text = "VoiceFeedback"

            return cell
        case "Configurable Displays":
            let cell:ConfigureDisplaysCell = self.configTableView.dequeueReusableCell(withIdentifier: "configureDisplay", for: indexPath) as! ConfigViewController.ConfigureDisplaysCell
            cell.configureDisplaysLabel?.text = "configureDisplay"
            cell.textLabel?.text = "configureDisplay"

            return cell
        case "Start Delay":
            let cell:StartDelayCell = self.configTableView.dequeueReusableCell(withIdentifier: "StartDelay", for: indexPath) as! ConfigViewController.StartDelayCell
            cell.startDelayLabel?.text = "Start Delay"
            cell.textLabel?.text = "Start Delay"
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}
