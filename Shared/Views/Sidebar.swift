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
    
    let fonts: [String] = [
        "American Typewriter", "Andale Mono", "Arial", "Avenir", "Baskerville", "Big Caslon", "Bodoni 72",
        "Bradley Hand", "Calibri", "Cambria", "Chalkboard", "Chalkduster", "Charter", "Cochin", "Copperplate",
        "Courier", "Didot", "Futura", "Geneva", "Georgia", "Gill Sans", "Helvetica", "Helvetica Neue", "Impact",
        "Lucida Grande", "Luminari", "Marker Felt", "Menlo", "Monaco", "Noteworthy", "Optima", "Palatino", "Papyrus",
        "Phosphate", "Rockwell", "San Francisco", "Skia", "Tahoma", "Times", "Times New Roman", "Verdana"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                if toggle == "help" {
                    Image(systemName: "info.circle.fill").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "info.circle").contentShape(Rectangle()).onTapGesture { self.toggle = "help" }
                }
                Spacer()
                if toggle == "projects" {
                    Image(systemName: "folder.fill").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "folder").contentShape(Rectangle()).onTapGesture { self.toggle = "projects" }
                }
                Spacer()
                if toggle == "languages" {
                    Image(systemName: "textformat").foregroundColor(.accentColor)
                } else if selection == "" {
                    Image(systemName: "textformat").opacity(0.3)
                } else {
                    Image(systemName: "textformat").contentShape(Rectangle()).onTapGesture { self.toggle = "languages" }
                }
                Spacer()
                if toggle == "edit" {
                    Image(systemName: "globe").foregroundColor(.accentColor)
                } else if selection == "" {
                    Image(systemName: "globe").opacity(0.3)
                } else {
                    Image(systemName: "globe").contentShape(Rectangle()).onTapGesture { self.toggle = "edit" }
                }
                Spacer()
                if toggle == "add" {
                    Image(systemName: "plus").foregroundColor(.accentColor)
                } else if selection == "" || data.target == "" {
                    Image(systemName: "plus").opacity(0.3)
                } else {
                    Image(systemName: "plus").contentShape(Rectangle()).onTapGesture { self.toggle = "add" }
                }
                Spacer()
                if toggle == "filter" {
                    Image(systemName: "magnifyingglass").foregroundColor(.accentColor)
                } else if selection == "" || data.target == "" {
                    Image(systemName: "magnifyingglass").opacity(0.3)
                } else {
                    Image(systemName: "magnifyingglass").contentShape(Rectangle()).onTapGesture { self.toggle = "filter" }
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
                List {
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
                .listStyle(SidebarListStyle())
                .onAppear {
                    if data.target == "" && data.translations.filter({$0.target}).count != 0 {
                        data.target = data.translations.filter({$0.target})[0].language
                    }
                }
            }
            if toggle == "edit" {
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
                .padding()
                Divider()
                List {
                    Section(header: Text("")) {
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
                                .disabled(data.translations[index].target && data.translations.filter({$0.target}).count == 1)
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
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
                VStack {
                    HStack {
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
                    }
                    ZStack {
                        Rectangle()
                            .frame(height: 150)
                            .cornerRadius(10)
                            .opacity(0.1)
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
                    }
                    .help("Import strings from an Xcode project folder")
                }
                .padding()
                // DRAG AND DROP IMPORT
                Spacer()
            }
            if toggle == "filter" {
                TextField("􀊫 Search strings", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Divider()
                VStack {
                    HStack {
                        Text("Single-line")
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
                        Text("Multi-line")
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
                        Text("Nummerical")
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
                        Text("Symbols")
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { data.filters.symbols },
                            set: { data.filters.symbols = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("")
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                }
                .padding()
                Divider()
                VStack {
                    HStack {
                        HStack {
                            Text("Font")
                            Spacer()
                        }
                        .frame(width: 55)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { data.styles.font },
                            set: { data.styles.font = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            ForEach(fonts, id: \.self) { font in
                                Text(font)
                                    .font(.custom(font, size: 14))
                                    .tag(font)
                            }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Size")
                            Spacer()
                        }
                        .frame(width: 55)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { data.styles.size },
                            set: { data.styles.size = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            ForEach(Array(stride(from: 6, to: 102, by: 2)), id: \.self) { size in
                                Text(String(size)).tag(CGFloat(size))
                            }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Weight")
                            Spacer()
                        }
                        .frame(width: 55)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { data.styles.weight },
                            set: { data.styles.weight = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("Regular").tag(Font.Weight.regular)
                            Text("Heavy").tag(Font.Weight.heavy)
                            Text("Black").tag(Font.Weight.black)
                            Text("Bold").tag(Font.Weight.bold)
                            Text("Semi-bold").tag(Font.Weight.semibold)
                            Text("Medium").tag(Font.Weight.medium)
                            Text("Thin").tag(Font.Weight.thin)
                            Text("Light").tag(Font.Weight.light)
                            Text("Ultra light").tag(Font.Weight.ultraLight)
                        }
                    }
                    HStack {
                        HStack {
                            Text("Color")
                            Spacer()
                        }
                        .frame(width: 55)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { data.styles.color },
                            set: { data.styles.color = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
                        )) {
                            Text("Accent").foregroundColor(.accentColor).tag(Color.accentColor)
                            Text("Blue").foregroundColor(.blue).tag(Color.blue)
                            Text("Gray").foregroundColor(.gray).tag(Color.gray)
                            Text("Green").foregroundColor(.green).tag(Color.green)
                            Text("Orange").foregroundColor(.orange).tag(Color.orange)
                            Text("Pink").foregroundColor(.pink).tag(Color.pink)
                            Text("Purple").foregroundColor(.purple).tag(Color.purple)
                            Text("Red").foregroundColor(.red).tag(Color.red)
                            Text("Yellow").foregroundColor(.yellow).tag(Color.yellow)
                        }
                    }
                }
                .padding()
                Spacer()
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
