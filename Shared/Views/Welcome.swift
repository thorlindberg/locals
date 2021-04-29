import SwiftUI

struct Welcome: View {
    
    @Binding var intro: Bool
    @Binding var document: Document
    @State var tooltip: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Image("Icon")
                    .resizable()
                    .frame(width: 64, height: 64)
                Text("Welcome to Locals")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text("Version 1.0.0 Release")
                    .font(.system(size: 15))
                    .opacity(0.5)
                Spacer()
                HStack {
                    Image("xcodeproj")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 7)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Imports Xcode projects")
                            .fontWeight(.bold)
                        Text("And automatically retrieves strings")
                    }
                    Spacer()
                    Image(systemName: tooltip == "xcodeproj" ? "questionmark.circle.fill" : "questionmark.circle")
                        .opacity(0.5)
                        .padding(.trailing, 10)
                        .onHover { hovering in
                            tooltip = hovering ? "xcodeproj" : ""
                        }
                        .popover(isPresented: Binding(get: { tooltip == "xcodeproj" ? true : false }, set: { tooltip = $0 ? "xcodeproj" : "" })) {
                            Text("Click the 􀈽 button, then select an Xcode project folder, and click \"Open\" to import its strings.")
                                .lineSpacing(5)
                                .font(.system(size: 12))
                                .frame(width: 210)
                                .padding()
                        }
                }
                .frame(height: 40)
                Divider()
                HStack {
                    Image("localproj")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 7)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Auto-saves your work")
                            .fontWeight(.bold)
                        Text("In the application's storage")
                    }
                    Spacer()
                    Image(systemName: tooltip == "localproj" ? "questionmark.circle.fill" : "questionmark.circle")
                        .opacity(0.5)
                        .padding(.trailing, 10)
                        .onHover { hovering in
                            tooltip = hovering ? "localproj" : ""
                        }
                        .popover(isPresented: Binding(get: { tooltip == "localproj" ? true : false }, set: { tooltip = $0 ? "localproj" : "" })) {
                            Text("Your work is automatically saved to the application's storage, whenever you edit anything. Look at the window's top-right corner to see when a project was last saved.")
                                .lineSpacing(5)
                                .font(.system(size: 12))
                                .frame(width: 260)
                                .padding()
                        }
                }
                .frame(height: 40)
                Divider()
                HStack {
                    Image("strings")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 7)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Exports localization files")
                            .fontWeight(.bold)
                        Text("Ready for importing into Xcode")
                    }
                    Spacer()
                    Image(systemName: tooltip == "strings" ? "questionmark.circle.fill" : "questionmark.circle")
                        .opacity(0.5)
                        .padding(.trailing, 10)
                        .onHover { hovering in
                            tooltip = hovering ? "strings" : ""
                        }
                        .popover(isPresented: Binding(get: { tooltip == "strings" ? true : false }, set: { tooltip = $0 ? "strings" : "" })) {
                            Text("Click the 􀈂 button, then select a destination folder, and click \"Export\" to export strings for selected languages. In Xcode you can import these exported strings into your Xcode project, to localize your project.")
                                .lineSpacing(5)
                                .font(.system(size: 12))
                                .frame(width: 270)
                                .padding()
                        }
                }
                .frame(height: 40)
            }
            .padding(50)
            VStack {
                HStack {
                    Button(action: {
                        intro.toggle()
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                Spacer()
            }
            .padding(25)
        }
    }
    
}

/*
import SwiftUI

extension AnyTransition {
    static var moveIn: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension AnyTransition {
    static var moveOut: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct Welcome: View {
    
    @Binding var intro: Bool
    @Binding var document: Document
    @State var section: String = "intro"
    
    var body: some View {
        switch section {
        case "xcode":
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.section = "intro"
                        }
                    }) {
                        Label("Back", systemImage: "chevron.left")
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                Spacer()
                Text("Xcode")
                Spacer()
            }
            .padding(25)
            .transition(.moveIn)
        case "locals":
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.section = "intro"
                        }
                    }) {
                        Label("Back", systemImage: "chevron.left")
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                Spacer()
                Text("Locals")
                Spacer()
            }
            .padding(25)
            .transition(.moveIn)
        case "strings":
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.section = "intro"
                        }
                    }) {
                        Label("Back", systemImage: "chevron.left")
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                Spacer()
                Text("Strings")
                Spacer()
            }
            .padding(25)
            .transition(.moveIn)
        default:
            ZStack {
                VStack {
                    Image("Icon")
                        .resizable()
                        .frame(width: 64, height: 64)
                    Text("Welcome to Locals")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    Text("Version 1.0.0 Release")
                        .font(.system(size: 15))
                        .opacity(0.5)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.section = "xcode"
                        }
                    }) {
                        HStack {
                            Image("xcodeproj")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 7)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Imports Xcode projects")
                                    .fontWeight(.bold)
                                Text("And automatically retrieves strings")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .opacity(0.5)
                                .padding(.trailing, 10)
                        }
                        .frame(height: 40)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                    Button(action: {
                        withAnimation {
                            self.section = "locals"
                        }
                    }) {
                        HStack {
                            Image("localproj")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 7)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Auto-saves your work")
                                    .fontWeight(.bold)
                                Text("In the application's storage")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .opacity(0.5)
                                .padding(.trailing, 10)
                        }
                        .frame(height: 40)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                    Button(action: {
                        withAnimation {
                            self.section = "strings"
                        }
                    }) {
                        HStack {
                            Image("strings")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 7)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Exports localization files")
                                    .fontWeight(.bold)
                                Text("Ready for importing into Xcode")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .opacity(0.5)
                                .padding(.trailing, 10)
                        }
                        .frame(height: 40)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(50)
                VStack {
                    HStack {
                        Button(action: {
                            intro.toggle()
                            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                        }) {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    Spacer()
                }
                .padding(25)
            }
            .transition(.moveOut)
        }
    }
    
}

*/
