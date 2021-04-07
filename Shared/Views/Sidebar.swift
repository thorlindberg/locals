import SwiftUI

struct Sidebar: View {
    
    @Binding var projects: Bool
    @Binding var selection: String
    @Binding var status: [String]
    @Binding var progress: CGFloat
    @Binding var data: Storage.Format
    @Binding var query: String
    @Binding var entry: String
    @Binding var inspector: Bool
    
    var body: some View {
        List {
            ForEach(data.translations.indices, id: \.self) { index in
                if data.base != data.translations[index].language {
                    if data.translations[index].target {
                        NavigationLink(destination:
                            Editor(selection: $selection, status: $status, progress: $progress, data: $data, query: $query, entry: $entry, inspector: $inspector),
                            tag: data.translations[index].language,
                            selection: Binding(
                                get: { data.target },
                                set: { if $0 != nil { data.target = $0! } }
                            )
                        ) {
                            Text("\(data.translations[index].language)")
                        }
                        .frame(height: 20)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "rectangle.leftthird.inset.fill")
                }
                Button(action: {
                    self.projects.toggle()
                }) {
                    Text("Projects")
                }
            }
        }
    }
    
}
