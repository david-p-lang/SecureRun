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

import Foundation

struct FormatDisplay {
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return FormatDisplay.distance(distanceMeasurement)
    }
    
    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let trimNumber = NumberFormatter()
        trimNumber.maximumFractionDigits = 2
        trimNumber.minimumIntegerDigits = 1
        let formatter = MeasurementFormatter()
        formatter.numberFormatter = trimNumber
        return formatter.string(from: distance)
    }
    
    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        let trimNumber = NumberFormatter()
        trimNumber.maximumFractionDigits = 0
        formatter.numberFormatter = trimNumber
        formatter.unitOptions = [.providedUnit]
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        let miD = Measurement(value: distance.value, unit: UnitLength.meters).converted(to: UnitLength.miles)
        
        //print("minutes \(seconds/60)")
        if seconds > 0 {
            let paceDecimal = (Double(seconds)/60.0 / miD.value)
            if paceDecimal > 0 && paceDecimal < 100 {
                let paceSeconds = paceDecimal.truncatingRemainder(dividingBy: 1) * 60
                let paceSecondsString = String(format: "%02.0f", paceSeconds)
                let tempString = "\(Int(paceDecimal))"
                let minuteString = tempString.trimmingCharacters(in: .whitespaces)
                let returnString = (minuteString + ":" + paceSecondsString)
                return returnString
            }
        } else {
            return "0:00"
        }
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.minutesPerMile)
        let minutePace = (speed.value.truncatingRemainder(dividingBy: 1) * 59)
        if minutePace < 10 {
          let localeSpeed = formatter.string(from: speed.converted(to: UnitSpeed.minutesPerMile)) + ":" + String(format: "%02.0f", minutePace)
            return localeSpeed
        } else {
            let localeSpeed = formatter.string(from: speed.converted(to: UnitSpeed.minutesPerMile)) + ":" + String(format: "%02.0f", minutePace)
            return localeSpeed
        }
    }
    
    static func date(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else {return ""}
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
    
}
