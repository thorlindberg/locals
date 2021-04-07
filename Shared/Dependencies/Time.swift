import SwiftUI

struct Time {
    
    let hours = String(Calendar.current.component(.hour, from: Date()))
    let minutes = String(Calendar.current.component(.minute, from: Date()))
    
    func current() -> String {
        var hour = hours
        var minute = minutes
        if hours.count == 1 {
            hour = "0" + hours
        }
        if minutes.count == 1 {
            minute = "0" + minutes
        }
        return hour + "." + minute
    }
}
