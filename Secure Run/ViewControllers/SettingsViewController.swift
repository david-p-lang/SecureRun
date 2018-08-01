//
//  SettingsViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/24/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let defaults = UserDefaults.standard
    
    enum RunSettings: String {
        case Units = "Units"
        case StartDelay = "StartDelay"
        case LeftDisplay = "LeftDisplay"
        case RightDisplay = "RightDisplay"
    }
    
    enum UnitType: String {
        case Metric
        case Imperial
    }
    
    var unitType: UnitType = UnitType.Imperial
    
    var voiceFeedback: Bool = false
    
    let optionalDisplay : [String] = ["CurrentPace", "HeartRate", "AveragePace", "MaximumPace", "Calories"]
    
    var delayStart : Bool = false
    
    enum DelayStartTime : Int {
        case short = 10
        case medium = 30
        case long = 60
    }
    
    @IBOutlet weak var delayButton: UISegmentedControl!
    @IBOutlet weak var unitsButton: UISegmentedControl!
    @IBOutlet weak var voiceFeedbackButton: UIButton!
    @IBOutlet weak var leftDisplayPicker: UIStackView!
    @IBOutlet weak var rightDisplayPicker: UIStackView!
    
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return optionalDisplay.count
        } else {
            return optionalDisplay.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionalDisplay[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            defaults.setValue(optionalDisplay[row], forKey: RunSettings.LeftDisplay.rawValue)
            print("Left display = \(optionalDisplay[row])")
        } else {
            defaults.setValue(optionalDisplay[row], forKey: RunSettings.RightDisplay.rawValue)
            print("Right display = \(optionalDisplay[row])")
        }
    }
    

    @IBAction func setDelay(_ sender: Any) {
        switch delayButton.selectedSegmentIndex
        {
        case 0:
            defaults.set(0, forKey: RunSettings.StartDelay.rawValue)
            print("0 sec delay")
        case 1:
            defaults.set(10, forKey: RunSettings.StartDelay.rawValue)
            print("10 sec delay")
        case 2:
            defaults.set(30, forKey: RunSettings.StartDelay.rawValue)
            print("30 sec delay")
        case 3:
            defaults.set(60, forKey: RunSettings.StartDelay.rawValue)
            print("60 sec dealy")
        default:
            break
        }
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
