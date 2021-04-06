import SwiftUI

struct Window: View {
    @State var inspector: Bool = true
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Content")) {
                    Text("Language")
                }
            }
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
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 0) {
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
                                            Image(systemName: "pin") // onTapGesture: CHANGE TO FILL AND HIGHER OPACITY
                                                .opacity(0.3)
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    if inspector {
                        Divider()
                        ScrollView {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Translate")
                                    Spacer()
                                    Button(action: {
                                        //
                                    }) {
                                        Text("Translate")
                                    }
                                }
                                Divider()
                            }
                            .padding()
                        }
                        .frame(width: 230)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Menu {
                        //
                    } label: {
                        Text("Welcome to Xlocal")
                            .font(.system(size: 10))
                    }
                    .background(Color("StatusColor"))
                    .frame(width: 320)
                    .cornerRadius(5)
                    .help("View project changelog, and revert to a previous version")
                }
                ToolbarItemGroup(placement: .automatic) {
                    TextField("􀊫 Search", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 205)
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
                    Toggle(isOn: $inspector) {
                        Image(systemName: "rectangle.rightthird.inset.fill")
                    }
                }
            }
        }
        .frame(minWidth: 1100, minHeight: 500)
    }
}
