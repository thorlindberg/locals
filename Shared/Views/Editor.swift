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

struct Header: View {
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

struct Card: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    @Binding var alert: Bool
    var index: Range<Array<Storage.Format.Translations>.Index>.Element
    var string: Range<Array<Dictionary<String, Storage.Format.Text>.Keys.Element>.Index>.Element
    var strings: [Dictionary<String, Storage.Format.Text>.Keys.Element]
    
    var body: some View {
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

struct Editor: View {
    
    @Binding var selection: String
    @Binding var data: Storage.Format
    
    @State var checking: Bool = false
    @State var clear: Bool = false
    @State var alert: Bool = false
    
    var body: some View {
        ZStack {
            if selection != "" && data.target != "" {
                VStack(spacing: 0) {
                    List {
                        Section(header: Header(data: $data)) {
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
                    }
                    Divider()
                    ZStack {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 55)
                        ZStack {
                            Rectangle()
                                .foregroundColor(data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) ? .red : Color("Mode"))
                                .opacity(data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) ? 0.5 : 1)
                                .cornerRadius(6)
                                .frame(height: 30)
                            TextField("Add unique string", text: $data.fields.entry, onCommit: {
                                if data.fields.entry.trimmingCharacters(in: .whitespaces) != "" && !data.translations.filter({$0.language == data.target})[0].texts.keys.contains(data.fields.entry) {
                                    data.translations.indices.forEach { index in
                                        data.translations[index].texts[data.fields.entry] = Storage.Format.Text(
                                            order: data.translations[index].texts.isEmpty ? 1 : data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                            translation: "",
                                            pinned: false,
                                            single: true,
                                            multi: false
                                        )
                                    }
                                    Storage(data: $data).write(selection: selection)
                                    data.fields.entry = ""
                                }
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                }
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color("Mode"))
                        .frame(height: 60)
                        .background(VisualEffect())
                    Divider()
                    Spacer()
                }
                .padding(.top, -60)
            }
        }
        .alert(isPresented: $alert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Deleting an entry removes it from your entire project. This action is irreversible."),
                primaryButton: .default (Text("Okay")) {
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
                    Image(systemName: "folder.fill.badge.plus")
                }
                .disabled(selection == "")
                .help("Import strings from an Xcode project folder")
                /*
                Button(action: {
                    withAnimation {
                        Progress(data: $data).load(string: "Translating strings to \(data.target)...")
                        Translation(data: $data).translate()
                        Storage(data: $data).write(selection: selection)
                    }
                }) {
                    Image(systemName: "globe")
                }
                .disabled(selection == "") // DISABLE IF THERE ARE NO STRINGS OR BASE/TARGET LANGUAGE IS NOT VALID FOR TRANSLATION
                .help("Auto-translate strings")
                */
                Spacer()
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Rectangle()
                                .foregroundColor(data.styles.color)
                                .frame(width: 500 * data.progress, height: 1.5)
                            Spacer()
                        }
                        .frame(width: 500, height: 1.5)
                    }
                    .frame(width: 500, height: 27)
                    .mask(Rectangle().frame(width: 500, height: 27).cornerRadius(5))
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
                    .frame(width: 500)
                    .help("View project changelog, and revert to a previous version")
                    HStack {
                        Spacer()
                        ZStack {
                            if clear {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(data.styles.color)
                            } else if checking {
                                Image(systemName: "xmark.circle")
                                    .opacity(0.25)
                            }
                        }
                        .onHover { hovering in
                            self.clear = hovering ? true : false
                        }
                        .onTapGesture {
                            data.status = ["\(Time().current()) - Cleared application changelog"]
                        }
                    }
                    .padding(.horizontal, 22)
                }
                .onHover { hovering in
                    withAnimation { self.checking = hovering ? true : false }
                }
                Spacer()
                MenuButton(label: Image(systemName: "arrow.up.doc")) {
                    Button(action: {
                        // COPY PROJECT AND SEND IT SOMEWHERE
                    }) {
                        Label("Share project file", systemImage: "doc")
                    }
                    Button(action: {
                        Coder(data: $data).encode()
                    }) {
                        Label("Export as .strings", systemImage: "folder")
                    }
                }
                .disabled(selection == "" || data.target == "") // DISABLE IF NO STRINGS
            }
        }
    }
    
}
