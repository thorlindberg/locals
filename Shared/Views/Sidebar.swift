import SwiftUI

struct Sidebar: View {
    
    @Binding var toggle: String
    @Binding var selection: String
    @Binding var status: [String]
    @Binding var progress: CGFloat
    @Binding var data: Storage.Format
    @Binding var query: String
    @Binding var entry: String
    @Binding var inspector: Bool
    
    @State var rename: String = ""
    @State var files: [String] = []
    @State var filename: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                if toggle == "projects" {
                    Image(systemName: "folder.fill").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "folder").onTapGesture { self.toggle = "projects" }
                }
                Spacer()
                if toggle == "languages" {
                    Image(systemName: "textformat.alt").foregroundColor(.accentColor)
                } else {
                    if selection == "" {
                        Image(systemName: "textformat.alt").opacity(0.3)
                    } else {
                        Image(systemName: "textformat.alt").onTapGesture { self.toggle = "languages" }
                    }
                }
                Spacer()
                if toggle == "editing" {
                    Image(systemName: "slider.horizontal.3").foregroundColor(.accentColor)
                } else {
                    if selection == "" {
                        Image(systemName: "slider.horizontal.3").opacity(0.3)
                    } else {
                        Image(systemName: "slider.horizontal.3").onTapGesture { self.toggle = "editing" }
                    }
                }
                Spacer()
                if toggle == "filter" {
                    Image(systemName: "slider.horizontal.below.square.fill.and.square").foregroundColor(.accentColor)
                } else {
                    if selection == "" {
                        Image(systemName: "slider.horizontal.below.square.fill.and.square").opacity(0.3)
                    } else {
                        Image(systemName: "slider.horizontal.below.square.fill.and.square").onTapGesture { self.toggle = "filter" }
                    }
                }
                Spacer()
                if toggle == "help" {
                    Image(systemName: "info.circle.fill").foregroundColor(.accentColor)
                } else {
                    if selection == "" {
                        Image(systemName: "info.circle").opacity(0.3)
                    } else {
                        Image(systemName: "info.circle").onTapGesture { self.toggle = "help" }
                    }
                }
            }
            .frame(height: 27)
            .padding(.horizontal)
            Divider()
            List {
                if toggle == "projects" {
                    Section(header: Text("")) {
                        if selection != "" {
                            Label("\(selection)", systemImage: "doc.fill")
                            HStack {
                                TextField("\(selection).localproj", text: $rename)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button(action: {
                                    withAnimation {
                                        Storage(status: $status, progress: $progress).rename(status: status, selection: selection, rename: rename)
                                        self.selection = self.rename
                                        self.rename = ""
                                    }
                                }) {
                                    Text("Rename")
                                }
                                .disabled(files.contains(rename) || rename == "" || rename.hasPrefix("."))
                                .keyboardShortcut(.defaultAction)
                            }
                            Picker("Base", selection: Binding(
                                get: { data.base },
                                set: { data.base = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                            )) {
                                ForEach(data.translations, id: \.self) { translations in
                                    Text("\(translations.language)").tag(translations.language)
                                }
                            }
                            Button(action: {
                                withAnimation {
                                    Storage(status: $status, progress: $progress).remove(
                                        status: status,
                                        selection: selection
                                    )
                                    self.selection = ""
                                    self.files = Storage(status: $status, progress: $progress).identify(status: status)
                                }
                            }) {
                                Text("Delete")
                            }
                            Divider()
                        }
                        HStack(spacing: 0) {
                            TextField("Unique project name", text: $filename)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                self.selection = filename
                                self.filename = ""
                                Storage(status: $status, progress: $progress).write(
                                    status: status,
                                    selection: selection,
                                    data: Storage(status: $status, progress: $progress).data
                                )
                                self.data = Storage(status: $status, progress: $progress).read(status: status, selection: selection)
                                self.files = Storage(status: $status, progress: $progress).identify(status: status)
                            }) {
                                Text("Create")
                            }
                            .keyboardShortcut(.defaultAction)
                            .disabled(files.contains(filename) || filename == "" || filename.hasPrefix("."))
                            .padding(.leading)
                        }
                        .padding(.bottom)
                        ForEach(files, id: \.self) { file in
                            if file != selection {
                                HStack {
                                    if file == selection {
                                        Label("\(file)", systemImage: "doc.fill")
                                            .foregroundColor(.accentColor)
                                    } else {
                                        Label("\(file)", systemImage: "doc.fill")
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.selection = file
                                    self.data = Storage(status: $status, progress: $progress).read(status: status, selection: file)
                                }
                            }
                        }
                    }
                }
                if toggle == "languages" {
                    Section(header: Text("")) {
                        ForEach(data.translations.indices, id: \.self) { index in
                            if data.translations[index].target {
                                NavigationLink(destination:
                                    Editor(selection: $selection, status: $status, progress: $progress, data: $data,
                                           query: $query, entry: $entry, inspector: $inspector),
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
                if toggle == "editing" {
                    Section(header: Text("")) {
                        HStack {
                            if data.translations.allSatisfy({$0.target}) {
                                Text("Unselect all")
                                    .foregroundColor(.accentColor)
                            } else {
                                Text("Select all")
                            }
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { data.translations.allSatisfy({$0.target}) },
                                set: { _,_ in
                                    if data.translations.allSatisfy({$0.target}) {
                                        data.translations.indices.forEach { index in
                                            data.translations[index].target = false
                                        }
                                    } else {
                                        data.translations.indices.forEach { index in
                                            data.translations[index].target = true
                                        }
                                    }
                                    Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data)
                                }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                        }
                        Divider()
                        ForEach(data.translations.indices, id: \.self) { index in
                            HStack {
                                if data.translations[index].target {
                                    Text("\(data.translations[index].language)")
                                        .foregroundColor(.accentColor)
                                } else {
                                    Text("\(data.translations[index].language)")
                                }
                                Spacer()
                                Toggle(isOn: Binding(
                                    get: { data.translations[index].target },
                                    set: { data.translations[index].target = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                                )) {
                                    Text("")
                                }
                                .toggleStyle(CheckboxToggleStyle())
                            }
                        }
                    }
                }
                if toggle == "filter" {
                    Section(header: Text("")) {
                        TextField("􀊫 Search", text: $query)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minWidth: 160)
                        Button(action: {
                            withAnimation {
                                Progress(status: $status, progress: $progress).load(string: "Translating strings to \(data.target)...")
                                Translation(status: $status, progress: $progress, data: $data).translate()
                                Storage(status: $status, progress: $progress).write(
                                    status: status,
                                    selection: selection,
                                    data: data
                                )
                            }
                        }) {
                            Image(systemName: "globe")
                        }
                        .help("Auto-translate strings")
                        Button(action: {
                            Coder(data: $data, status: $status, progress: $progress).decode() { imported in
                                imported.forEach { string in
                                    data.translations.indices.forEach { index in
                                        if !data.translations[index].texts.keys.contains(string) {
                                            data.translations[index].texts[string] = Storage.Format.Text(translation: "", pinned: false)
                                        }
                                    }
                                }
                                Storage(status: $status, progress: $progress).write(
                                    status: status,
                                    selection: selection,
                                    data: data
                                )
                            }
                        }) {
                            Image(systemName: "folder.fill.badge.plus")
                        }
                        .help("Import strings from an Xcode project folder")
                    }
                }
                if toggle == "help" {
                    Section(header: Text("")) {
                        // INFO ON HOW TO USE THE APP
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
        .onAppear {
            self.files = Storage(status: $status, progress: $progress).identify(status: status)
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
    
}
