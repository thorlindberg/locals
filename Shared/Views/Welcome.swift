import SwiftUI

struct Welcome: View {
    
    @Binding var document: Document
    
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
                    Image(systemName: document.data.tooltip == "xcodeproj" ? "questionmark.circle.fill" : "questionmark.circle")
                        .opacity(0.5)
                        .padding(.trailing, 10)
                        .onHover { hovering in
                            document.data.tooltip = hovering ? "xcodeproj" : ""
                        }
                        .popover(isPresented: Binding(get: { document.data.tooltip == "xcodeproj" ? true : false }, set: { document.data.tooltip = $0 ? "xcodeproj" : "" })) {
                            Text("Click the 􀈽 button and select an Xcode project folder, or drag the folder into the editor, to import its strings.")
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
                        Text("Avoid lost work due to crashes")
                    }
                    Spacer()
                    Image(systemName: document.data.tooltip == "localproj" ? "questionmark.circle.fill" : "questionmark.circle")
                        .opacity(0.5)
                        .padding(.trailing, 10)
                        .onHover { hovering in
                            document.data.tooltip = hovering ? "localproj" : ""
                        }
                        .popover(isPresented: Binding(get: { document.data.tooltip == "localproj" ? true : false }, set: { document.data.tooltip = $0 ? "localproj" : "" })) {
                            Text("Your work is automatically saved by the application. If the application or your Mac crashes, your work is recovered.")
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
                    Image(systemName: document.data.tooltip == "strings" ? "questionmark.circle.fill" : "questionmark.circle")
                        .opacity(0.5)
                        .padding(.trailing, 10)
                        .onHover { hovering in
                            document.data.tooltip = hovering ? "strings" : ""
                        }
                        .popover(isPresented: Binding(get: { document.data.tooltip == "strings" ? true : false }, set: { document.data.tooltip = $0 ? "strings" : "" })) {
                            Text("Click the 􀈂 button and select a folder to export strings for selected languages. Xcode can import exported strings, to localize your project.")
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
                        document.data.toggles.intro.toggle()
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
