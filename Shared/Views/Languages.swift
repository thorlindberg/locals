import SwiftUI

struct Languages: View {

    @Binding var document: Document
    
    var body: some View {
        List {
            if document.data.toggles.editing {
                HStack {
                    Text("Base")
                    Spacer()
                    Picker("", selection: Binding(
                        get: { document.data.base },
                        set: { document.data.base = $0 }
                    )) {
                        ForEach(document.data.translations, id: \.self) { translations in
                            Text("\(translations.language)").tag(translations.language)
                        }
                    }
                }
                Divider()
                HStack {
                    if document.data.translations.allSatisfy({$0.target}) {
                        Text("Unselect all languages")
                            .foregroundColor(document.data.styles.color)
                    } else {
                        Text("Select all languages")
                    }
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { document.data.translations.allSatisfy({$0.target}) },
                        set: { _,_ in
                            if document.data.translations.allSatisfy({$0.target}) {
                                document.data.translations.indices.forEach { index in
                                    if index != 0 {
                                        document.data.translations[index].target = false
                                    }
                                }
                            } else {
                                document.data.translations.indices.forEach { index in
                                    document.data.translations[index].target = true
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
            ForEach(document.data.translations.indices, id: \.self) { index in
                if document.data.translations[index].language.lowercased().hasPrefix(document.data.fields.language.lowercased()) {
                    if document.data.toggles.editing {
                        HStack {
                            if document.data.translations[index].target {
                                Text("\(document.data.translations[index].language)")
                                    .foregroundColor(document.data.styles.color)
                            } else {
                                Text("\(document.data.translations[index].language)")
                            }
                            Spacer()
                            Toggle(isOn: Binding(
                                get: { document.data.translations[index].target },
                                set: { document.data.translations[index].target = $0 }
                            )) {
                                Text("")
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            .disabled(document.data.translations[index].target && document.data.translations.filter({$0.target}).count == 1)
                            .accentColor(document.data.styles.color)
                        }
                    } else {
                        if document.data.translations[index].target {
                            NavigationLink(destination: Editor(document: $document), tag: document.data.translations[index].language,
                            selection: Binding(get: { document.data.target }, set: { if $0 != nil { document.data.target = $0! } })
                            ) {
                                Text("\(document.data.translations[index].language)")
                            }
                            .frame(height: 20)
                            .contextMenu {
                                Button(action: {
                                    document.data.translations[index].target = false
                                }) {
                                    Text("Disable target")
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear {
            if document.data.target == "" && document.data.translations.filter({$0.target}).count != 0 {
                document.data.target = document.data.translations.filter({$0.target})[0].language
            }
        }
        .accentColor(document.data.styles.color)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Spacer()
                Toggle(isOn: $document.data.toggles.editing) {
                    Text(document.data.toggles.editing ? "Save" : "Edit")
                        .foregroundColor(document.data.toggles.editing ? document.data.styles.color : nil)
                }
                .help(document.data.toggles.editing ? "Save languages" : "Edit languages")
            }
        }
    }
    
}
