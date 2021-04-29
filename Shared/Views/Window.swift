import SwiftUI

struct Window: View {
    @Binding var document: Document
    @State var intro = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    var body: some View {
        NavigationView {
            Languages(intro: $intro, document: $document)
                .frame(minWidth: 230)
            Editor(document: $document)
        }
        .frame(minWidth: 840, minHeight: 540)
        .sheet(isPresented: $intro) {
            Welcome(intro: $intro, document: $document)
                .frame(width: 440, height: 440)
        }
    }
}
