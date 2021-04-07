import SwiftUI

struct Editor: View {
    
    @Binding var selection: String
    @Binding var status: [String]
    @Binding var progress: CGFloat
    @Binding var data: Storage.Format
    @Binding var query: String
    @Binding var entry: String
    @Binding var inspector: Bool
    
    @State var rename: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                if data.target == "" {
                    Rectangle()
                        .opacity(0)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(data.translations.indices, id: \.self) { index in
                                if data.translations[index].language == data.target {
                                    let strings = Array(data.translations[index].texts.keys)
                                        .sorted { data.translations[index].texts[$0]!.pinned == true && data.translations[index].texts[$1]!.pinned == false }
                                    ForEach(strings, id: \.self) { string in
                                        if string.lowercased().hasPrefix(query.lowercased()) {
                                            ZStack {
                                                Rectangle()
                                                    .foregroundColor(Color("ModeColor"))
                                                    .cornerRadius(10)
                                                    .frame(minHeight: 50)
                                                HStack(spacing: 15) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .opacity(0.2)
                                                        .onTapGesture {
                                                            withAnimation {
                                                                data.translations.indices.forEach { index in
                                                                    data.translations[index].texts.removeValue(forKey: string)
                                                                }
                                                                Storage(status: $status, progress: $progress).write(
                                                                    status: status,
                                                                    selection: selection,
                                                                    data: data
                                                                )
                                                            }
                                                        }
                                                    Text("\(string)")
                                                        .foregroundColor(.accentColor)
                                                    Divider()
                                                    TextField("Translation", text: Binding(
                                                        get: { data.translations[index].texts[string]!.translation },
                                                        set: { data.translations[index].texts[string]?.translation = $0 }
                                                    ), onCommit: { withAnimation { Storage(status: $status, progress: $progress).write(
                                                        status: status,
                                                        selection: selection,
                                                        data: data
                                                    )}})
                                                    .textFieldStyle(PlainTextFieldStyle())
                                                    Spacer()
                                                    ZStack {
                                                        if data.translations[index].texts[string]!.pinned {
                                                            Image(systemName: "pin.fill")
                                                                .foregroundColor(.accentColor)
                                                        } else {
                                                            Image(systemName: "pin.fill")
                                                                .opacity(0.2)
                                                        }
                                                    }
                                                    .onTapGesture {
                                                        withAnimation {
                                                            data.translations.indices.forEach { index in
                                                                data.translations[index].texts[string]!.pinned = !data.translations[index].texts[string]!.pinned
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
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                if inspector {
                    Divider()
                    List {
                        Section(header: Text("Translations")) {
                            HStack {
                                Text("Export project")
                                Spacer()
                                Button(action: {
                                    Coder(data: $data, status: $status, progress: $progress).encode()
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .help("Export strings and translations for targeted languages, as .strings files")
                            }
                            HStack {
                                TextField("Unique string", text: $entry)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 120)
                                    .help("Add a unique string for translation")
                                Spacer()
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
                                .disabled(entry == "" || data.translations.filter{$0.language == data.target}[0].texts.keys.contains(entry))
                            }
                            HStack {
                                Text("Import Xcode folder")
                                Spacer()
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
                            }
                            HStack {
                                Text("Auto-translate")
                                Spacer()
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
                        }
                        Divider()
                        Section(header: Text("Project information")) {
                            Picker("Base", selection: Binding(
                                get: { data.base },
                                set: { data.base = $0 }
                            )) {
                                ForEach(data.translations, id: \.self) { translations in
                                    Text("\(translations.language)").tag(translations.language)
                                }
                            }
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        Storage(status: $status, progress: $progress).remove(
                                            status: status,
                                            selection: selection
                                        )
                                    }
                                }) {
                                    Text("Delete")
                                }
                                Spacer()
                                Button(action: {
                                    if data.translations.allSatisfy({ $0.target }) {
                                        data.translations.indices.forEach { index in
                                            data.translations[index].target = false
                                        }
                                    } else {
                                        data.translations.indices.forEach { index in
                                            data.translations[index].target = true
                                        }
                                    }
                                }) {
                                    if data.translations.allSatisfy { $0.target } {
                                        Text("Unselect all")
                                            .foregroundColor(.accentColor)
                                    } else {
                                        Text("Select all")
                                    }
                                }
                            }
                            ForEach(data.translations.indices, id: \.self) { index in
                                if data.base != data.translations[index].language {
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
                                            set: { data.translations[index].target = $0 }
                                        )) {
                                            Text("")
                                        }
                                        .toggleStyle(CheckboxToggleStyle())
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: 230)
                }
            }
        }
        .navigationTitle("\(selection).localproj")
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
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
                .frame(width: 320)
                .cornerRadius(5)
                .help("View project changelog, and revert to a previous version")
                TextField("􀊫 Search", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 170)
                Toggle(isOn: $inspector) {
                    Image(systemName: "rectangle.rightthird.inset.fill")
                }
            }
        }
    }
    
}
