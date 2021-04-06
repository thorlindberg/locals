import SwiftUI

struct Window: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Content")) {
                    Text("Language")
                }
            }
            .frame(minWidth: 230)
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button(action: {
                        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                    }) {
                        Image(systemName: "rectangle.leftthird.inset.fill")
                    }
                    Button(action: {
                        //
                    }) {
                        Text("Edit")
                    }
                }
            }
            List {
                VStack(spacing: 15) {
                    ForEach(0 ..< 100) { _ in
                        ZStack {
                            Rectangle()
                                .opacity(0.05)
                                .cornerRadius(10)
                                .frame(minHeight: 50)
                            HStack(spacing: 15) {
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                                    .foregroundColor(.accentColor)
                                Divider()
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                                Spacer()
                                VStack {
                                    Image(systemName: "pin.fill")
                                        .opacity(0.3)
                                    Spacer()
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Menu("Menu") {
                    }
                    .frame(width: 200)
                }
                ToolbarItem(placement: .automatic) {
                    TextField("􀊫 Search", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 205)
                }
            }
            List {
                VStack(spacing: 15) {
                    HStack {
                        Text("Inspector")
                        Spacer()
                        Button(action: {
                            //
                        }) {
                            Text("Inspector")
                        }
                    }
                    Divider()
                }
            }
            .frame(minWidth: 230)
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Spacer()
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "folder.fill.badge.plus")
                    }
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .frame(minWidth: 1100, minHeight: 500)
    }
}
