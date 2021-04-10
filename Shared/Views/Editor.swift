import SwiftUI

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
                                            HStack(alignment: .center, spacing: 15) {
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
                                                    .font(.custom(data.styles.font, size: data.styles.size))
                                                    .fontWeight(data.styles.weight)
                                                    .foregroundColor(data.styles.color)
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
        .navigationTitle(selection + ".localproj")
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
                .cornerRadius(5)
                .frame(width: 320)
                .help("View project changelog, and revert to a previous version")
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
