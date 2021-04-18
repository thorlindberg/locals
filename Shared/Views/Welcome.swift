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
    @Binding var data: Storage.Format
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
            .padding(35)
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
            .padding(35)
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
            .padding(35)
            .transition(.moveIn)
        default:
            VStack {
                Image("Icon")
                    .resizable()
                    .frame(width: 64, height: 64)
                Text("Welcome to Locals")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
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
                Spacer()
                Button(action: {
                    intro.toggle()
                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                }) {
                    Text("Let's start localizing!")
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(data.styles.color)
            }
            .padding(.vertical, 35)
            .padding(.horizontal, 55)
            .transition(.moveOut)
        }
    }
    
}
