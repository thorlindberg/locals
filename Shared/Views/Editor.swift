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

struct Path: View {
    @Binding var data: Storage.Format
    var body: some View {
        if data.target != "" {
            HStack {
                Text("\(data.base)")
                    .fontWeight(.regular)
                    .opacity(0.5)
                Text("􀆊")
                    .fontWeight(.regular)
                    .opacity(0.5)
                Text("\(data.target)")
                    .fontWeight(.regular)
                    .foregroundColor(data.styles.color)
                Spacer()
                Text(data.saved)
                    .fontWeight(.regular)
                    .opacity(0.5)
            }
        } else {
            Text("")
        }
    }
}

struct Filters: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    var body: some View {
        Section(header: Text("Filters")) {
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
        }
    }
    
}

struct Styles: View {
    
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
        Section(header: Text("Styles")) {
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
                        ForEach(Array(stride(from: 1, to: 10, by: 2)), id: \.self) { count in
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
            }
        }
    }
    
}

struct Settings: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    var body: some View {
        Section(header: Text("Import extensions")) {
            HStack {
                /*
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
                */
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
        }
    }
    
}

struct Card: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    @Binding var alert: Bool
    var index: Range<Array<Storage.Format.Translations>.Index>.Element
    var string: Range<Array<Dictionary<String, Storage.Format.Text>.Keys.Element>.Index>.Element
    var strings: [Dictionary<String, Storage.Format.Text>.Keys.Element]
    
    var body: some View {
        if !data.translations[0].texts.isEmpty {
            let reduced = data.translations[index].texts[strings[string]]!.pinned && data.styles.vibrancy == 0
            let vibrant = data.translations[index].texts[strings[string]]!.pinned && data.styles.vibrancy == 1
            ZStack {
                if vibrant {
                    Rectangle()
                        .foregroundColor(data.styles.color)
                        .opacity(0.8)
                        .cornerRadius(6)
                } else {
                    Rectangle()
                        .opacity((string % 2 == 0) ? 0.03 : 0)
                        .cornerRadius(6)
                }
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            Text("#\(data.translations[index].texts[strings[string]]!.order)")
                                .fontWeight(.light)
                                .foregroundColor(vibrant ? Color("Text") : reduced ? nil : nil)
                                .opacity(vibrant ? 0.5 : 0.25)
                            Spacer()
                            Text(data.translations[index].texts[strings[string]]!.single ? "S" : "M")
                                .fontWeight(.light)
                                .foregroundColor(vibrant ? Color("Text") : reduced ? nil : nil)
                                .opacity(vibrant ? 0.5 : 0.25)
                                .help(data.translations[index].texts[strings[string]]!.single ? "Singleline" : "Multiline")
                            ZStack {
                                Image(systemName: "pin.fill")
                                    .foregroundColor(vibrant ? Color("Text") : reduced ? data.styles.color : nil)
                                    .opacity(vibrant ? 0.8 : reduced ? 1 : 0.25)
                                    .help(data.translations[index].texts[strings[string]]!.pinned ? "Pin" : "Unpin")
                            }
                            .onTapGesture {
                                withAnimation {
                                    data.translations.indices.forEach { index in
                                        data.translations[index].texts[strings[string]]!.pinned = !data.translations[index].texts[strings[string]]!.pinned
                                    }
                                    Storage(data: $data).write(selection: selection)
                                }
                            }
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(vibrant ? Color("Text") : reduced ? nil : nil)
                                .opacity(vibrant ? 0.5 : 0.25)
                                .onTapGesture {
                                    if data.alerts {
                                        self.alert.toggle()
                                    } else {
                                        withAnimation {
                                            data.translations.indices.forEach { t in
                                                data.translations[t].texts.keys.forEach { s in
                                                    if data.translations[t].texts[s]!.order > data.translations[index].texts[strings[string]]!.order {
                                                        data.translations[t].texts[s]!.order = data.translations[t].texts[s]!.order - 1
                                                    }
                                                }
                                            }
                                            data.translations.indices.forEach { index in
                                                data.translations[index].texts.removeValue(forKey: strings[string])
                                            }
                                            Storage(data: $data).write(selection: selection)
                                        }
                                    }
                                }
                        }
                        Spacer()
                    }
                    .frame(height: 40)
                    Spacer()
                    Text("\(strings[string])")
                        .font(.custom(data.styles.font, size: data.styles.size))
                        .fontWeight(data.styles.weight)
                        .foregroundColor(vibrant ? Color("Text") : data.styles.color)
                    TextField("Add translation", text: Binding(
                        get: { data.translations[index].texts[strings[string]]!.translation },
                        set: { data.translations[index].texts[strings[string]]?.translation = $0 }
                    ), onCommit: { withAnimation { Storage(data: $data).write(selection: selection)}})
                    .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
            }
        }
    }
    
}

