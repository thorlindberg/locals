import SwiftUI

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
    
    @State var highlighting: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Divider()
                List {
                    Section(header: Header(data: $data)) {
                        Spacer()
                            .frame(height: 10)
                        VStack(spacing: 0) {
                            ForEach(data.translations.indices, id: \.self) { index in
                                if data.translations[index].language == data.target {
                                    let strings = Array(data.translations[index].texts.keys)
                                        .sorted { data.translations[index].texts[$0]!.pinned == true && data.translations[index].texts[$1]!.pinned == false }
                                    ForEach(strings.indices, id: \.self) { string in
                                        if strings[string].lowercased().hasPrefix(query.lowercased()) {
                                            ZStack {
                                                Rectangle()
                                                    .frame(minHeight: 50)
                                                    .opacity((string % 2 == 0) ? 0.03 : 0)
                                                    .cornerRadius(6)
                                                HStack(alignment: .center, spacing: 15) {
                                                    if strings[string] == highlighting {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .opacity(0.2)
                                                            .onTapGesture {
                                                                withAnimation {
                                                                    data.translations.indices.forEach { index in
                                                                        data.translations[index].texts.removeValue(forKey: strings[string])
                                                                    }
                                                                    Storage(status: $status, progress: $progress).write(
                                                                        status: status,
                                                                        selection: selection,
                                                                        data: data
                                                                    )
                                                                }
                                                            }
                                                    }
                                                    Text("1")
                                                        .fontWeight(.light)
                                                        .opacity(0.5)
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
                                                    Spacer()
                                                    ZStack {
                                                        if data.translations[index].texts[strings[string]]!.pinned {
                                                            Image(systemName: "pin.fill")
                                                                .foregroundColor(data.styles.color)
                                                        } else if strings[string] == highlighting {
                                                            Image(systemName: "pin.fill")
                                                                .opacity(0.2)
                                                        }
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
                                                withAnimation {
                                                    if hovering {
                                                        self.highlighting = strings[string]
                                                    } else {
                                                        self.highlighting = ""
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 10)
                    }
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Divider()
                ZStack {
                    Rectangle()
                        .opacity(0)
                        .background(VisualEffect())
                        .frame(height: 55)
                    HStack {
                        TextField("Add unique string", text: $entry)
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
                }
            }
        }
        .navigationTitle(selection + ".localproj")
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Rectangle()
                                .foregroundColor(.accentColor)
                                .frame(width: 320 * self.progress, height: 1.5)
                            Spacer()
                        }
                        .frame(width: 320, height: 1.5)
                    }
                    .frame(width: 320, height: 27)
                    .mask(Rectangle().frame(width: 320, height: 27).cornerRadius(5))
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
                    .background(Color("StatusColor"))
                    .cornerRadius(5)
                    .frame(width: 320)
                    .help("View project changelog, and revert to a previous version")
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
                .disabled(selection == "") // DISABLE IF THERE ARE NO STRINGS OR BASE/TARGET LANGUAGE IS NOT VALID FOR TRANSLATION
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
                .disabled(selection == "")
                .help("Import strings from an Xcode project folder")
                Button(action: {
                    Coder(data: $data, status: $status, progress: $progress).encode()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(selection == "")
                .help("Export strings and translations for targeted languages, as .strings files")
            }
        }
    }
    
}
