import SwiftUI

struct Window: View {
    
    @State var toggle: String = "projects"
    @State var selection: String = ""
    @State var status: [String] = ["\(Time().current()) - Welcome to Locals"]
    @State var progress: CGFloat = CGFloat.zero
    @State var data: Storage.Format = Storage.Format(
        base: "", target: "", filters: Storage.Format.Filters(unpinned: true, singleline: true, multiline: true, parenthesis: true, nummerical: true, symbols: true),
        styles: Storage.Format.Styles(font: "San Francisco", size: CGFloat(14), weight: Font.Weight.regular, color: Color.accentColor), translations: []
    )
    @State var query: String = ""
    @State var entry: String = ""
    @State var inspector: Bool = true
    
    var body: some View {
        NavigationView {
            Sidebar(toggle: $toggle, selection: $selection, status: $status, progress: $progress, data: $data,
                    query: $query, entry: $entry, inspector: $inspector)
                .frame(minWidth: 220)
            Editor(selection: $selection, status: $status, progress: $progress, data: $data, query: $query, entry: $entry, inspector: $inspector)
        }
        .frame(minWidth: 860, minHeight: 480)
    }
    
}
