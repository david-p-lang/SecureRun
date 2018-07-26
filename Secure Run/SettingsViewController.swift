//
//  SettingsViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/24/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
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
    
    @IBOutlet weak var delayButton: UISegmentedControl!
    @IBOutlet weak var unitsButton: UISegmentedControl!
    @IBOutlet weak var voiceFeedbackButton: UIButton!
    
    var configSettings = ["Units", "Voice Feedback", "Configurable Displays", "Start Delay"]
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceFeedbackButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        voiceFeedbackButton.layer.shadowRadius = 0.5
        voiceFeedbackButton.layer.shadowColor = UIColor.darkGray.cgColor
        voiceFeedbackButton.layer.shadowOpacity = 1.0
        voiceFeedbackButton.layer.cornerRadius = voiceFeedbackButton.frame.size.height / 2
        
        delayButton.layer.cornerRadius = 1
        delayButton.layer.borderWidth = 5
        delayButton.layer.borderColor = UIColor.white.cgColor
        
        unitsButton.layer.cornerRadius = 1
        unitsButton.layer.borderWidth = 5
        unitsButton.layer.borderColor = UIColor.white.cgColor
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
