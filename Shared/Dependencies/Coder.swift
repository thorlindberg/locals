import SwiftUI

// Handles decoding of Xcode project folders and encoding of .strings files

struct Coder {
    
    @Binding var data: Storage.Format
    
    let formats = ["swift"] // ADD CORRECT EXTENSIONS FOR VALIDATION
    
    func decode(completion: @escaping ([String:[String]]) -> Void) {
        
        var singleline: [String] = []
        var multiline: [String] = []
        
        let dialog = NSOpenPanel()
        dialog.prompt = "Choose"
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.canChooseFiles = false
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.begin {
            (result) -> Void in if result == .OK {
                do {
                    var files = [URL]()
                    if let enumerator = FileManager.default.enumerator(at: dialog.url!, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                        for case let fileURL as URL in enumerator {
                            do {
                                let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                                if fileAttributes.isRegularFile! {
                                    files.append(fileURL)
                                }
                            } catch {
                                Progress(data: $data).load(string: "Failed to import Xcode project")
                            }
                        }
                    }
                    files.forEach { file in
                        if formats.contains(file.absoluteString.components(separatedBy: ".").last!) {
                            do {
                                let savedData = try Data(contentsOf: file)
                                let savedString = String(data: savedData, encoding: .utf8)
                                // singleline
                                savedString!.components(separatedBy: "\n").forEach { line in
                                    var count = 0
                                    var index1 = 0
                                    var index2 = 0
                                    var string: String
                                    for (index, char) in line.enumerated() {
                                        if char == "\"" {
                                            count += 1
                                            if count == 1 {
                                                index1 = index
                                            }
                                            if count == 2 {
                                                index2 = index
                                                string = String(Array(line)[index1...index2]).replacingOccurrences(of: "\"", with: "")
                                                if !singleline.contains(string) && string != "" {
                                                    singleline.append(string)
                                                }
                                                count = 0
                                                string = ""
                                            }
                                        }
                                    }
                                }
                                // multiline
                                let yo = """
                                hey!
                                """
                                var count = 0
                                var index1 = 0
                                var index2 = 0
                                var string: String
                                for (index, char) in savedString!.enumerated() {
                                    if char == "\"" && Array(savedString!)[index-1] == "\"" && Array(savedString!)[index-2] == "\"" {
                                        count += 1
                                        if count == 1 {
                                            index1 = index
                                        }
                                        if count == 2 {
                                            index2 = index
                                            string = String(Array(savedString!)[index1+1...index2-3])
                                            if !multiline.contains(string) && string != "" { // NUMMERICAL-ONLY FILTER: Int(string) ?? nil == nil
                                                multiline.append(string)
                                            }
                                            count = 0
                                            string = ""
                                        }
                                    }
                                }
                            } catch {
                                Progress(data: $data).load(string: "Failed to import Xcode project")
                            }
                        }
                    }
                    Progress(data: $data).load(string: "Imported Xcode project")
                    completion(["S" : singleline, "M" : multiline])
                }
            }
        }
        
    }
    
    func encode() {
        
        // request folder selection window
        
        let dialog = NSOpenPanel()
        dialog.prompt = "Export"
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.canChooseFiles = false
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.begin {
            
            (result) -> Void in if result == .OK {
                
                let directory = dialog.url!
                
                data.translations.indices.forEach { index in
                    
                    if data.translations[index].target {
                        
                        let filename = data.translations[index].language
                        var output = ""
                        
                        data.translations[index].texts.keys.forEach { string in
                            output += "\"\(string)\"" + " = " + "\"\(data.translations[index].texts[string]!.translation)\"" + "\n"
                        }
                        
                        do {
                            try output.write(to: directory.appendingPathComponent(filename + ".strings"), atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            Progress(data: $data).load(string: "Failed to export .strings file")
                        }
                        
                    }
                    
                }
                
                Progress(data: $data).load(string: "Exported .strings files")
                
            }
        }
        
    }
    
}
