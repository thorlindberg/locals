import SwiftUI

struct Help: View {
    var body: some View {
        List {
            Section(header: Text("")) {
                // INFO ON HOW TO USE THE APP
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct Projects: View {
    
    @Binding var toggle: String
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    @State var rename: String = ""
    @State var renaming: Bool = false
    @State var files: [String] = []
    @State var filename: String = ""
    
    var body: some View {
        HStack {
            TextField("Unique project name", text: $filename)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if !files.contains(filename) && filename != "" && !filename.hasPrefix(".") {
                Button(action: {
                    Storage(data: $data).write(selection: filename)
                    self.filename = ""
                    self.files = Storage(data: $data).identify()
                }) {
                    Image(systemName: "plus")
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        Divider()
        List {
            Section(header: Text("")) {
                ForEach(files, id: \.self) { file in
                    NavigationLink(destination: Editor(selection: $selection, data: $data), tag: file, selection: Binding(
                        get: { selection },
                        set: { if $0 != nil { self.selection = $0! } ; self.toggle = "languages" ; self.data = Storage(data: $data).read(selection: file) }
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
            self.files = Storage(data: $data).identify()
        }
    }
    
}

struct Languages: View {
    
    @Binding var toggle: String
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    @State var editing: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                TextField("􀊫 Languages", text: $data.fields.language)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                Button(action: {
                    withAnimation {
                        self.editing.toggle()
                    }
                }) {
                    if editing {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .foregroundColor(.accentColor)
                    } else {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
            }
            if editing {
                HStack {
                    HStack {
                        Text("Base")
                        Spacer()
                    }
                    .frame(width: 55)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.base },
                        set: { data.base = $0 ; Storage(data: $data).write(selection: selection) }
                    )) {
                        ForEach(data.translations, id: \.self) { translations in
                            Text("\(translations.language)").tag(translations.language)
                        }
                    }
                }
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
                            Storage(data: $data).write(selection: selection)
                        }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
            }
        }
        .padding()
        Divider()
        List {
            Section(header: Text("")) {
                ForEach(data.translations.indices, id: \.self) { index in
                    if data.translations[index].language.lowercased().hasPrefix(data.fields.language.lowercased()) {
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
                                    set: { data.translations[index].target = $0 ; Storage(data: $data).write(selection: selection) }
                                )) {
                                    Text("")
                                }
                                .toggleStyle(CheckboxToggleStyle())
                                .disabled(data.translations[index].target && data.translations.filter({$0.target}).count == 1)
                            }
                        } else {
                            if data.translations[index].target {
                                NavigationLink(destination:
                                                Editor(selection: $selection, data: $data),
                                               tag: data.translations[index].language,
                                               selection: Binding(
                                                get: { data.target },
                                                set: { if $0 != nil { data.target = $0! } }
                                               )
                                ) {
                                    Text("\(data.translations[index].language)")
                                }
                                .frame(height: 20)
                                .contextMenu {
                                    Button(action: {
                                        data.translations[index].target = false
                                        Storage(data: $data).write(selection: selection)
                                    }) {
                                        Text("Disable target")
                                    }
                                }
                            }
                        }
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
    
}

struct Find: View {
    
    @Binding var toggle: String
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    var body: some View {
        TextField("􀊫 Strings", text: $data.fields.query)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        Divider()
        ScrollView {
            VStack {
                HStack {
                    Text("Single-line")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { data.filters.singleline },
                        set: { data.filters.singleline = $0 ; Storage(data: $data).write(selection: selection) }
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
                        set: { data.filters.multiline = $0 ; Storage(data: $data).write(selection: selection) }
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
                        set: { data.filters.parenthesis = $0 ; Storage(data: $data).write(selection: selection) }
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
                        set: { data.filters.nummerical = $0 ; Storage(data: $data).write(selection: selection) }
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
                        set: { data.filters.symbols = $0 ; Storage(data: $data).write(selection: selection) }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                HStack {
                    Text("Unpinned")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { data.filters.unpinned },
                        set: { data.filters.unpinned = $0 ; Storage(data: $data).write(selection: selection) }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
            }
            .padding()
            Spacer()
        }
    }
    
}

struct Settings: View {
    
    @Binding var toggle: String
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    let fonts: [String] = [
        "American Typewriter", "Andale Mono", "Arial", "Avenir", "Baskerville", "Big Caslon", "Bodoni 72",
        "Bradley Hand", "Calibri", "Cambria", "Chalkboard", "Chalkduster", "Charter", "Cochin", "Copperplate",
        "Courier", "Didot", "Futura", "Geneva", "Georgia", "Gill Sans", "Helvetica", "Helvetica Neue", "Impact",
        "Lucida Grande", "Luminari", "Marker Felt", "Menlo", "Monaco", "Noteworthy", "Optima", "Palatino", "Papyrus",
        "Phosphate", "Rockwell", "San Francisco", "Skia", "Tahoma", "Times", "Times New Roman", "Verdana"
    ]
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Alerts")
                Spacer()
                Toggle(isOn: Binding(
                    get: { data.alerts },
                    set: { data.alerts = $0 ; Storage(data: $data).write(selection: selection) }
                )) {
                    Text("")
                }
                .toggleStyle(CheckboxToggleStyle())
            }
            .padding()
            Divider()
            VStack {
                ForEach(Array(data.extensions.keys), id: \.self) { format in
                    HStack {
                        Text(format.capitalized)
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { data.extensions[format]! },
                            set: { data.extensions[format] = $0 ; Storage(data: $data).write(selection: selection) }
                        )) {
                            Text("")
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                }
            }
            .padding()
            Divider()
            VStack {
                HStack {
                    HStack {
                        Text("Columns")
                        Spacer()
                    }
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.styles.columns },
                        set: { data.styles.columns = $0 ; Storage(data: $data).write(selection: selection) }
                    )) {
                        ForEach(Array(stride(from: 1, to: 6, by: 2)), id: \.self) { count in
                            Text(String(count)).tag(count)
                        }
                    }
                }
                HStack {
                    HStack {
                        Text("Font")
                        Spacer()
                    }
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.styles.font },
                        set: { data.styles.font = $0 ; Storage(data: $data).write(selection: selection) }
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
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.styles.size },
                        set: { data.styles.size = $0 ; Storage(data: $data).write(selection: selection) }
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
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.styles.weight },
                        set: { data.styles.weight = $0 ; Storage(data: $data).write(selection: selection) }
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
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.styles.color },
                        set: { data.styles.color = $0 ; Storage(data: $data).write(selection: selection) }
                    )) {
                        Text("Accent").foregroundColor(.black).tag(Color.accentColor)
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
                HStack {
                    HStack {
                        Text("Vibrancy")
                        Spacer()
                    }
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { data.styles.vibrancy },
                        set: { data.styles.vibrancy = $0 ; Storage(data: $data).write(selection: selection) }
                    )) {
                        Text("Reduced").tag(0)
                        Text("Default").tag(1)
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        data.styles.columns = 3
                        data.styles.font = "Helvetica Neue"
                        data.styles.size = CGFloat(14)
                        data.styles.weight = Font.Weight.regular
                        data.styles.color = Color.accentColor
                        data.styles.vibrancy = 1
                        Storage(data: $data).write(selection: selection)
                    }) {
                        Text("Reset styles")
                    }
                    .disabled(data.styles == Storage(data: $data).database.styles)
                }
            }
            .padding()
        }
        Spacer()
    }
    
}

