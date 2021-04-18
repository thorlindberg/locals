import SwiftUI

struct Window: View {
    
    @State var selection: String = ""
    @State var data: Storage.Format = Storage.Format(
        base: "English (United Kingdom)",
        target: "Japanese",
        alerts: true,
        saved: "",
        status: ["\(Time().current()) - Welcome to Locals"],
        progress: CGFloat.zero,
        fields: Storage.Format.Fields(query: "", entry: "", rename: "", language: ""),
        filters: Storage.Format.Filters(unpinned: true, singleline: true, multiline: true, parenthesis: true, nummerical: true, symbols: true),
        styles: Storage.Format.Styles(columns: 3, font: "San Francisco", size: CGFloat(14), weight: Font.Weight.regular, color: Color.orange, vibrancy: 1),
        extensions: ["swift" : true], translations: []
    )
    @State var intro = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    var body: some View {
        NavigationView {
            Sidebar(intro: $intro, selection: $selection, data: $data)
            Languages(selection: $selection, data: $data)
            Editor(selection: $selection, data: $data)
        }
        .frame(minWidth: 920, minHeight: 500)
        .sheet(isPresented: $intro) {
            Welcome(intro: $intro, data: $data)
                .frame(width: 440, height: 440)
        }
    }
    
}
