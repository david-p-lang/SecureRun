//
//  CadenceViewController.swift
//  Secure Run
//
//  Created by David Lang on 9/18/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit
import CoreMotion

class CadenceViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!

    @IBOutlet weak var lblCadence: UILabel!
    var isObserverRunning: Bool = false
    // MARK: - Action Methods
    @IBAction func btnStartClicked() {
        if isObserverRunning
        {
            activityHelper.stopMonitoring()
            btnStart.setTitle("Start", for: UIControl.State.normal)
        }
        else
        {
            activityHelper.startMonitoring()
            btnStart.setTitle("Stop", for: UIControl.State.normal)
        }
        isObserverRunning = !isObserverRunning
    }
    
    override func viewDidLoad() {

        
        //Let's check availbale permissions first
//        activityHelper.isStepCountingAvailable ? lblSteps.setTextColor(UIColor.green) : lblSteps.setTextColor(UIColor.red)
//        activityHelper.isPaceAvailable ? lblPace.setTextColor(UIColor.green) : lblPace.setTextColor(UIColor.red)
//        activityHelper.isPaceAvailable ? lblAvgPace.setTextColor(UIColor.green) : lblAvgPace.setTextColor(UIColor.red)
//        activityHelper.isFloorCountingAvailable ? lblFloorsUp.setTextColor(UIColor.green) : lblFloorsUp.setTextColor(UIColor.red)
//        activityHelper.isFloorCountingAvailable ? lblFloorsDown.setTextColor(UIColor.green) : lblFloorsDown.setTextColor(UIColor.red)
        if activityHelper.isCadenceAvailable  {
         lblCadence.text = "Cadence Available"
        } else {
            lblCadence.text = "Cadence not Available"

        }
        //fetch historical pedometer data
        /* pass relevant start date and end date for historical data
         let startDate = Date().addingTimeInterval(-900)
         let endDate = Date()
         activityHelper.getStepsDataFor(startDate: startDate,
         endDate: endDate,
         successBlock: {(steps, distance, averagePace, pace, floorsAscended, floorsDscended, cadence,timeElapsed )  in
         self.lblSteps.setText("Steps : \(steps)")
         self.lblDistance.setText("Distance : \(self.getDistanceString(distance: distance))")
         self.lblAvgPace.setText("Avg Pace : \(self.calculateAvgPace(distance: distance, timeElapsed: timeElapsed))")
         self.lblPace.setText("Pace : \(self.getPaceString(pace: pace))")
         self.lblCadence.setText("Cadence : \(self.getPaceString(pace: cadence))")
         self.lblFloorsUp.setText("Floors Up : \(floorsAscended)")
         self.lblFloorsDown.setText("Floors Down : \(floorsDscended)")
         self.lblTime.setText("Time : \(self.secondsToHoursMinutesSeconds(timeElapsed))")
         }, errorBlock: { (error) in
         
         })
         */
        
        //Add activity observer here to bind data
        activityHelper.stepsCountingHandler = { steps, distance, averagePace, pace, floorsAscended, floorsDscended, cadence, timeElapsed in
//            self.lblSteps.setText("Steps : \(steps)")
//            self.lblDistance.setText("Distance : \(self.getDistanceString(distance: distance))")
//            self.lblAvgPace.setText("Avg Pace : \(self.calculateAvgPace(distance: distance, timeElapsed: timeElapsed))")
//            self.lblPace.setText("Pace : \(self.getPaceString(pace: pace))")
//            self.lblCadence.text = "Cadence : \(self.getPaceString(pace: cadence))"
            print(cadence)
            DispatchQueue.main.async {
                self.lblCadence.text = "Cadence : \(cadence)"
            }
            
            //            self.lblFloorsUp.setText("Floors Up : \(5)")
//            self.lblFloorsDown.setText("Floors Down : \(3)")
//            self.lblTime.setText("Time : \(self.secondsToHoursMinutesSeconds(timeElapsed))")
        }
    }
}

extension CadenceViewController
{
    // convert seconds to hh:mm:ss as a string
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> String
    {
        let hours = seconds / 3600
        let min = (seconds % 3600) / 60
        let sec = (seconds % 3600) % 60
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, min, sec)
        } else {
            return String(format: "%02i:%02i", min, sec)
        }
    }
    func calculateAvgPace(distance : Double, timeElapsed : Int )-> String {
        return getPaceString(pace: distance / Double(timeElapsed))
    }
    func getPaceString(pace : Double) -> String
    {
        return String(format: "%02.2f m/s",pace)
    }
    func getDistanceString(distance : Double) -> String
    {
        return String(format:"%02.02f mtr",distance)
    }
}

