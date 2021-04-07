import SwiftUI

struct Projects: View {
    @Binding var projects: Bool
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(0 ..< 100) { _ in
                        ZStack {
                            Rectangle()
                                .opacity(0.05)
                                .cornerRadius(10)
                                .frame(minHeight: 50)
                            HStack(spacing: 15) {
                                Text("PROJECT NAME")
                                    .foregroundColor(.accentColor)
                                Spacer()
                                Button(action: {
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
                Button(action: { // ONLY SHOW IF PROJECTS ARE OPENED FROM SIDEBAR
                    self.projects.toggle()
                }) {
                    Text("Cancel")
                }
                TextField("Unique project name", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    self.projects.toggle()
                }) {
                    Text("Create")
                }
            }
            .padding()
        }
    }
}
