import SwiftUI

@main
struct LocalsApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Document()) { file in
            Window(document: file.$document)
        }
        .commands {
            SidebarCommands()
        }
    }
}
