import SwiftUI

struct Window: View {
    
    @State var toggle: String = "files"
    @State var projects: Bool = true
    @State var selection: String = ""
    @State var status: [String] = ["\(Time().current()) - Welcome to Locals"]
    @State var progress: CGFloat = CGFloat.zero
    @State var data: Storage.Format = Storage.Format(base: "", target: "", translations: [])
    @State var query: String = ""
    @State var entry: String = ""
    @State var inspector: Bool = true
    
    var body: some View {
        NavigationView {
            Sidebar(toggle: $toggle, projects: $projects, selection: $selection, status: $status, progress: $progress, data: $data,
                    query: $query, entry: $entry, inspector: $inspector)
                .frame(minWidth: 220)
            Editor(selection: $selection, status: $status, progress: $progress, data: $data, query: $query, entry: $entry, inspector: $inspector)
        }
        .frame(minWidth: 980, minHeight: 500)
        .sheet(isPresented: $projects) {
            Projects(toggle: $toggle, projects: $projects, selection: $selection, status: $status, progress: $progress,
                     data: $data, query: $query, entry: $entry, inspector: $inspector)
                .frame(width: 600, height: 400)
        }
    }
    
}
