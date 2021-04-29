import SwiftUI

struct Window: View {
    @Binding var document: Document
    var body: some View {
        NavigationView {
            Languages(document: $document)
                .frame(minWidth: 205)
            Editor(document: $document)
        }
        .frame(minWidth: 840, minHeight: 540)
        .sheet(isPresented: $document.data.toggles.intro) {
            Welcome(document: $document)
                .frame(width: 440, height: 440)
        }
    }
}
