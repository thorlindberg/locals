import SwiftUI

struct Progress {
    
    @Binding var data: Storage.Format
    
    func loading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            data.progress += 0.1
            if data.progress < 1.0 {
                self.loading()
            } else {
                data.progress = CGFloat.zero
            }
        }
    }
    
    func load(string: String) {
        self.loading()
        data.status.append("\(Time().current()) - \(string)")
    }
    
    func log(string: String) {
        data.status.append("\(Time().current()) - \(string)")
    }
    
}
