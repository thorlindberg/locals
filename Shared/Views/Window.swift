import SwiftUI

struct Window: View {
    
    @State var toggle: String = "projects"
    @State var selection: String = ""
    @State var data: Storage.Format = Storage.Format(
        base: "English (United Kingdom)",
        target: "",
        alerts: true,
        saved: "",
        status: ["\(Time().current()) - Welcome to Locals"],
        progress: CGFloat.zero,
        fields: Storage.Format.Fields(query: "", entry: "", rename: "", language: ""),
        filters: Storage.Format.Filters(unpinned: true, singleline: true, multiline: true, parenthesis: true, nummerical: true, symbols: true),
        styles: Storage.Format.Styles(columns: 3, font: "San Francisco", size: CGFloat(14), weight: Font.Weight.regular, color: Color.accentColor, vibrancy: 1),
        extensions: ["swift" : true], translations: []
    )
    
    var body: some View {
        NavigationView {
            Sidebar(toggle: $toggle, selection: $selection, data: $data)
                .frame(minWidth: 200)
            Editor(selection: $selection, data: $data)
        }
        .frame(minWidth: 900, minHeight: 500)
    }
    
}
