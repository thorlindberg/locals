import SwiftUI

struct Sidebar: View {
    @Binding var projects: Bool
    var body: some View {
        List {
            NavigationLink(destination: Editor()) {
                Text("Language")
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
