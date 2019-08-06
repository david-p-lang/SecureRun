//
//  ViewController.swift
//  VisionSample
//
//  Created by chris on 19/06/2017.
//  Copyright © 2017 MRM Brand Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class FormViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  // video capture session
  let session = AVCaptureSession()
  // preview layer
  var previewLayer: AVCaptureVideoPreviewLayer!
  // queue for processing video frames
  let captureQueue = DispatchQueue(label: "captureQueue")
  // overlay layer
  var gradientLayer: CAGradientLayer!
    var labelGradient: CAGradientLayer!

  // vision request
  var visionRequests = [VNRequest]()
    var strikeRequests = [VNRequest]()
    var legExtensionRequests = [VNRequest]()
    
    var runnerOrientationArray = Array(repeating: "", count: 10)
    var strikeOrientationArray = Array(repeating: "", count: 10)
    
    enum Orientation {
        case front
        case side
        case back
        case none
    }
    
    var orientationState = Orientation.none

    
    var classificationList = [Any]()
    
    var recognitionThreshold : Float = 0.25
  
    @IBOutlet weak var thresholdStackView: UIStackView!
    @IBOutlet weak var threshholdLabel: UILabel!
    @IBOutlet weak var threshholdSlider: UISlider!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var resultView: UILabel!
    @IBOutlet weak var runnerOrientationLabel: UILabel!
    @IBOutlet weak var strikeLabel: UILabel!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // get hold of the default video camera
    guard let camera = AVCaptureDevice.default(for: .video) else {
      fatalError("No video camera available")
    }
    do {
      // add the preview layer
      previewLayer = AVCaptureVideoPreviewLayer(session: session)
      previewView.layer.addSublayer(previewLayer)
      // add a slight gradient overlay so we can read the results easily
      gradientLayer = CAGradientLayer()
      gradientLayer.colors = [
        UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor,
        UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor,
      ]
      gradientLayer.locations = [0.0, 0.3]
      self.previewView.layer.addSublayer(gradientLayer)
        
       labelGradient = CAGradientLayer()
        labelGradient.colors = [
            UIColor.init(red: 0, green: 0, blue: 0.1, alpha: 0.5).cgColor,
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor,
        ]
        labelGradient.locations = [0.5, 0.0]
        runnerOrientationLabel.layer.addSublayer(labelGradient)
      
      // create the capture input and the video output
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      
      let videoOutput = AVCaptureVideoDataOutput()
      videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
      videoOutput.alwaysDiscardsLateVideoFrames = true
      videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
      session.sessionPreset = .high
      
      // wire up the session
      session.addInput(cameraInput)
      session.addOutput(videoOutput)
      
      // make sure we are in portrait mode
      let conn = videoOutput.connection(with: .video)
      conn?.videoOrientation = .portrait
      
      // Start the session
      session.startRunning()
      
        //RUNNER ORIENTATION
        // set up the runner orientation model
        guard let model = try? VNCoreMLModel(for: RunClassifier2().model) else {
        fatalError("Could not load model")
        }
        // set up the request using our runner orientation model
        let classificationRequest = VNCoreMLRequest(model: model, completionHandler: handleClassifications)
        classificationRequest.imageCropAndScaleOption = .scaleFill
        visionRequests = [classificationRequest]

        
        //FOOT STRIKE MODEL
        // set up the foot strike model
        guard let strikeModel = try? VNCoreMLModel(for: StrikeClassifier().model) else {
            fatalError("Could not load model")
        }
        // set up the request using our foot strike model
        let strikeClassificationRequest = VNCoreMLRequest(model: strikeModel, completionHandler: handleStrikeClassifications)
        strikeClassificationRequest.imageCropAndScaleOption = .scaleFill
        strikeRequests = [strikeClassificationRequest]
//
//        //LEG EXTENSION STRIKE MODEL
//        // set up the foot strike model
//        guard let extensionModel = try? VNCoreMLModel(for: RunClassifier().model) else {
//            fatalError("Could not load model")
//        }
//        // set up the request using our foot strike model
//        let extensionClassificationRequest = VNCoreMLRequest(model: strikeModel, completionHandler: handleClassifications)
//        extensionClassificationRequest.imageCropAndScaleOption = .scaleFill
//        legExtensionRequests = [strikeClassificationRequest]
    
    } catch {
    fatalError(error.localizedDescription)
    }
    
    updateThreshholdLabel()
  }
    
    func updateThreshholdLabel () {
        self.threshholdLabel.text = "Threshold: " + String(format: "%.2f", recognitionThreshold)
    }
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer.frame = self.previewView.bounds;
    gradientLayer.frame = self.previewView.bounds;
    
    let orientation: UIDeviceOrientation = UIDevice.current.orientation;
    switch (orientation) {
    case .portrait:
        previewLayer?.connection?.videoOrientation = .portrait
    case .landscapeRight:
        previewLayer?.connection?.videoOrientation = .landscapeLeft
    case .landscapeLeft:
        previewLayer?.connection?.videoOrientation = .landscapeRight
    case .portraitUpsideDown:
        previewLayer?.connection?.videoOrientation = .portraitUpsideDown
    default:
        previewLayer?.connection?.videoOrientation = .portrait
    }
  }
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    connection.videoOrientation = .portrait
    
    var requestOptions:[VNImageOption: Any] = [:]
    
    if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
      requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
    }
    
    // for orientation see kCGImagePropertyOrientation
    let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: requestOptions)
    do {
      try imageRequestHandler.perform(self.visionRequests)
        //try imageRequestHandler.perform(self.strikeRequests)
    } catch {
      print(error)
    }
  }
    
    @IBAction func userTapped(sender: Any) {
        self.thresholdStackView.isHidden = !self.thresholdStackView.isHidden
    }
    
    @IBAction func sliderValueChanged(slider: UISlider) {
        self.recognitionThreshold = slider.value
        updateThreshholdLabel()
    }
  //Process orientation classifications
  func handleClassifications(request: VNRequest, error: Error?) {
    if let theError = error {
      print("Error: \(theError.localizedDescription)")
      return
    }
    guard let observations = request.results else {
      print("No results")
      return
    }
    
    let classifications = observations[0...2] // top 3 results
        .compactMap({ $0 as? VNClassificationObservation })
        .compactMap({$0.confidence > recognitionThreshold ? $0 : nil})
      .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
        .joined(separator: "\n")
    //print(observations
    //    .compactMap({$0 as? VNClassificationObservation}).compactMap({$0.identifier}))
    switch (observations.compactMap({$0 as? VNClassificationObservation}).compactMap({$0.identifier})[0]) {
        case "front":
            runnerOrientationArray.insert("front", at: 0)
            runnerOrientationArray.removeLast()
           // print(runnerOrientationArray.max()!)
        case "side":
            runnerOrientationArray.insert("side", at: 0)
            runnerOrientationArray.removeLast()
            //print(runnerOrientationArray.max()!)
        case "back":
            runnerOrientationArray.insert("back", at: 0)
            runnerOrientationArray.removeLast()
            //print(runnerOrientationArray.max()!)
        default:
            print("No orientation determined this round")
    }
    
    if let currentOrientation = runnerOrientationArray.max() {
        print(currentOrientation)
        switch (currentOrientation) {
        case "front":
            orientationState = Orientation.front
        case "back":
            orientationState = Orientation.front
        case "side":
            orientationState = Orientation.side
        default:
            print("Current orientation not determined")
        }
    }
    
    //classificationList.append(observations[1].identifier)
    DispatchQueue.main.async {
        self.runnerOrientationLabel.text = "Runner Oreintation:  \(self.runnerOrientationArray.max()!)"

        self.resultView.text = classifications
    }
    //print(classificationList)
    
  }
    func handleStrikeClassifications(request: VNRequest, error: Error?) {
        print("in the handle Strike classifications function")
        if let theError = error {
            print("Error: \(theError.localizedDescription)")
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        if orientationState == Orientation.side {
            let classifications = observations[0...1] // top 2 results
                .compactMap({ $0 as? VNClassificationObservation })
                .compactMap({$0.confidence > recognitionThreshold ? $0 : nil})
                .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
                .joined(separator: "\n")
            
            switch (observations.compactMap({$0 as? VNClassificationObservation}).compactMap({$0.identifier})[0]) {
            case "heel strike":
                strikeOrientationArray.insert("heel strike", at: 0)
                strikeOrientationArray.removeLast()
                print(strikeOrientationArray)
            case "midfoot strike":
                strikeOrientationArray.insert("midfoot strike", at: 0)
                strikeOrientationArray.removeLast()
                print(runnerOrientationArray)

            default:
                print("No foot strike determined this round")
            }
            
        }
        DispatchQueue.main.async {
            self.strikeLabel.text = "Strike Type:  \(self.strikeOrientationArray.max()!)"
        }
    }
}

