//
//  VoiceSettingsViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/24/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class VoiceSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
   
    let defaults = UserDefaults.standard

    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var currentPaceSwitch: UISwitch!
    @IBOutlet weak var maximumPaceSwitch: UISwitch!
    @IBOutlet weak var averagePaceSwitch: UISwitch!
    @IBOutlet weak var caloriesSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var heartRateSwitch: UISwitch!
    @IBOutlet weak var intervalDistanceSelector: UIPickerView!
    
    var distanceState = false
    var timeState = false
    var currentPaceState = false
    var averagePaceState = false
    var maximumPaceState = false
    var caloriesState = false
    var heartRateState = false
    
    enum VoiceSettings: String {
        case distanceState
        case timeState
        case currentPaceState
        case averagePaceState
        case maximumPaceState
        case caloriesState
        case heartRateState
    }
    
    enum VoiceFeedbackInterval: Float {
        case Quarter = 0.25
        case Half = 0.5
        case Mile = 1.0
    }
    
    var voiceFeedbackArray = [0.25, 0.5, 1.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceSwitch.isOn = defaults.bool(forKey: VoiceSettings.distanceState.rawValue)
        timeSwitch.isOn = defaults.bool(forKey: VoiceSettings.timeState.rawValue)
        currentPaceSwitch.isOn = defaults.bool(forKey: VoiceSettings.currentPaceState.rawValue)
        maximumPaceSwitch.isOn = defaults.bool(forKey: VoiceSettings.maximumPaceState.rawValue)
        caloriesSwitch.isOn = defaults.bool(forKey: VoiceSettings.caloriesState.rawValue)
        heartRateSwitch.isOn = defaults.bool(forKey: VoiceSettings.heartRateState.rawValue)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func distanceToggled(_ sender: Any) {
        switch distanceSwitch.isOn {
        case true:
            distanceSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.distanceState.rawValue)
        case false:
            distanceSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.distanceState.rawValue)
        }
    }
    @IBAction func timeToggled(_ sender: Any) {
        switch timeSwitch.isOn {
        case true:
            timeSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.timeState.rawValue)
        case false:
            timeSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.timeState.rawValue)
        }
    }
    @IBAction func currentPaceToggled(_ sender: Any) {
        switch currentPaceSwitch.isOn {
        case true:
            currentPaceSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.currentPaceState.rawValue)
        case false:
            currentPaceSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.currentPaceState.rawValue)
        }
    }
    @IBAction func averagePaceToggled(_ sender: Any) {
        switch averagePaceSwitch.isOn {
        case true:
            averagePaceSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.averagePaceState.rawValue)
        case false:
            averagePaceSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.averagePaceState.rawValue)
        }
    }
    @IBAction func maximumPageToggled(_ sender: Any) {
        switch maximumPaceSwitch.isOn {
        case true:
            maximumPaceSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.maximumPaceState.rawValue)
        case false:
            maximumPaceSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.maximumPaceState.rawValue)
        }
    }
    @IBAction func caloriesToggled(_ sender: Any) {
        switch caloriesSwitch.isOn {
        case true:
            caloriesSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.caloriesState.rawValue)
        case false:
            caloriesSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.caloriesState.rawValue)
        }
    }
    @IBAction func heartRateToggled(_ sender: Any) {
        switch heartRateSwitch.isOn {
        case true:
            heartRateSwitch.isOn = false
            defaults.setValue(false, forKey: VoiceSettings.heartRateState.rawValue)
        case false:
            heartRateSwitch.isOn = true
            defaults.setValue(true, forKey: VoiceSettings.heartRateState.rawValue)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(voiceFeedbackArray[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.setValue(VoiceFeedbackInterval.Quarter.rawValue, forKey: "FeedbackInterval")
    }
     // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
