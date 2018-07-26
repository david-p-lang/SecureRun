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
        trimNumber.maximumFractionDigits = 2
        formatter.numberFormatter = trimNumber
        formatter.unitOptions = [.providedUnit]
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.minutesPerMile)
        let localeSpeed = formatter.string(from: speed.converted(to: outputUnit))
        print(localeSpeed)
        return localeSpeed
    }
    
    static func date(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else {return ""}
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
    
}
