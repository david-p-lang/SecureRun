//
//  ViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/22/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {

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
    @IBOutlet weak var secondOpenLabel: UILabel!
    @IBOutlet weak var secondOpenCaptionLabel: UILabel!
    
    @IBOutlet weak var workoutControlButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var centralButtonsStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
        } catch {
            print(error)
        }
            configureButtons()
        
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
        firstOpenLabel.text = formattedPace
    }
    
    
    //MARK -- Save, Stop, Start
    
    private func startRun(){
        if secondsWhenPaused > 0 {
            //TODO adjust for preferences
            say(communication: "Paused")
            seconds = secondsWhenPaused
            distance = distanceWhenPaused
        } else {
            say(communication: "Start")
            seconds = 0
            distance = Measurement(value: 0, unit: UnitLength.meters)
            locationList.removeAll()

        }
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
        
    }
    
    func resumeRun() {
        
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        distanceWhenPaused.value = 0
        secondsWhenPaused = 0
        updateDisplay()
    }
    
    func stopTapped() {
        let distanceMessage = "Distance: \(FormatDisplay.distance(distance.value))"
        let timeMessage = "\nTime: \(calculateDisplayTime(seconds: seconds))"
        let message = distanceMessage + timeMessage
        let alertController = UIAlertController(title: "End Run?", message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.startRun()
        }))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            self.stopRun()
            self.saveRun()
            self.performSegue(withIdentifier: "history", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
            self.stopRun()
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
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func calculateDisplayTime(seconds: Int) -> String {
        return String(seconds / 3600) + ":" + String((seconds % 3600) / 60) + ":" + String((seconds % 3600) % 60)
    }
    
    func configureButtons() {
        let shadowRadius:CGFloat = 0.5
        let shadowOpacity:Float = 1.0
        let shadowColor:CGColor = UIColor.darkGray.cgColor
        
        workoutControlButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        workoutControlButton.layer.shadowRadius = shadowRadius
        workoutControlButton.layer.shadowColor = shadowColor
        workoutControlButton.layer.shadowOpacity = shadowOpacity
        workoutControlButton.layer.cornerRadius = workoutControlButton.frame.size.height / 2
        
        historyButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        historyButton.layer.shadowRadius = shadowRadius
        historyButton.layer.shadowColor = shadowColor
        historyButton.layer.shadowOpacity = shadowOpacity
        historyButton.layer.cornerRadius = historyButton.frame.size.height / 2
        
        optionsButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        optionsButton.layer.shadowRadius = shadowRadius
        optionsButton.layer.shadowColor = shadowColor
        optionsButton.layer.shadowOpacity = shadowOpacity
        optionsButton.layer.cornerRadius = optionsButton.frame.size.height / 2
        
        resumeButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        resumeButton.layer.shadowRadius = shadowRadius
        resumeButton.layer.shadowColor = shadowColor
        resumeButton.layer.shadowOpacity = shadowOpacity
        resumeButton.layer.cornerRadius = optionsButton.frame.size.height / 2
        
        finishButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        finishButton.layer.shadowRadius = shadowRadius
        finishButton.layer.shadowColor = shadowColor
        finishButton.layer.shadowOpacity = shadowOpacity
        finishButton.layer.cornerRadius = optionsButton.frame.size.height / 2
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
                //let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                //let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                //print("\(distance)")
               //print("\(coordinates)")
               // print("\(region)")
            }
            locationList.append(newLocation)
        }
    }
}

