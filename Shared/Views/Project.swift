import SwiftUI

struct Title: View {
    @Binding var data: Storage.Format
    var body: some View {
        if data.target != "" {
            Text("Languages")
                .fontWeight(.regular)
                .opacity(0.5)
        } else {
            Text("")
        }
    }
}

struct Project: View {

    @Binding var selection: String
    @Binding var data: Storage.Format
    
    @State var editing: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            if selection != "" {
                List {
                    Section(header: Title(data: $data)) {
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
                                    set: { data.base = $0 }
                                )) {
                                    ForEach(data.translations, id: \.self) { translations in
                                        Text("\(translations.language)").tag(translations.language)
                                    }
                                }
                            }
                            HStack {
                                if data.translations.allSatisfy({$0.target}) {
                                    Text("Select all")
                                        .foregroundColor(data.styles.color)
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
                                    }
                                )) {
                                    Text("")
                                }
                                .toggleStyle(CheckboxToggleStyle())
                            }
                            Divider()
                        }
                        ForEach(data.translations.indices, id: \.self) { index in
                            if data.translations[index].language.lowercased().hasPrefix(data.fields.language.lowercased()) {
                                if editing {
                                    HStack {
                                        if data.translations[index].target {
                                            Text("\(data.translations[index].language)")
                                                .foregroundColor(data.styles.color)
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
                                        .disabled(data.translations[index].target && data.translations.filter({$0.target}).count == 1)
                                        .accentColor(data.styles.color)
                                    }
                                } else {
                                    if data.translations[index].target {
                                        NavigationLink(destination: Editor(selection: $selection, data: $data), tag: data.translations[index].language,
                                        selection: Binding(get: { data.target }, set: { if $0 != nil { data.target = $0! } })
                                        ) {
                                            Text("\(data.translations[index].language)")
                                        }
                                        .frame(height: 20)
                                        .contextMenu {
                                            Button(action: {
                                                data.translations[index].target = false
                                                Storage(data: $data).write(selection: selection)
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
                .onAppear {
                    if data.target == "" && data.translations.filter({$0.target}).count != 0 {
                        data.target = data.translations.filter({$0.target})[0].language
                    }
                }
            } else {
                Spacer()
            }
        }
        .frame(minWidth: 230)
        .accentColor(data.styles.color)
        .navigationTitle(selection == "" ? "Locals" : "\(selection).localproj")
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    if editing {
                        Storage(data: $data).write(selection: selection)
                    }
                    withAnimation {
                        self.editing.toggle()
                    }
                }) {
                    Text(editing ? "Save" : "Edit")
                        .foregroundColor(editing ? data.styles.color : nil)
                }
                .disabled(selection == "")
            }
        }
    }
    
}
