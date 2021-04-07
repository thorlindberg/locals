import SwiftUI

struct Projects: View {
    
    @Binding var toggle: String
    @Binding var projects: Bool
    @Binding var selection: String
    @Binding var status: [String]
    @Binding var progress: CGFloat
    @Binding var data: Storage.Format
    @Binding var query: String
    @Binding var entry: String
    @Binding var inspector: Bool
    
    @State var files: [String] = []
    @State var filename: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(files, id: \.self) { file in
                        ZStack {
                            Rectangle()
                                .opacity(0.05)
                                .cornerRadius(10)
                                .frame(minHeight: 50)
                            HStack(spacing: 15) {
                                Text("\(file)")
                                    .foregroundColor(.accentColor)
                                Spacer()
                                Button(action: {
                                    self.selection = file
                                    self.data = Storage(status: $status, progress: $progress).read(status: status, selection: file)
                                    self.toggle = "languages"
                                    self.projects.toggle()
                                }) {
                                    Text("Open")
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding()
                Spacer()
            }
            Divider()
            HStack(spacing: 0) {
                if selection != "" {
                    Button(action: {
                        self.toggle = "languages"
                        self.projects.toggle()
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing)
                    .keyboardShortcut(.escape)
                }
                TextField("Unique project name", text: $filename)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.selection = filename
                    self.filename = ""
                    Storage(status: $status, progress: $progress).write(
                        status: status,
                        selection: selection,
                        data: Storage(status: $status, progress: $progress).data
                    )
                    self.data = Storage(status: $status, progress: $progress).read(status: status, selection: selection)
                    self.toggle = "languages"
                    self.projects.toggle()
                }) {
                    Text("Create")
                }
                .keyboardShortcut(.defaultAction)
                .disabled(files.contains(filename) || filename == "" || filename.hasPrefix("."))
                .padding(.leading)
            }
            .padding()
        }
        .onAppear {
            self.files = Storage(status: $status, progress: $progress).identify(status: status)
        }
    }
    
}
