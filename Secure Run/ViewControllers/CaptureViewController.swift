//
//  CaptureViewController.swift
//  Secure Run
//
//  Created by David Lang on 8/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        let videoOutput = AVCaptureMovieFileOutput()
        
        videoOutput.maxRecordedDuration = CMTime(seconds: 10, preferredTimescale: 600)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
    }
    


}
