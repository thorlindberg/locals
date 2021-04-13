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
    @State var language: String = ""
    @State var editing: Bool = false
    @State var files: [String] = []
    @State var filename: String = ""
    
    @State var menu: String = ""
    
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
                    ZStack {
                        if menu == "help" {
                            Image(systemName: "info.circle").foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "info.circle")
                        }
                    }
                    .onTapGesture { self.toggle = "help" ; self.query = "" }
                    .onHover { hovering in
                        self.menu = hovering ? "help" : ""
                    }
                }
                Spacer()
                if toggle == "projects" {
                    Image(systemName: "folder.fill").foregroundColor(.accentColor)
                } else {
                    ZStack {
                        if menu == "projects" {
                            Image(systemName: "folder").foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "folder")
                        }
                    }
                    .onTapGesture { self.toggle = "projects" ; self.query = "" }
                    .onHover { hovering in
                        self.menu = hovering ? "projects" : ""
                    }
                }
                Spacer()
                if selection == "" {
                    Image(systemName: "textformat").opacity(0.25)
                } else if toggle == "languages" {
                    Image(systemName: "textformat").foregroundColor(.accentColor)
                } else {
                    ZStack {
                        if menu == "languages" {
                            Image(systemName: "textformat").foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "textformat")
                        }
                    }
                    .onTapGesture { self.toggle = "languages" ; self.query = "" }
                    .onHover { hovering in
                        self.menu = hovering ? "languages" : ""
                    }
                }
                Spacer()
                if selection == "" {
                    Image(systemName: "magnifyingglass").opacity(0.25)
                } else if toggle == "filter" {
                    Image(systemName: "magnifyingglass").foregroundColor(.accentColor)
                } else {
                    ZStack {
                        if menu == "filter" {
                            Image(systemName: "magnifyingglass").foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .onTapGesture { self.toggle = "filter" }
                    .onHover { hovering in
                        self.menu = hovering ? "filter" : ""
                    }
                }
            }
            .frame(height: 26)
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
                    if !files.contains(filename) && filename != "" && !filename.hasPrefix(".") {
                        Button(action: {
                            Storage(status: $status, progress: $progress).write(
                                status: status,
                                selection: filename,
                                data: Storage(status: $status, progress: $progress).data
                            )
                            self.filename = ""
                            self.files = Storage(status: $status, progress: $progress).identify(status: status)
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
                VStack(spacing: 15) {
                    HStack {
                        TextField("􀊫 Languages", text: $language)
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
                                set: { data.base = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
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
                                    Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data)
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
                            if data.translations[index].language.lowercased().hasPrefix(language.lowercased()) {
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
                                        .contextMenu {
                                            Button(action: {
                                                data.translations[index].target = false
                                                Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data)
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
            if toggle == "filter" {
                TextField("􀊫 Strings", text: $query)
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
                    HStack {
                        Text("Unpinned")
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { data.filters.unpinned },
                            set: { data.filters.unpinned = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
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
                        Text("Alerts")
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { data.alerts },
                            set: { data.alerts = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
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
                            Text("Columns")
                            Spacer()
                        }
                        .frame(width: 65)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { data.styles.columns },
                            set: { data.styles.columns = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
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
                        .frame(width: 65)
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
                        .frame(width: 65)
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
                        .frame(width: 65)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { data.styles.color },
                            set: { data.styles.color = $0 ; Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data) }
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
                    /*
                    Button(action: {
                        data.styles.columns = 1
                        data.styles.font = "Helvetica Neue"
                        data.styles.size = CGFloat(14)
                        data.styles.weight = Font.Weight.regular
                        data.styles.color = Color.accentColor
                        Storage(status: $status, progress: $progress).write(status: status, selection: selection, data: data)
                    }) {
                        Text("Reset styles")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(
                        data.styles.columns == 1 && data.styles.font == "Helvetica Neue" && data.styles.size == CGFloat(14) && data.styles.weight == Font.Weight.regular && data.styles.color == Color.accentColor
                    )
                    */
                }
                .padding()
                Spacer()
            }
        }
        .accentColor(data.styles.color)
        /*
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "rectangle.leftthird.inset.fill")
                }
            }
        }
        */
    }
    
}
