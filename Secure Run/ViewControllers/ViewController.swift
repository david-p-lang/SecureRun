//
//  ViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/22/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

//includes code from https://www.raywenderlich.com/

//
/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreLocation
import MapKit
import AVFoundation
import CoreMotion
import MessageUI

class ViewController: UIViewController, AVSpeechSynthesizerDelegate, MFMessageComposeViewControllerDelegate {

    let defaults = UserDefaults.standard
    
    enum WorkoutState {
        case started
        case paused
        case stopped
    }
    var workoutState:WorkoutState = WorkoutState.stopped
    
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
        case none
    }
    
    var paceTicker = 0
    
    var voiceSettingS: [String: Bool] = ["distanceState":false, "timeState":false]

    private var run: Run?

    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    private let locationManager = LocationManager.shared
    private var latitude: Double = 0.0
    private var longitute: Double = 0.0
    private var seconds = 0
    private var secondsWhenPaused = 0
    private var secondsPaceStart  = 0
    private var secondsPaceEnd = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var distancePaceCalcStart = Measurement(value: 0, unit: UnitLength.meters)
    private var distancePaceCalcEnd = Measurement(value: 0, unit: UnitLength.meters)

    private var distanceWhenPaused = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeCaptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceCaptionLabel: UILabel!
    @IBOutlet weak var firstOpenLabel: UILabel!
    @IBOutlet weak var firstOpenCaptionLabel: UILabel!
    
    @IBOutlet weak var workoutControlButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var centralButtonsStack: UIStackView!
    @IBOutlet weak var crumbButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        
        updateDisplay()
        
            let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playback), with: .duckOthers)
        } catch {
            print(error)
        }
        configureButton(button: workoutControlButton)
        configureButton(button: historyButton)
        configureButton(button: crumbButton)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func checkMileStones() {
        
    }
    //MARK --Update Display
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        firstOpenLabel.text = "\(formattedPace)"
    }
    
    
    //MARK -- Save, Stop, Start
    
    @IBAction func workoutControl(_ sender: Any) {
        if workoutState == WorkoutState.stopped {
            print("workout started")
            startRun()
            workoutState = WorkoutState.started
            workoutControlButton.setTitle("Pause", for: .normal)
        } else if workoutState == WorkoutState.started {
            print("workout paused")
            pauseRun()
            workoutState = WorkoutState.paused
            workoutControlButton.setTitle("Stop", for: .normal)
        } else if workoutState == WorkoutState.paused {
            print("workout stopped")
            workoutState = WorkoutState.stopped
            stopTapped()
            workoutControlButton.setTitle("Start", for: .normal)
        }
        
    }
    private func startRun(){
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        workoutState = WorkoutState.started
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.eachSecond()
        })
        startLocationUpdates()
    }
    
    func pauseRun() {
        locationManager.stopUpdatingLocation()
        secondsWhenPaused = seconds
        distanceWhenPaused = distance
        timer?.invalidate()
        workoutControlButton.setTitle("Stop", for: .normal)
        workoutState = WorkoutState.paused
    }
    
    func resumeRun() {
        seconds = secondsWhenPaused
        distance = distanceWhenPaused
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.eachSecond()
        })
        startLocationUpdates()
        workoutControlButton.setTitle("Pause", for: .normal)
        workoutState = WorkoutState.started
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        distanceWhenPaused.value = 0
        secondsWhenPaused = 0
        updateDisplay()
        workoutControlButton.setTitle("Start", for: .normal)
        workoutState = WorkoutState.stopped
    }
    func resetRun() {
        locationManager.stopUpdatingLocation()
        distanceWhenPaused.value = 0
        secondsWhenPaused = 0
        distance.value = 0
        seconds = 0
        updateDisplay()
        workoutControlButton.setTitle("Start", for: .normal)
        workoutState = WorkoutState.stopped
    }
    
    func stopTapped() {
        let distanceMessage = "Distance: \(FormatDisplay.distance(distance.value))"
        let timeMessage = "\nTime: \(calculateDisplayTime(seconds: seconds))"
        let message = distanceMessage + timeMessage
        pauseRun()
        let alertController = UIAlertController(title: "End Run?", message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.resumeRun()
        }))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            self.stopRun()
            self.saveRun()
            self.resetRun()
            self.performSegue(withIdentifier: "history", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
            self.stopRun()
            self.resetRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alertController, animated: true)
    }
    
    private func saveRun() {
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        print("Distance saverun")
        print(distance.value)
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        CoreDataStack.saveContext()
        run = newRun
        distance.value = 0
        seconds = 0


    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    @IBAction func sendLocation(_ sender: Any) {
        pauseRun()
    }
    
    @IBAction func sendCrumb(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Longitude: \n\(longitute) \n Latitude: \n\(latitude)"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        pauseRun()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func calculateDisplayTime(seconds: Int) -> String {
        return String(seconds / 3600) + ":" + String((seconds % 3600) / 60) + ":" + String((seconds % 3600) % 60)
    }
    
    func configureButton(button: UIButton) {
        let shadowRadius:CGFloat = 0.5
        let shadowOpacity:Float = 1.0
        let shadowColor:CGColor = UIColor.darkGray.cgColor
        
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.shadowRadius = shadowRadius
        button.layer.shadowColor = shadowColor
        button.layer.shadowOpacity = shadowOpacity
        button.layer.cornerRadius = 2
    }
    
    func applySettings() {
        
        distanceState = defaults.bool(forKey: VoiceSettings.distanceState.rawValue)
        timeState = defaults.bool(forKey: VoiceSettings.timeState.rawValue)
        currentPaceState = defaults.bool(forKey: VoiceSettings.currentPaceState.rawValue)
        maximumPaceState = defaults.bool(forKey: VoiceSettings.maximumPaceState.rawValue)
        caloriesState = defaults.bool(forKey: VoiceSettings.caloriesState.rawValue)
        heartRateState = defaults.bool(forKey: VoiceSettings.heartRateState.rawValue)
    }
    
    func say(communication: String) {
        let utterance = AVSpeechUtterance(string: communication)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("didUpdateLocation")
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 15 && abs(howRecent) < 10 else { continue }
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                longitute = lastLocation.coordinate.longitude
                latitude = lastLocation.coordinate.latitude
                //let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                //let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                //print("\(distance)")
               //testLabel.text = "\(lastLocation.coordinate.longitude)  \(lastLocation.coordinate.latitude)"
               // print("\(region)")
            }
            locationList.append(newLocation)
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
