import SwiftUI

struct Sidebar: View {
    var body: some View {
        List {
            NavigationLink(destination: Editor()) {
                Text("Language")
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 230)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "rectangle.leftthird.inset.fill")
                }
            }
        }
    }
}