struct Sidebar: View {
    
    @Binding var toggle: String
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                if toggle == "help" {
                    Image(systemName: "info.circle.fill").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "info.circle")
                        .onTapGesture { self.toggle = "help" ; data.fields.query = "" }
                }
                Spacer()
                if toggle == "projects" {
                    Image(systemName: "folder.fill").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "folder")
                        .onTapGesture { self.toggle = "projects" ; data.fields.query = "" }
                }
                Spacer()
                if selection == "" {
                    Image(systemName: "textformat").opacity(0.25)
                } else if toggle == "languages" {
                    Image(systemName: "textformat").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "textformat")
                        .onTapGesture { self.toggle = "languages" ; data.fields.query = "" }
                }
                Spacer()
                if selection == "" {
                    Image(systemName: "magnifyingglass").opacity(0.25)
                } else if toggle == "find" {
                    Image(systemName: "magnifyingglass").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "magnifyingglass")
                        .onTapGesture { self.toggle = "find" }
                }
                Spacer()
                if selection == "" {
                    Image(systemName: "slider.horizontal.3").opacity(0.25)
                } else if toggle == "settings" {
                    Image(systemName: "slider.horizontal.3").foregroundColor(.accentColor)
                } else {
                    Image(systemName: "slider.horizontal.3")
                        .onTapGesture { self.toggle = "settings" }
                }
            }
            .frame(width: 172, height: 26)
            .padding(.horizontal)
            Divider()
            if toggle == "help" {
                Help()
            }
            if toggle == "projects" {
                Projects(toggle: $toggle, selection: $selection, data: $data)
            }
            if toggle == "languages" {
                Languages(toggle: $toggle, selection: $selection, data: $data)
            }
            if toggle == "find" {
                Find(toggle: $toggle, selection: $selection, data: $data)
            }
            if toggle == "settings" {
                Settings(toggle: $toggle, selection: $selection, data: $data)
            }
        }
        .accentColor(data.styles.color)
    }
    
}
