import SwiftUI

struct Progress {
    
    @Binding var status: [String]
    @Binding var progress: CGFloat
    
    func loading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.progress += 0.1
            if self.progress < 1.0 {
                self.loading()
            } else {
                self.progress = CGFloat.zero
            }
        }
    }
    
    // Progress(status: $status, progress: $progress).load(string: "")
    
    func load(string: String) {
        self.loading()
        self.status.append("\(Time().current()) - \(string)")
    }
    
    func log(string: String) {
        self.status.append("\(Time().current()) - \(string)")
    }
    
}
