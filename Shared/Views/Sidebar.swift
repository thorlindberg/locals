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
    @State var renaming: Bool = false
    @State var editing: Bool = false
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
                    Image(systemName: "globe").foregroundColor(.accentColor)
                } else {
                    if selection == "" {
                        Image(systemName: "globe").opacity(0.3)
                    } else {
                        Image(systemName: "globe").onTapGesture { self.toggle = "languages" }
                    }
                }
                Spacer()
                if toggle == "add" {
                    Image(systemName: "plus").foregroundColor(.accentColor)
                } else {
                    if selection == "" || data.target == "" {
                        Image(systemName: "plus").opacity(0.3)
                    } else {
                        Image(systemName: "plus").onTapGesture { self.toggle = "add" }
                    }
                }
                Spacer()
                if toggle == "filter" {
                    Image(systemName: "magnifyingglass").foregroundColor(.accentColor)
                } else {
                    if selection == "" || data.target == "" {
                        Image(systemName: "magnifyingglass").opacity(0.3)
                    } else {
                        Image(systemName: "magnifyingglass").onTapGesture { self.toggle = "filter" }
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
                                self.toggle = "languages"
                            }) {
                                Text("Create")
                            }
                            .keyboardShortcut(.defaultAction)
                            .disabled(files.contains(filename) || filename == "" || filename.hasPrefix("."))
                            .padding(.leading)
                        }
                        .padding(.bottom)
                        ForEach(files, id: \.self) { file in
                            NavigationLink(destination:
                                Editor(selection: $selection, status: $status, progress: $progress, data: $data,
                                       query: $query, entry: $entry, inspector: $inspector),
                                tag: file,
                                selection: Binding(
                                    get: { selection },
                                    set: { if $0 != nil { self.selection = $0! } ; self.toggle = "languages" ; self.data = Storage(status: $status, progress: $progress).read(status: status, selection: file) }
                                )
                            ) {
                                HStack {
                                    Image("File")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text(file)
                                    Spacer()
                                }
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
                                        Storage(status: $status, progress: $progress).remove(
                                            status: status,
                                            selection: file
                                        )
                                        if file == selection {
                                            self.selection = ""
                                        }
                                        self.files = Storage(status: $status, progress: $progress).identify(status: status)
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
                                                Storage(status: $status, progress: $progress).rename(status: status, selection: file, rename: rename)
                                                self.selection = self.rename
                                                self.rename = ""
                                                self.files = Storage(status: $status, progress: $progress).identify(status: status)
                                                self.renaming.toggle()
                                            }
                                        }) {
                                            Text("Rename")
                                        }
                                        .disabled(files.contains(rename) || rename == "" || rename.hasPrefix("."))
                                        .keyboardShortcut(.defaultAction)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                if toggle == "languages" {
                    Section(header: Text("")) {
                        HStack {
                            Text("Edit languages")
                            Spacer()
                            Toggle(isOn: $editing) {
                                Text("")
                            }
                        }
                        if editing {
                            HStack {
                                if data.translations.allSatisfy({$0.target}) {
                                    Text("Select all")
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
                                                if index != 0 {
                                                    data.translations[index].target = false
                                                }
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
                        }
                        Divider()
                            .padding(.vertical)
                        ForEach(data.translations.indices, id: \.self) { index in
                            if editing {
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
                                    .disabled(data.translations[index].target && data.translations.filter({$0.target}).count == 1)
                                }
                            } else {
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
                }
                if toggle == "add" {
                    Section(header: Text("")) {
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
                        ZStack {
                            TextField("Unique string", text: $entry)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 180)
                                .disabled(selection == "" || data.target == "")
                                .help("Add a unique string for translation")
                            if entry != "" {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            data.translations.indices.forEach { index in
                                                data.translations[index].texts[entry] = Storage.Format.Text(translation: "", pinned: false)
                                            }
                                            Storage(status: $status, progress: $progress).write(
                                                status: status,
                                                selection: selection,
                                                data: data
                                            )
                                            self.entry = ""
                                        }
                                    }) {
                                        Image(systemName: "arrow.right.circle.fill")
                                    }
                                    .keyboardShortcut(.defaultAction)
                                    .disabled(entry == "" || data.translations.filter({$0.language == data.target})[0].texts.keys.contains(entry))
                                }
                            }
                        }
                    }
                }
                if toggle == "filter" {
                    Section(header: Text("")) {
                        TextField("􀊫 Search strings", text: $query)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minWidth: 160)
                        Divider()
                            .padding(.vertical)
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