struct Entries: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    
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
                        .foregroundColor(data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) ? .red : Color("Mode"))
                        .opacity(data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) ? 0.5 : 1)
                        .cornerRadius(6)
                        .frame(height: 30)
                    if entering {
                        HStack(spacing: 7) {
                            TextField("Add unique string", text: $data.fields.entry, onCommit: {
                                if data.fields.entry.trimmingCharacters(in: .whitespaces) != "" && !data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) {
                                    data.translations.indices.forEach { index in
                                        self.data.translations[index].texts[data.fields.entry] = Storage.Format.Text(
                                            order: data.translations[index].texts.isEmpty ? 1 : data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                            translation: "",
                                            pinned: false,
                                            single: true,
                                            multi: false
                                        )
                                    }
                                    data.fields.entry = ""
                                    Storage(data: $data).write(selection: selection)
                                }
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            if data.fields.entry != "" {
                                Image(systemName: "xmark.circle.fill")
                                    .opacity(0.5)
                                    .onTapGesture {
                                        withAnimation {
                                            data.fields.entry = ""
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
                        data.fields.query = ""
                    }
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("Mode"))
                        .opacity(data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) ? 0.5 : 1)
                        .cornerRadius(6)
                        .frame(height: 30)
                    if searching {
                        HStack(spacing: 7) {
                            TextField("􀊫 Find a string", text: $data.fields.query)
                                .textFieldStyle(PlainTextFieldStyle())
                            if data.fields.query != "" {
                                Image(systemName: "xmark.circle.fill")
                                    .opacity(0.5)
                                    .onTapGesture {
                                        withAnimation {
                                            data.fields.query = ""
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
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    @State var alert: Bool = false
    @State var popover: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            if selection != "" && data.target != "" {
                ZStack {
                    List {
                        Section(header: Path(data: $data)) {
                            if !data.translations[0].texts.isEmpty {
                                LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 600)), count: data.styles.columns), spacing: 10) {
                                    ForEach(data.translations.indices, id: \.self) { index in
                                        if data.translations[index].language == data.target {
                                            let strings = Array(data.translations[index].texts.keys)
                                                .sorted { data.translations[index].texts[$0]!.order < data.translations[index].texts[$1]!.order }
                                                .sorted { data.translations[index].texts[$0]!.pinned == true && data.translations[index].texts[$1]!.pinned == false }
                                                .filter { $0.lowercased().hasPrefix(data.fields.query.lowercased()) } // search strings
                                                .filter { data.filters.singleline ? true : !data.translations[index].texts[$0]!.single } // single-line
                                                .filter { data.filters.multiline ? true : !data.translations[index].texts[$0]!.multi } // multi-line
                                                .filter { data.filters.parenthesis ? true : !($0.hasPrefix("(") && $0.hasSuffix(")")) } // parenthesis
                                                .filter { data.filters.nummerical ? true : !($0.allSatisfy({ $0.isNumber })) } // nummerical
                                                .filter { data.filters.symbols ? true : !($0.allSatisfy({ ($0.isSymbol || $0.isPunctuation || $0.isCurrencySymbol || $0.isMathSymbol) })) } // symbols
                                                .filter { data.filters.unpinned ? true : data.translations[index].texts[$0]!.pinned } // unpinned
                                            ForEach(strings.indices, id: \.self) { string in
                                                Card(selection: $selection, data: $data, alert: $alert, index: index, string: string, strings: strings)
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer()
                                .frame(height: 50)
                        }
                    }
                    VStack(spacing: 0) {
                        Spacer()
                        Entries(selection: $selection, data: $data)
                            .disabled(data.target == "")
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
                    data.alerts = false
                    Storage(data: $data).write(selection: selection)
                },
                secondaryButton: .cancel (Text("Cancel")) {
                    self.alert = false
                }
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    Coder(data: $data).decode() { lines in
                        lines["S"]!.forEach { string in
                            data.translations.indices.forEach { index in
                                if !data.translations[index].texts.keys.contains(string) {
                                    data.translations[index].texts[string] = Storage.Format.Text(
                                        order: data.translations[index].texts.isEmpty ? 1 : data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                        translation: "", pinned: false, single: true, multi: false
                                    )
                                }
                            }
                        }
                        lines["M"]!.forEach { string in
                            data.translations.indices.forEach { index in
                                if !data.translations[index].texts.keys.contains(string) {
                                    data.translations[index].texts[string] = Storage.Format.Text(
                                        order: data.translations[index].texts.isEmpty ? 1 : data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                        translation: "", pinned: false, single: false, multi: true
                                    )
                                }
                            }
                        }
                        Storage(data: $data).write(selection: selection)
                    }
                }) {
                    Image(systemName: "arrow.down.doc")
                }
                .disabled(selection == "")
                .help("Import an Xcode project folder")
                Button(action: {
                    withAnimation {
                        Progress(data: $data).load(string: "Translating strings to \(data.target)...")
                        Translation(data: $data).translate()
                        Storage(data: $data).write(selection: selection)
                    }
                }) {
                    Image(systemName: "globe")
                }
                .disabled(true || selection == "" || data.target == "" || data.translations[0].texts.isEmpty)
                .help("Coming soon: Auto-translate strings")
                Spacer()
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Rectangle()
                                .foregroundColor(data.styles.color)
                                .frame(width: 300 * data.progress, height: 1.5)
                            Spacer()
                        }
                        .frame(width: 300, height: 1.5)
                    }
                    .frame(width: 300, height: 27)
                    .mask(Rectangle().frame(width: 300, height: 27).cornerRadius(5))
                    Menu {
                        ForEach(data.status.indices.reversed(), id: \.self) { index in
                            Text("\(data.status[index])")
                                .font(.system(size: 10))
                            Divider()
                        }
                    } label: {
                        Text(data.status.last!)
                            .font(.system(size: 10))
                    }
                    .frame(width: 300)
                    .help("View project changelog, and revert to a previous version")
                }
                Spacer()
                Button(action: {
                    self.popover.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
                .disabled(selection == "")
                .popover(isPresented: $popover) {
                    VStack(spacing: 0) {
                        /*
                        List {
                            Settings(selection: $selection, data: $data)
                        }
                        .listStyle(SidebarListStyle())
                        .frame(width: 420, height: 70)
                        Divider()
                        */
                        HStack(spacing: 0) {
                            List {
                                Styles(selection: $selection, data: $data)
                            }
                            .listStyle(SidebarListStyle())
                            .frame(width: 250, height: 222)
                            Divider()
                            List {
                                Filters(selection: $selection, data: $data)
                            }
                            .listStyle(SidebarListStyle())
                            .frame(width: 170, height: 222)
                        }
                    }
                }
                Button(action: {
                    Coder(data: $data).encode()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(selection == "" || data.target == "" || data.translations[0].texts.isEmpty)
                .help("Export translations as .strings files")
            }
        }
    }
    
}
