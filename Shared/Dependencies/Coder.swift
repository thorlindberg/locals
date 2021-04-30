import SwiftUI

// Handles decoding of Xcode project folders and encoding of .strings files

struct Coder {
    
    @Binding var document: Document
    
    func decode(folder: URL, completion: @escaping ([String:[String]]) -> Void) {
        
        var singleline: [String] = []
        var multiline: [String] = []
        
        var files = [URL]()
        if let enumerator = FileManager.default.enumerator(at: folder, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                } catch {
                    print("Failed to import Xcode project")
                }
            }
        }
        files.forEach { file in
            if document.data.extensions.keys.contains(file.absoluteString.components(separatedBy: ".").last!.lowercased()) {
                if document.data.extensions[file.absoluteString.components(separatedBy: ".").last!.lowercased()]! {
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
                        print("Failed to import Xcode project")
                    }
                }
            }
        }
        print("Imported Xcode project")
        completion(["S" : singleline, "M" : multiline])
        
    }
    
    func encode(folder: URL) {
        
        document.data.translations.indices.forEach { index in
            
            if document.data.translations[index].target {
                
                let filename = document.data.translations[index].language
                var output = ""
                
                document.data.translations[index].texts.keys.forEach { string in
                    if document.data.translations[index].texts[string]!.single {
                        output += "\"\(string)\"" + " = " + "\"\(document.data.translations[index].texts[string]!.translation)\"" + ";" + "\n"
                    } else {
                        // multiline output
                    }
                }
                
                do {
                    try output.write(to: folder.appendingPathComponent(filename + ".strings"), atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print("Failed to export .strings file")
                }
                
            }
            
        }
        
        print("Exported .strings files")
        
    }
    
}
