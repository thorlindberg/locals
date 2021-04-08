import SwiftUI

struct Header: View {
    @Binding var data: Storage.Format
    var body: some View {
        if data.target != "" {
            Text("\(data.base) to \(data.target)")
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
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            List {
                Section(header: Header(data: $data)) {
                    VStack(spacing: 15) {
                        ForEach(data.translations.indices, id: \.self) { index in
                            if data.translations[index].language == data.target {
                                let strings = Array(data.translations[index].texts.keys)
                                    .sorted { data.translations[index].texts[$0]!.pinned == true && data.translations[index].texts[$1]!.pinned == false }
                                ForEach(strings, id: \.self) { string in
                                    if string.lowercased().hasPrefix(query.lowercased()) {
                                        ZStack {
                                            Rectangle()
                                                .opacity(0.07)
                                                .cornerRadius(10)
                                                .frame(minHeight: 50)
                                            HStack(alignment: .top, spacing: 15) {
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
                }
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
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
            }
            ToolbarItemGroup(placement: .automatic) {
                ZStack {
                    TextField("Unique string", text: $entry)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 180)
                        .disabled(selection == "" || data.target == "")
                        .help("Add a unique string for translation")
                    if entry != "" {
                        HStack {
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
                    }
                }
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
