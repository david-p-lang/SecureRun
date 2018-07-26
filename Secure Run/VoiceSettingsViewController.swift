//
//  VoiceSettingsViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/24/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit

class VoiceSettingsViewController: UIViewController {

    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var currentPaceSwitch: UISwitch!
    @IBOutlet weak var maximumPaceSwitch: UISwitch!
    @IBOutlet weak var averagePaceSwitch: UISwitch!
    @IBOutlet weak var caloriesSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var heartRateSwitch: UISwitch!
    @IBOutlet weak var intervalDistanceSelector: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
