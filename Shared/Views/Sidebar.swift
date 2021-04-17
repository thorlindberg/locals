import SwiftUI

struct Sidebar: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    @State var rename: String = ""
    @State var renaming: Bool = false
    @State var files: [String] = []
    @State var filename: String = ""
    
    var body: some View {
        List {
            HStack {
                TextField("Add project", text: $filename)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if !files.contains(filename) && filename != "" && !filename.hasPrefix(".") {
                    Button(action: {
                        self.data = Storage(data: $data).database
                        Storage(data: $data).write(selection: filename)
                        self.filename = ""
                        self.files = Storage(data: $data).identify()
                    }) {
                        Image(systemName: "plus")
                            .accentColor(data.styles.color)
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding(.bottom)
            ForEach(files, id: \.self) { file in
                NavigationLink(destination: Languages(selection: $selection, data: $data), tag: file, selection: Binding(
                    get: { selection },
                    set: { if $0 != nil { self.selection = $0! } ; self.data = Storage(data: $data).read(selection: file) }
                )
                ) {
                    Label(file, systemImage: "doc.fill")
                        .accentColor(data.styles.color)
                }
                .frame(height: 20)
                .contextMenu {
                    Button(action: {
                        self.renaming.toggle()
                    }) {
                        Text("Rename")
                    }
                    Button(action: {
                        withAnimation {
                            Storage(data: $data).remove(selection: file)
                            if file == selection {
                                self.selection = ""
                            }
                            self.files = Storage(data: $data).identify()
                        }
                    }) {
                        Text("Delete")
                    }
                }
                .sheet(isPresented: $renaming) {
                    VStack {
                        TextField("\(file).localproj", text: $rename)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack {
                            Button(action: {
                                self.renaming.toggle()
                            }) {
                                Text("Cancel")
                            }
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    Storage(data: $data).rename(selection: file, rename: rename)
                                    self.selection = self.rename
                                    self.rename = ""
                                    self.files = Storage(data: $data).identify()
                                    self.renaming.toggle()
                                }
                            }) {
                                Text("Rename")
                            }
                            .accentColor(data.styles.color)
                            .disabled(files.contains(rename) || rename == "" || rename.hasPrefix("."))
                            .keyboardShortcut(.defaultAction)
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minWidth: 150)
        .onAppear {
            self.files = Storage(data: $data).identify()
            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") && !files.contains("Example") {
                self.data = Storage(data: $data).data
                Storage(data: $data).write(selection: "Example")
                self.filename = ""
                self.files = Storage(data: $data).identify()
            }
            if files != [] {
                self.selection = files[0]
                self.data = Storage(data: $data).read(selection: selection)
            }
        }
    }
    
}
