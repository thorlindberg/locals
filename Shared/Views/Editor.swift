import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct VisualEffect: NSViewRepresentable {
    
  func makeNSView(context: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.blendingMode = .withinWindow
    view.isEmphasized = true
    view.material = .popover
    return view
  }
    
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
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

struct Settings: View {
    
    @Binding var document: Document
    
    var body: some View {
        Section(header: Text("Import extensions")) {
            HStack {
                /*
                HStack {
                    Text("Alerts")
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.alerts },
                        set: { document.data.alerts = $0 }
                    )) {
                        Text("")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                */
                ForEach(Array(document.data.extensions.keys), id: \.self) { format in
                    HStack {
                        Text(format.capitalized)
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { document.data.extensions[format]! },
                            set: { document.data.extensions[format] = $0 }
                        )) {
                            Text("")
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                }
            }
        }
    }
    
}

struct Card: View {
    
    @Binding var document: Document
    @Binding var alert: Bool
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
                        /*
                        Text("#\(document.data.translations[index].texts[strings[string]]!.order)")
                            .fontWeight(.light)
                            .foregroundColor(vibrant ? Color("Text") : reduced ? nil : nil)
                            .opacity(vibrant ? 0.5 : 0.25)
                        Text(document.data.translations[index].texts[strings[string]]!.single ? "S" : "M")
                            .fontWeight(.light)
                            .foregroundColor(vibrant ? Color("Text") : reduced ? nil : nil)
                            .opacity(vibrant ? 0.5 : 0.25)
                            .help(document.data.translations[index].texts[strings[string]]!.single ? "Singleline" : "Multiline")
                        */
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
                                if document.data.alerts {
                                    self.alert.toggle()
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
    @State var entering: Bool = true
    @State var searching: Bool = false
    
    var body: some View {
        
        Divider()
        ZStack {
            Rectangle()
                .opacity(0)
                .frame(height: 55)
                .background(VisualEffect())
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .foregroundColor(document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) ? .red : Color("Mode"))
                        .opacity(document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) ? 0.5 : 1)
                        .cornerRadius(6)
                        .frame(height: 30)
                    if entering {
                        HStack(spacing: 7) {
                            TextField("Add unique string", text: $document.data.fields.entry, onCommit: {
                                if document.data.fields.entry.trimmingCharacters(in: .whitespaces) != "" && !document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) {
                                    document.data.translations.indices.forEach { index in
                                        self.document.data.translations[index].texts[document.data.fields.entry] = Document.Format.Text(
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
                    } else {
                        Image(systemName: "plus")
                    }
                }
                .frame(maxWidth: entering ? .infinity : 40)
                .onTapGesture {
                    withAnimation {
                        self.entering = true
                        self.searching = false
                        document.data.fields.query = ""
                    }
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("Mode"))
                        .opacity(document.data.translations.filter({$0.language == document.data.target})[0].texts.keys.contains(document.data.fields.entry) ? 0.5 : 1)
                        .cornerRadius(6)
                        .frame(height: 30)
                    if searching {
                        HStack(spacing: 7) {
                            TextField("􀊫 Find a string", text: $document.data.fields.query)
                                .textFieldStyle(PlainTextFieldStyle())
                            if document.data.fields.query != "" {
                                Image(systemName: "xmark.circle.fill")
                                    .opacity(0.5)
                                    .onTapGesture {
                                        withAnimation {
                                            document.data.fields.query = ""
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .frame(maxWidth: searching ? .infinity : 40)
                .onTapGesture {
                    withAnimation {
                        self.entering = false
                        self.searching = true
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        
    }
    
}

struct Editor: View {
    
    @Binding var document: Document
    @State var alert: Bool = false
    @State var popover: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            if document.data.target != "" {
                ZStack {
                    List {
                        if !document.data.translations[0].texts.isEmpty {
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
                                        Card(document: $document, alert: $alert, index: index, string: string, strings: strings)
                                    }
                                }
                            }
                        }
                    }
                    VStack(spacing: 0) {
                        Spacer()
                        Entries(document: $document)
                            .disabled(document.data.target == "")
                    }
                }
            } else {
                Spacer()
            }
        }
        .alert(isPresented: $alert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Deleting an entry removes it from your entire project. This action is irreversible."),
                primaryButton: .default (Text("Understood")) {
                    self.alert = false
                    document.data.alerts = false
                },
                secondaryButton: .cancel (Text("Cancel")) {
                    self.alert = false
                }
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    Coder(document: $document).decode() { lines in
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
                }) {
                    Image(systemName: "arrow.down.doc")
                }
                .help("Import an Xcode project folder")
                Button(action: {
                    withAnimation {
                        Translation(document: $document).translate()
                    }
                }) {
                    Image(systemName: "globe")
                }
                .disabled(true || document.data.target == "" || document.data.translations[0].texts.isEmpty)
                .help("Coming soon: Auto-translate strings")
                Button(action: {
                    self.popover.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
                .popover(isPresented: $popover) {
                    VStack(spacing: 0) {
                        /*
                        List {
                            Settings(),document: $document)
                        }
                        .listStyle(SidebarListStyle())
                        .frame(width: 420, height: 70)
                        Divider()
                        */
                        VStack(spacing: 0) {
                            List {
                                Styles(document: $document)
                            }
                            .listStyle(SidebarListStyle())
                            Divider()
                            List {
                                Filters(document: $document)
                            }
                            .listStyle(SidebarListStyle())
                        }
                        .frame(width: 250, height: 450)
                    }
                }
                Button(action: {
                    Coder(document: $document).encode()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(document.data.target == "" || document.data.translations[0].texts.isEmpty)
                .help("Export translations as .strings files")
            }
        }
    }
    
}
