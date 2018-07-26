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

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    var workoutStarted:Bool = false
    
    private var run: Run?

    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        workoutControlButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        workoutControlButton.layer.shadowRadius = 0.5
        workoutControlButton.layer.shadowColor = UIColor.darkGray.cgColor
        workoutControlButton.layer.shadowOpacity = 1.0
        workoutControlButton.layer.cornerRadius = workoutControlButton.frame.size.height / 2
        
        historyButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        historyButton.layer.shadowRadius = 0.5
        historyButton.layer.shadowColor = UIColor.darkGray.cgColor
        historyButton.layer.shadowOpacity = 1.0
        historyButton.layer.cornerRadius = historyButton.frame.size.height / 2
        
        optionsButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        optionsButton.layer.shadowRadius = 0.5
        optionsButton.layer.shadowColor = UIColor.darkGray.cgColor
        optionsButton.layer.shadowOpacity = 1.0
        optionsButton.layer.cornerRadius = optionsButton.frame.size.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)

        print("\(seconds)")

        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        firstOpenLabel.text = "\(formattedPace)"
    }
    
    //MARK -- Save, Stop, Start
    
    private func startRun(){
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.eachSecond()
        })
        startLocationUpdates()
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
    }
    
    func stopTapped() {
        let alertController = UIAlertController(title: "End Run?", message: "Do you wish to end you run?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            self.stopRun()
            self.saveRun()
            //self.performSegue(withIdentifier: .details, sender: nil)
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
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    
    @IBAction func workoutControl(_ sender: Any) {
        if workoutStarted == false {
            startRun()
            workoutStarted = true
            workoutControlButton.setTitle("Stop", for: .normal)
        } else {
            workoutStarted = false
            workoutControlButton.setTitle("Start", for: .normal)
        }
  
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        //print("start location updates and delegate setting called")
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
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                //print("\(distance)")
               //print("\(coordinates)")
               // print("\(region)")
            }
            locationList.append(newLocation)
        }
    }
}

