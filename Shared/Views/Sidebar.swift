import SwiftUI

struct Sidebar: View {
    
    @Binding var toggle: String
    @Binding var projects: Bool
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
                if toggle == "languages" {
                    Image(systemName: "textformat.alt")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "textformat.alt")
                        .onTapGesture {
                            withAnimation {
                                self.toggle = "languages"
                            }
                        }
                }
                Spacer()
                if toggle == "editing" {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "slider.horizontal.3")
                        .onTapGesture {
                            withAnimation {
                                self.toggle = "editing"
                            }
                        }
                }
                Spacer()
                if toggle == "process" {
                    Image(systemName: "slider.horizontal.below.square.fill.and.square")
                        .foregroundColor(.accentColor)
                        .help("Process translations")
                } else {
                    Image(systemName: "slider.horizontal.below.square.fill.and.square")
                        .onTapGesture {
                            withAnimation {
                                self.toggle = "process"
                            }
                        }
                }
                Spacer()
                if toggle == "project" {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "info.circle")
                        .onTapGesture {
                            withAnimation {
                                self.toggle = "project"
                            }
                        }
                }
                Spacer()
                if toggle == "files" {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "folder")
                        .onTapGesture {
                            withAnimation {
                                self.toggle = "files"
                                self.projects.toggle()
                            }
                        }
                }
            }
            .frame(height: 27)
            .padding(.horizontal)
            Divider()
                .padding(.bottom)
            List {
                if toggle == "languages" {
                    ForEach(data.translations.indices, id: \.self) { index in
                        if data.base != data.translations[index].language {
                            if data.translations[index].target {
                                NavigationLink(destination:
                                    Editor(selection: $selection, status: $status, progress: $progress, data: $data,
                                           query: $query, entry: $entry, inspector: $inspector),
                                    tag: data.translations[index].language,
                                    selection: Binding(
                                        get: { data.target },
                                        set: { if $0 != nil { data.target = $0! } }
                                    )
                                ) {
                                    Text("\(data.translations[index].language)")
                                }
                                .frame(height: 20)
                            }
                        }
                    }
                }
                if toggle == "editing" {
                    Button(action: { // CURRENTLY SELECTS BASE LANGUAGE, WHICH IT SHOULD NOT!!!
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
                if toggle == "process" {
                    TextField("􀊫 Search", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 160)
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
                if toggle == "project" {
                    Picker("Base", selection: Binding(
                        get: { data.base },
                        set: { data.base = $0 }
                    )) {
                        ForEach(data.translations, id: \.self) { translations in
                            Text("\(translations.language)").tag(translations.language)
                        }
                    }
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
                }
            }
            .listStyle(SidebarListStyle())
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "rectangle.leftthird.inset.fill")
                }
            }
        }
    }
    
}
