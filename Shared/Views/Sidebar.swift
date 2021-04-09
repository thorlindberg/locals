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
                if toggle == "help" {
                    Image(systemName: "info.circle.fill").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "info.circle").onTapGesture { self.toggle = "help" }
                }
                Spacer()
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
            }
            .frame(height: 27)
            .padding(.horizontal)
            Divider()
            if toggle == "help" {
                List {
                    Section(header: Text("")) {
                        // INFO ON HOW TO USE THE APP
                    }
                }
                .listStyle(SidebarListStyle())
            }
            if toggle == "projects" {
                HStack {
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
                        Image(systemName: "plus")
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(files.contains(filename) || filename == "" || filename.hasPrefix("."))
                }
                .padding()
                Divider()
                List {
                    Section(header: Text("")) {
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
                .listStyle(SidebarListStyle())
                .onAppear {
                    self.files = Storage(status: $status, progress: $progress).identify(status: status)
                }
            }
            if toggle == "languages" {
                HStack {
                    Text("Edit languages")
                    Spacer()
                    Toggle(isOn: $editing) {
                        Text("")
                    }
                }
                .padding()
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
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                Divider()
                List {
                    Section(header: Text("")) {
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
                .listStyle(SidebarListStyle())
                .onAppear {
                    if data.target == "" && data.translations.filter({$0.target}).count != 0 {
                        self.data.target = data.translations.filter({$0.target})[0].language
                    }
                }
            }
            if toggle == "add" {
                HStack {
                    TextField("Unique string", text: $entry)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(selection == "" || data.target == "")
                        .help("Add a unique string for translation")
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
                .padding()
                Divider()
                List {
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
                        // DRAG-AND-DROP PROJECT IMPORT
                    }
                }
                .listStyle(SidebarListStyle())
            }
            if toggle == "filter" {
                TextField("􀊫 Search strings", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Divider()
                List {
                    Section(header: Text("")) {
                        HStack {
                            Text("Single-line strings")
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { data.filters.singleline },
                                set: { data.filters.singleline = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                        }
                        HStack {
                            Text("Multi-line strings")
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { data.filters.multiline },
                                set: { data.filters.multiline = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                        }
                        HStack {
                            Text("Parenthesis")
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { data.filters.parenthesis },
                                set: { data.filters.parenthesis = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                        }
                        HStack {
                            Text("Nummerical-only")
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { data.filters.nummerical },
                                set: { data.filters.nummerical = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                        }
                        HStack {
                            Text("Symbols-only")
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { data.filters.symbols },
                                set: { data.filters.symbols = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                        }
                        Divider()
                            .padding(.vertical)
                        Picker("Base", selection: Binding(
                            get: { data.styles.font },
                            set: { data.styles.font = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("Default").tag("Default")
                            Text("Helvetica Neue").tag("Helvetica Neue")
                            Text("Helvetica").tag("Helvetica")
                        }
                        Picker("Size", selection: Binding(
                            get: { data.styles.size },
                            set: { data.styles.size = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("12").tag(12)
                            Text("14").tag(14)
                            Text("16").tag(16)
                        }
                        Picker("Weight", selection: Binding(
                            get: { data.styles.weight },
                            set: { data.styles.weight = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("Normal").tag("Normal")
                            Text("Bold").tag("Bold")
                            Text("Light").tag("Light")
                        }
                        Picker("Color", selection: Binding(
                            get: { data.styles.color },
                            set: { data.styles.color = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("Accent").tag("Accent")
                            Text("Red").tag("Red")
                            Text("Blue").tag("Blue")
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "rectangle.leftthird.inset.fill")
                }
            }
        }
    }
    
}
