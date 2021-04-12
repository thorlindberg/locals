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
                Text("􀆊")
                Text("\(data.target)")
            }
        } else {
            Text("")
        }
    }
}

struct Editor: View {
    
    @Binding var selection: String
    @Binding var status: [String]
    @Binding var progress: CGFloat
    @Binding var data: Storage.Format
    @Binding var query: String
    @Binding var entry: String
    @Binding var inspector: Bool
    
    @State var xmark: String = ""
    @State var pin: String = ""
    @State var row: String = ""
    @State var checking: Bool = false
    @State var clear: Bool = false
    
    var body: some View {
        ZStack {
            if selection != "" && data.target != "" {
                VStack(spacing: 0) {
                    List {
                        Section(header: Header(data: $data)) {
                            Spacer()
                                .frame(height: 10)
                            LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 600)), count: data.styles.columns), spacing: 0) {
                                ForEach(data.translations.indices, id: \.self) { index in
                                    if data.translations[index].language == data.target {
                                        let strings = Array(data.translations[index].texts.keys)
                                            .sorted { data.translations[index].texts[$0]!.order < data.translations[index].texts[$1]!.order }
                                            .sorted { data.translations[index].texts[$0]!.pinned == true && data.translations[index].texts[$1]!.pinned == false }
                                            .filter { $0.lowercased().hasPrefix(query.lowercased()) }
                                        ForEach(strings.indices, id: \.self) { string in
                                            ZStack {
                                                Rectangle()
                                                    .frame(minHeight: 50)
                                                    .opacity((string % 2 == 0) ? 0.03 : 0)
                                                    .cornerRadius(6)
                                                HStack(alignment: .center, spacing: 15) {
                                                    HStack {
                                                        if strings[string] == row {
                                                            ZStack {
                                                                if strings[string] == xmark {
                                                                    Image(systemName: "xmark.circle.fill")
                                                                        .foregroundColor(data.styles.color)
                                                                } else {
                                                                    Image(systemName: "xmark.circle.fill")
                                                                        .opacity(0.25)
                                                                }
                                                            }
                                                            .onHover { hovering in
                                                                self.xmark = hovering ? strings[string] : ""
                                                            }
                                                            .onTapGesture {
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
                                                                Storage(status: $status, progress: $progress).write(
                                                                    status: status,
                                                                    selection: selection,
                                                                    data: data
                                                                )
                                                            }
                                                        } else {
                                                            Text("\(data.translations[index].texts[strings[string]]!.order)")
                                                                .fontWeight(.light)
                                                                .opacity(0.25)
                                                        }
                                                        Spacer()
                                                    }
                                                    .frame(width: CGFloat(5 + (10 * String(data.translations[index].texts.values.map({$0.order}).max()!).count)))
                                                    VStack(alignment: .leading) {
                                                        Text("\(strings[string])")
                                                            .font(.custom(data.styles.font, size: data.styles.size))
                                                            .fontWeight(data.styles.weight)
                                                            .foregroundColor(data.styles.color)
                                                        Divider()
                                                        TextField("Translation", text: Binding(
                                                            get: { data.translations[index].texts[strings[string]]!.translation },
                                                            set: { data.translations[index].texts[strings[string]]?.translation = $0 }
                                                        ), onCommit: { withAnimation { Storage(status: $status, progress: $progress).write(
                                                            status: status,
                                                            selection: selection,
                                                            data: data
                                                        )}})
                                                        .textFieldStyle(PlainTextFieldStyle())
                                                    }
                                                    Spacer()
                                                    ZStack {
                                                        if data.translations[index].texts[strings[string]]!.pinned {
                                                            if strings[string] == pin {
                                                                Image(systemName: "pin.fill")
                                                                    .opacity(0.25)
                                                            } else {
                                                                Image(systemName: "pin.fill")
                                                                    .foregroundColor(data.styles.color)
                                                            }
                                                        } else if strings[string] == pin {
                                                            Image(systemName: "pin.fill")
                                                                .foregroundColor(data.styles.color)
                                                        } else if strings[string] == row {
                                                            Image(systemName: "pin.fill")
                                                                .opacity(0.25)
                                                        }
                                                    }
                                                    .onHover { hovering in
                                                        self.pin = hovering ? strings[string] : ""
                                                    }
                                                    .onTapGesture {
                                                        withAnimation {
                                                            data.translations.indices.forEach { index in
                                                                data.translations[index].texts[strings[string]]!.pinned = !data.translations[index].texts[strings[string]]!.pinned
                                                            }
                                                            Storage(status: $status, progress: $progress).write(
                                                                status: status,
                                                                selection: selection,
                                                                data: data
                                                            )
                                                        }
                                                    }
                                                }
                                                .padding()
                                            }
                                            .onHover { hovering in
                                                withAnimation { self.row = hovering ? strings[string] : "" }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                            Spacer()
                                .frame(height: 10)
                        }
                    }
                    Divider()
                    ZStack {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 55)
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("Mode"))
                                .cornerRadius(6)
                                .frame(height: 30)
                            TextField("Add unique string", text: $entry, onCommit: {
                                if entry != "" && !data.translations.filter({$0.language == data.target})[0].texts.keys.contains(entry) {
                                    data.translations.indices.forEach { index in
                                        data.translations[index].texts[entry] = Storage.Format.Text(
                                            order: data.translations[index].texts.isEmpty ? 1 : data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                            translation: "",
                                            pinned: false
                                        )
                                    }
                                    Storage(status: $status, progress: $progress).write(
                                        status: status,
                                        selection: selection,
                                        data: data
                                    )
                                    self.entry = ""
                                }
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(data.translations.filter({$0.language == data.target})[0].texts.keys.contains(entry) ? .red : data.styles.color)
                            .padding(.horizontal)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                    }
                }
                VStack(spacing: 0) {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 60)
                        .background(VisualEffect())
                    Divider()
                    Spacer()
                }
                .padding(.top, -60)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    Coder(data: $data, status: $status, progress: $progress).decode() { imported in
                        imported.forEach { string in
                            data.translations.indices.forEach { index in
                                if !data.translations[index].texts.keys.contains(string) {
                                    data.translations[index].texts[string] = Storage.Format.Text(
                                        order: data.translations[index].texts.isEmpty ? 1 : data.translations[index].texts.values.map({$0.order}).max()! + 1,
                                        translation: "",
                                        pinned: false
                                    )
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
                .disabled(selection == "")
                .help("Import strings from an Xcode project folder")
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
                .disabled(selection == "") // DISABLE IF THERE ARE NO STRINGS OR BASE/TARGET LANGUAGE IS NOT VALID FOR TRANSLATION
                .help("Auto-translate strings")
                Spacer()
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Rectangle()
                                .foregroundColor(data.styles.color)
                                .frame(width: 400 * self.progress, height: 1.5)
                            Spacer()
                        }
                        .frame(width: 400, height: 1.5)
                    }
                    .frame(width: 400, height: 27)
                    .mask(Rectangle().frame(width: 400, height: 27).cornerRadius(5))
                    Menu {
                        ForEach(status.indices.reversed(), id: \.self) { index in
                            Text("\(status[index])")
                                .font(.system(size: 10))
                            Divider()
                        }
                    } label: {
                        Text(status.last!)
                            .font(.system(size: 10))
                    }
                    .frame(width: 400)
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
                            self.status = ["\(Time().current()) - Cleared application changelog"]
                        }
                    }
                    .padding(.horizontal, 22)
                }
                .onHover { hovering in
                    withAnimation { self.checking = hovering ? true : false }
                }
                Spacer()
                Button(action: {
                    // Export localization project
                }) {
                    Image(systemName: "arrow.up.doc")
                }
                .disabled(selection == "" || data.target == "") // DISABLE IF NO STRINGS
                .help("Export localization project")
                Button(action: {
                    Coder(data: $data, status: $status, progress: $progress).encode()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(selection == "" || data.target == "") // DISABLE IF NO STRINGS
                .help("Export strings and translations")
            }
        }
    }
    
}
