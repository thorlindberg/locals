import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct Filters: View {
    
    @Binding var document: Document
    
    var body: some View {
        Section(header: Text("Filters")) {
            VStack {
                HStack {
                    Text("Single-line")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.filters.singleline },
                        set: { document.data.filters.singleline = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                HStack {
                    Text("Multi-line")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.filters.multiline },
                        set: { document.data.filters.multiline = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                HStack {
                    Text("Parenthesis")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.filters.parenthesis },
                        set: { document.data.filters.parenthesis = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                HStack {
                    Text("Nummerical")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.filters.nummerical },
                        set: { document.data.filters.nummerical = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                HStack {
                    Text("Symbols")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.filters.symbols },
                        set: { document.data.filters.symbols = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                HStack {
                    Text("Unpinned")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.filters.unpinned },
                        set: { document.data.filters.unpinned = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
            }
        }
    }
    
}

struct Styles: View {
    
    @Binding var document: Document
    
    let fonts: [String] = [
        "American Typewriter", "Andale Mono", "Arial", "Avenir", "Baskerville", "Big Caslon", "Bodoni 72",
        "Bradley Hand", "Calibri", "Cambria", "Chalkboard", "Chalkduster", "Charter", "Cochin", "Copperplate",
        "Courier", "Didot", "Futura", "Geneva", "Georgia", "Gill Sans", "Helvetica", "Helvetica Neue", "Impact",
        "Lucida Grande", "Luminari", "Marker Felt", "Menlo", "Monaco", "Noteworthy", "Optima", "Palatino", "Papyrus",
        "Phosphate", "Rockwell", "San Francisco", "Skia", "Tahoma", "Times", "Times New Roman", "Verdana"
    ]
    
    var body: some View {
        Section(header: Text("Styles")) {
            VStack {
                /*
                HStack {
                    HStack {
                        Text("Columns")
                        Spacer()
                    }
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { document.data.styles.columns },
                        set: { document.data.styles.columns = $0 }
                    )) {
                        ForEach(Array(stride(from: 1, to: 10, by: 2)), id: \.self) { count in
                            Text(String(count)).tag(count)
                        }
                    }
                }
                */
                HStack {
                    HStack {
                        Text("Font")
                        Spacer()
                    }
                    .frame(width: 65)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { document.data.styles.font },
                        set: { document.data.styles.font = $0 }
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
                        get: { document.data.styles.size },
                        set: { document.data.styles.size = $0 }
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
                        get: { document.data.styles.weight },
                        set: { document.data.styles.weight = $0 }
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
                        get: { document.data.styles.color },
                        set: { document.data.styles.color = $0 }
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
                        get: { document.data.styles.vibrancy },
                        set: { document.data.styles.vibrancy = $0 }
                    )) {
                        Text("Reduced").tag(0)
                        Text("Default").tag(1)
                    }
                }
            }
        }
    }
    
}

struct Card: View {
    
    @Binding var document: Document
    var index: Range<Array<Document.Format.Translations>.Index>.Element
    var string: Range<Array<Dictionary<String, Document.Format.Text>.Keys.Element>.Index>.Element
    var strings: [Dictionary<String, Document.Format.Text>.Keys.Element]
    
    var body: some View {
        if !document.data.translations[0].texts.isEmpty {
            let reduced = document.data.translations[index].texts[strings[string]]!.pinned && document.data.styles.vibrancy == 0
            let vibrant = document.data.translations[index].texts[strings[string]]!.pinned && document.data.styles.vibrancy == 1
            ZStack {
                if vibrant {
                    Rectangle()
                        .foregroundColor(document.data.styles.color)
                        .opacity(0.8)
                        .cornerRadius(6)
                } else {
                    Rectangle()
                        .opacity((string % 2 == 0) ? 0.03 : 0)
                        .cornerRadius(6)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(strings[string])")
                            .font(.custom(document.data.styles.font, size: document.data.styles.size))
                            .fontWeight(document.data.styles.weight)
                            .foregroundColor(vibrant ? Color("Text") : document.data.styles.color)
                        TextField("Add translation", text: Binding(
                            get: { document.data.translations[index].texts[strings[string]]!.translation },
                            set: { document.data.translations[index].texts[strings[string]]?.translation = $0 }
                        ))
                        .textFieldStyle(PlainTextFieldStyle())
                    }
                    Spacer()
                    VStack {
                        ZStack {
                            Image(systemName: "pin.fill")
                                .foregroundColor(vibrant ? Color("Text") : reduced ? document.data.styles.color : nil)
                                .opacity(vibrant ? 0.8 : reduced ? 1 : 0.25)
                                .help(document.data.translations[index].texts[strings[string]]!.pinned ? "Pin" : "Unpin")
                        }
                        .padding(.bottom, 5)
                        .onTapGesture {
                            withAnimation {
                                document.data.translations.indices.forEach { index in
                                    document.data.translations[index].texts[strings[string]]!.pinned = !document.data.translations[index].texts[strings[string]]!.pinned
                                }
                            }
                        }
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(vibrant ? Color("Text") : reduced ? nil : nil)
                            .opacity(vibrant ? 0.5 : 0.25)
                            .onTapGesture {
                                if document.data.toggles.alerts {
                                    document.data.toggles.alert.toggle()
                                } else {
                                    withAnimation {
                                        document.data.translations.indices.forEach { t in
                                            document.data.translations[t].texts.keys.forEach { s in
                                                if document.data.translations[t].texts[s]!.order > document.data.translations[index].texts[strings[string]]!.order {
                                                    document.data.translations[t].texts[s]!.order = document.data.translations[t].texts[s]!.order - 1
                                                }
                                            }
                                        }
                                        document.data.translations.indices.forEach { index in
                                            document.data.translations[index].texts.removeValue(forKey: strings[string])
                                        }
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
    
}

struct Entries: View {
    
    @Binding var document: Document
    
    var body: some View {
        
        Divider()
        ZStack {
            Rectangle()
                .opacity(0)
                .frame(height: 55)
            ZStack {
                Rectangle()
                    .foregroundColor(document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) ? .red : Color("Mode"))
                    .opacity(document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) ? 0.5 : 1)
                    .cornerRadius(6)
                    .frame(height: 30)
                HStack(spacing: 7) {
                    TextField("Add unique string", text: $document.data.fields.entry, onCommit: {
                        if document.data.fields.entry.trimmingCharacters(in: .whitespaces) != "" && !document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) {
                            document.data.translations.indices.forEach { index in
                                document.data.translations[index].texts[document.data.fields.entry] = Document.Format.Text(
                                    order: document.data.translations[index].texts.isEmpty ? 1 : document.data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                    translation: "",
                                    pinned: false,
                                    single: true,
                                    multi: false
                                )
                            }
                            document.data.fields.entry = ""
                        }
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    if document.data.fields.entry != "" {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(0.5)
                            .onTapGesture {
                                withAnimation {
                                    document.data.fields.entry = ""
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        
    }
    
}

struct Editor: View {
    
    @Binding var document: Document
    
    var body: some View {
        VStack(spacing: 0) {
            if document.data.target != "" {
                VStack(spacing: 0) {
                    if document.data.translations[0].texts.isEmpty || document.data.toggles.dropping {
                        Spacer()
                        ZStack {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 150))
                                .opacity(0.05)
                            Image(systemName: "folder.fill.badge.plus")
                                .font(.system(size: 50))
                                .opacity(0.1)
                        }
                        .padding(.bottom, 30)
                        Text("Drop a folder here to import strings")
                            .fontWeight(.bold)
                            .opacity(0.2)
                        Spacer()
                    } else {
                        List {
                            ForEach(document.data.translations.indices, id: \.self) { index in
                                if document.data.translations[index].language == document.data.target {
                                    let strings = Array(document.data.translations[index].texts.keys)
                                        .sorted { document.data.translations[index].texts[$0]!.order < document.data.translations[index].texts[$1]!.order }
                                        .sorted { document.data.translations[index].texts[$0]!.pinned == true && document.data.translations[index].texts[$1]!.pinned == false }
                                        .filter { $0.lowercased().hasPrefix(document.data.fields.query.lowercased()) } // search strings
                                        .filter { document.data.filters.singleline ? true : !document.data.translations[index].texts[$0]!.single } // single-line
                                        .filter { document.data.filters.multiline ? true : !document.data.translations[index].texts[$0]!.multi } // multi-line
                                        .filter { document.data.filters.parenthesis ? true : !($0.hasPrefix("(") && $0.hasSuffix(")")) } // parenthesis
                                        .filter { document.data.filters.nummerical ? true : !($0.allSatisfy({ $0.isNumber })) } // nummerical
                                        .filter { document.data.filters.symbols ? true : !($0.allSatisfy({ ($0.isSymbol || $0.isPunctuation || $0.isCurrencySymbol || $0.isMathSymbol) })) } // symbols
                                        .filter { document.data.filters.unpinned ? true : document.data.translations[index].texts[$0]!.pinned } // unpinned
                                    ForEach(strings.indices, id: \.self) { string in
                                        Card(document: $document, index: index, string: string, strings: strings)
                                    }
                                }
                            }
                        }
                    }
                    Entries(document: $document)
                        .disabled(document.data.target == "")
                }
                .onDrop(of: ["public.file-url"], isTargeted: $document.data.toggles.dropping, perform: { provider -> Bool in
                    if let item = provider.first {
                        _ = item.loadObject(ofClass: URL.self) { (url, error) in
                            if let folder = url {
                                Coder(document: $document).decode(folder: folder) { lines in
                                    lines["S"]!.forEach { string in
                                        document.data.translations.indices.forEach { index in
                                            if !document.data.translations[index].texts.keys.contains(string) {
                                                document.data.translations[index].texts[string] = Document.Format.Text(
                                                    order: document.data.translations[index].texts.isEmpty ? 1 : document.data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                                    translation: "", pinned: false, single: true, multi: false
                                                )
                                            }
                                        }
                                    }
                                    lines["M"]!.forEach { string in
                                        document.data.translations.indices.forEach { index in
                                            if !document.data.translations[index].texts.keys.contains(string) {
                                                document.data.translations[index].texts[string] = Document.Format.Text(
                                                    order: document.data.translations[index].texts.isEmpty ? 1 : document.data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                                    translation: "", pinned: false, single: false, multi: true
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    return true
                })
            } else {
                Spacer()
            }
        }
        .alert(isPresented: $document.data.toggles.alert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Deleting an entry removes it from your entire project. This action is irreversible."),
                primaryButton: .default (Text("Understood")) {
                    document.data.toggles.alert = false
                    document.data.toggles.alerts = false
                },
                secondaryButton: .cancel (Text("Cancel")) {
                    document.data.toggles.alert = false
                }
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                /*
                Button(action: {
                    withAnimation {
                        Translation(document: $document).translate()
                    }
                }) {
                    Image(systemName: "globe")
                }
                .disabled(true || document.data.target == "" || document.data.translations[0].texts.isEmpty)
                .help("Auto-translate strings")
                */
                Toggle(isOn: $document.data.toggles.importing) {
                    Image(systemName: "folder.badge.plus")
                }
                .disabled(document.data.target == "")
                .help("Import an Xcode project folder")
                .fileImporter(
                    isPresented: $document.data.toggles.importing, allowedContentTypes: [.folder], allowsMultipleSelection: true
                ) { result in
                    do {
                        guard let folder: URL = try result.get().first else { return }
                        Coder(document: $document).decode(folder: folder) { lines in
                            lines["S"]!.forEach { string in
                                document.data.translations.indices.forEach { index in
                                    if !document.data.translations[index].texts.keys.contains(string) {
                                        document.data.translations[index].texts[string] = Document.Format.Text(
                                            order: document.data.translations[index].texts.isEmpty ? 1 : document.data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                            translation: "", pinned: false, single: true, multi: false
                                        )
                                    }
                                }
                            }
                            lines["M"]!.forEach { string in
                                document.data.translations.indices.forEach { index in
                                    if !document.data.translations[index].texts.keys.contains(string) {
                                        document.data.translations[index].texts[string] = Document.Format.Text(
                                            order: document.data.translations[index].texts.isEmpty ? 1 : document.data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                            translation: "", pinned: false, single: false, multi: true
                                        )
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Unable to read folder contents")
                        print(error.localizedDescription)
                    }
                }
                Toggle(isOn: $document.data.toggles.exporting) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(document.data.target == "" || document.data.translations[0].texts.isEmpty)
                .help("Export translations as .strings files")
                .fileImporter(
                    isPresented: $document.data.toggles.exporting, allowedContentTypes: [.folder], allowsMultipleSelection: false
                ) { result in
                    do {
                        guard let folder: URL = try result.get().first else { return }
                        Coder(document: $document).encode(folder: folder)
                    } catch {
                        print("Unable to export as .strings")
                        print(error.localizedDescription)
                    }
                }
                ZStack {
                    TextField("􀊫 Find a string", text: $document.data.fields.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .disabled(document.data.target == "" || document.data.translations[0].texts.isEmpty)
                    HStack {
                        Spacer()
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .opacity(document.data.toggles.popover ? 1 : 0.5)
                            .padding(.trailing, 7)
                            .onTapGesture {
                                document.data.toggles.popover.toggle()
                            }
                    }
                }
                .popover(isPresented: $document.data.toggles.popover) {
                    VStack(spacing: 0) {
                        List {
                            Styles(document: $document)
                        }
                        .listStyle(SidebarListStyle())
                        .frame(height: 195)
                        Divider()
                        List {
                            Filters(document: $document)
                        }
                        .listStyle(SidebarListStyle())
                        .frame(height: 215)
                    }
                    .frame(width: 240)
                }
            }
        }
    }
    
}
