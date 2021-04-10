import SwiftUI

struct Storage {
    
    @Binding var status: [String]
    @Binding var progress: CGFloat
    
    let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    struct Format: Hashable {
        
        var base: String
        var target: String
        var filters: Filters
        var styles: Styles
        var translations: [Translations]
        
        struct Filters: Hashable {
            var singleline: Bool
            var multiline: Bool
            var parenthesis: Bool
            var nummerical: Bool
            var symbols: Bool
        }
        
        struct Styles: Hashable {
            var font: String
            var size: CGFloat
            var weight: Font.Weight
            var color: Color
        }
        
        struct Translations: Hashable {
            let id: String
            let language: String
            let abbreviation: String
            let request: String
            var target: Bool
            var texts: [String: Text]
        }
        
        struct Text: Hashable {
            var translation: String
            var pinned: Bool
        }
        
    }
    
    var data = Format(
        base: "English (United Kingdom)",
        target: "",
        filters: Format.Filters(
            singleline: true,
            multiline: true,
            parenthesis: true,
            nummerical: true,
            symbols: true
        ),
        styles: Format.Styles(
            font: "San Francisco",
            size: CGFloat(14),
            weight: Font.Weight.regular,
            color: Color.accentColor),
        translations: [
            Format.Translations(
                id: "1",
                language: "English (United Kingdom)",
                abbreviation: "(en-GB)",
                request: "en",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "2",
                language: "English (Australia)",
                abbreviation: "(en-AU)",
                request: "en",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "3",
                language: "English (India)",
                abbreviation: "(en-IN)",
                request: "en",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "4",
                language: "Chinese Simplified",
                abbreviation: "(zh-Hans)",
                request: "zh",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "5",
                language: "Chinese Traditional",
                abbreviation: "(zh-Hant)",
                request: "zh",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "6",
                language: "Chinese (Hong Kong)",
                abbreviation: "(zh-HK)",
                request: "zh",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "7",
                language: "Japanese",
                abbreviation: "(ja)",
                request: "ja",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "8",
                language: "Spanish",
                abbreviation: "(es)",
                request: "",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "9",
                language: "Spanish (Latin America)",
                abbreviation: "(es-419)",
                request: "es",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "10",
                language: "French",
                abbreviation: "(fr)",
                request: "fr",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "11",
                language: "French (Canada)",
                abbreviation: "(fr-CA)",
                request: "fr",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "12",
                language: "German",
                abbreviation: "(de)",
                request: "de",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "13",
                language: "Russian",
                abbreviation: "(ru)",
                request: "ru",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "14",
                language: "Portuguese (Brazil)",
                abbreviation: "(pt-BR)",
                request: "pt",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "15",
                language: "Portuguese (Portugal)",
                abbreviation: "(pt-PT)",
                request: "pt",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "16",
                language: "Italian",
                abbreviation: "(it)",
                request: "it",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "17",
                language: "Korean",
                abbreviation: "(ko)",
                request: "ko",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "18",
                language: "Turkish",
                abbreviation: "(tr)",
                request: "tr",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "19",
                language: "Dutch",
                abbreviation: "(nl)",
                request: "næ",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "20",
                language: "Arabic",
                abbreviation: "(ar)",
                request: "ar",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "21",
                language: "Thai",
                abbreviation: "(th)",
                request: "th",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "22",
                language: "Swedish",
                abbreviation: "(sv)",
                request: "sv",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "23",
                language: "Danish",
                abbreviation: "(da)",
                request: "da",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "24",
                language: "Vietnamese",
                abbreviation: "(vi)",
                request: "vi",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "25",
                language: "Norwegian Bokmål",
                abbreviation: "(nb)",
                request: "no",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "26",
                language: "Polish",
                abbreviation: "(pl)",
                request: "pl",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "27",
                language: "Finnish",
                abbreviation: "(fi)",
                request: "fi",
                target: true,
                texts: [:]
            ),
            Format.Translations(
                id: "28",
                language: "Indonesian",
                abbreviation: "(id)",
                request: "id",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "29",
                language: "Hebrew",
                abbreviation: "(he)",
                request: "iw",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "30",
                language: "Greek",
                abbreviation: "(el)",
                request: "el",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "31",
                language: "Romanian",
                abbreviation: "(ro)",
                request: "ro",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "32",
                language: "Hungarian",
                abbreviation: "(hu)",
                request: "hu",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "33",
                language: "Czech",
                abbreviation: "(cs)",
                request: "cs",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "34",
                language: "Catalan",
                abbreviation: "(ca)",
                request: "ca",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "35",
                language: "Slovak",
                abbreviation: "(sk)",
                request: "sk",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "36",
                language: "Ukranian",
                abbreviation: "(uk)",
                request: "uk",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "37",
                language: "Croatian",
                abbreviation: "(hr)",
                request: "hr",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "38",
                language: "Malay",
                abbreviation: "(ms)",
                request: "ms",
                target: false,
                texts: [:]
            ),
            Format.Translations(
                id: "39",
                language: "Hindi",
                abbreviation: "(hi)",
                request: "hi",
                target: false,
                texts: [:]
            )
        ]
    )
    
    func identify(status: [String]) -> Array<String> {
     
        var identified: [String] = []
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) // MAY FAIL IF DOCUMENTS FOLDER DOESN'T EXIST / WAS DELETED BY USER
            files.forEach { file in
                let project = file.absoluteString.components(separatedBy: "/").last
                if project!.components(separatedBy: ".").last == "localproj" {
                    identified.append(project!.replacingOccurrences(of: ".localproj", with: "").replacingOccurrences(of: "%20", with: " "))  // CURRENTLY REPLACES %20 WITH SPACE
                }
            }
        } catch {
            Progress(status: $status, progress: $progress).log(string: "Failed to identify projects")
            return identified
        }
        
        Progress(status: $status, progress: $progress).log(string: "Identified projects")
        return identified
    
    }
    
    func rename(status: [String], selection: String, rename: String) {
        
        let current = self.folder.appendingPathComponent(selection + ".localproj").path
        let new = self.folder.appendingPathComponent(rename + ".localproj").path
        
        do {
            try FileManager.default.moveItem(atPath: current, toPath: new)
            Progress(status: $status, progress: $progress).load(string: "Project \"\(selection)\" renamed to \"\(rename)\"")
        } catch {
            Progress(status: $status, progress: $progress).load(string: "Unable to rename the project")
        }
        
    }
    
    func read(status: [String], selection: String) -> Format {
        
        var baseData = self.data
        
        do {
            
            let project = URL(string: self.folder.absoluteString + selection.replacingOccurrences(of: " ", with: "%20") + ".localproj") // CURRENTLY REPLACES SPACE WITH %20
            let savedData = try Data(contentsOf: project!)
            let savedString = String(data: savedData, encoding: .utf8)
            let savedArray = savedString!.components(separatedBy: " ; ")
            
            var targets: [String] = []
            
            savedArray.forEach { line in
                
                let line = line.components(separatedBy: " : ")
                
                if "base" == line[0] {
                    
                    // "base" : language ;
                    baseData.base = line[1]
                    
                } else if "targets" == line[0] && line[1] != "_" {
                    
                    // "targets" : language , language , language ;
                    line[1].components(separatedBy: " , ").forEach { target in
                        targets.append(target)
                    }
                    
                } else if "filters" == line[0] {
                    
                    // "filters" : singleline : multiline : parenthesis : nummerical : symbols ;
                    baseData.filters.singleline = Bool(line[1])!
                    baseData.filters.multiline = Bool(line[2])!
                    baseData.filters.parenthesis = Bool(line[3])!
                    baseData.filters.nummerical = Bool(line[4])!
                    baseData.filters.symbols = Bool(line[5])!
                    
                } else if "styles" == line[0] {
                    
                    // "styles" : font : size : weight : color ;
                    baseData.styles.font = line[1]
                    baseData.styles.size = CGFloat(Int(line[2])!)
                    if line[3] == "Regular" { baseData.styles.weight = Font.Weight.regular }
                    if line[3] == "Heavy" { baseData.styles.weight = Font.Weight.heavy }
                    if line[3] == "Black" { baseData.styles.weight = Font.Weight.black }
                    if line[3] == "Bold" { baseData.styles.weight = Font.Weight.bold }
                    if line[3] == "Semi-bold" { baseData.styles.weight = Font.Weight.semibold }
                    if line[3] == "Medium" { baseData.styles.weight = Font.Weight.medium }
                    if line[3] == "Thin" { baseData.styles.weight = Font.Weight.thin }
                    if line[3] == "Light" { baseData.styles.weight = Font.Weight.light }
                    if line[3] == "Ultra light" { baseData.styles.weight = Font.Weight.ultraLight }
                    if line[4] == "Accent" { baseData.styles.color = Color.accentColor }
                    if line[4] == "Black" { baseData.styles.color = Color.black }
                    if line[4] == "Blue" { baseData.styles.color = Color.blue }
                    if line[4] == "Clear" { baseData.styles.color = Color.clear }
                    if line[4] == "Gray" { baseData.styles.color = Color.gray }
                    if line[4] == "Green" { baseData.styles.color = Color.green }
                    if line[4] == "Orange" { baseData.styles.color = Color.orange }
                    if line[4] == "Pink" { baseData.styles.color = Color.pink }
                    if line[4] == "Purple" { baseData.styles.color = Color.purple }
                    if line[4] == "Red" { baseData.styles.color = Color.red }
                    if line[4] == "White" { baseData.styles.color = Color.white }
                    if line[4] == "Yellow" { baseData.styles.color = Color.yellow }
                    
                } else {
                    
                    // id : pinned : string : translation ;
                    self.data.translations.indices.forEach { index in
                        if targets.contains(self.data.translations[index].language) {
                            baseData.translations[index].target = true
                        }
                        if self.data.translations[index].id == line[0] {
                            if "_" == line[3] {
                                baseData.translations[index].texts[line[2].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";")] = Format.Text(
                                    translation: "",
                                    pinned: Bool(line[1])!
                                )
                            } else {
                                baseData.translations[index].texts[line[2].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";")] = Format.Text(
                                    translation: line[3].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";"),
                                    pinned: Bool(line[1])!
                                )
                            }
                        }
                    }
                    
                }
                
            }
            
            Progress(status: $status, progress: $progress).log(string: "Read project \"\(selection)\"")
            return baseData
            
        } catch {
            Progress(status: $status, progress: $progress).log(string: "Unable to read project")
            return baseData
        }
        
    }
    
    func write(status: [String], selection: String, data: Format) {
        
        var output = ""
        
        // "base" : language ;
        output += "base : " + data.base + " ; "
        
        // "targets" : language , language , language ;
        output += "targets : "
        var targets: [String] = []
        data.translations.indices.forEach { index in
            if data.translations[index].target {
                targets.append(data.translations[index].language)
            }
        }
        if targets == [] {
            output += "_"
        } else {
            output += targets.joined(separator: " , ")
        }
        output += " ; "
        
        // "filters" : singleline : multiline : parenthesis : nummerical : symbols ;
        output += "filters : "
        output += String(data.filters.singleline) + " : "
        output += String(data.filters.multiline) + " : "
        output += String(data.filters.parenthesis) + " : "
        output += String(data.filters.nummerical) + " : "
        output += String(data.filters.symbols)
        output += " ; "
        
        // "styles" : font : size : weight : color ;
        output += "styles : "
        output += data.styles.font + " : "
        output += String(Int(data.styles.size)) + " : "
        if data.styles.weight == Font.Weight.regular { output += "Regular" + " : " }
        if data.styles.weight == Font.Weight.heavy { output += "Heavy" + " : " }
        if data.styles.weight == Font.Weight.black { output += "Black" + " : " }
        if data.styles.weight == Font.Weight.bold { output += "Bold" + " : " }
        if data.styles.weight == Font.Weight.semibold { output += "Semi-bold" + " : " }
        if data.styles.weight == Font.Weight.medium { output += "Medium" + " : " }
        if data.styles.weight == Font.Weight.thin { output += "Thin" + " : " }
        if data.styles.weight == Font.Weight.light { output += "Light" + " : " }
        if data.styles.weight == Font.Weight.ultraLight { output += "Ultra light" + " : " }
        if data.styles.color == Color.accentColor { output += "Accent" }
        if data.styles.color == Color.black { output += "Black" }
        if data.styles.color == Color.blue { output += "Blue" }
        if data.styles.color == Color.clear { output += "Clear" }
        if data.styles.color == Color.gray { output += "Gray" }
        if data.styles.color == Color.green { output += "Green" }
        if data.styles.color == Color.orange { output += "Orange" }
        if data.styles.color == Color.pink { output += "Pink" }
        if data.styles.color == Color.purple { output += "Purple" }
        if data.styles.color == Color.red { output += "Red" }
        if data.styles.color == Color.white { output += "White" }
        if data.styles.color == Color.yellow { output += "Yellow" }
        output += " ; "
        
        // id : pinned : string : translation ;
        data.translations.indices.forEach { index in
            if data.translations[index].texts != [:] {
                data.translations[index].texts.keys.forEach { string in
                    output += data.translations[index].id + " : "
                    output += String(data.translations[index].texts[string]!.pinned) + " : "
                    output += string.replacingOccurrences(of: ":", with: "/:").replacingOccurrences(of: ";", with: "/;") + " : "
                    if data.translations[index].texts[string]!.translation == "" {
                        output += "_" + " ; "
                    } else {
                        output += data.translations[index].texts[string]!.translation.replacingOccurrences(of: ":", with: "/:").replacingOccurrences(of: ";", with: "/;") + " ; "
                    }
                }
            }
        }
        
        do {
            try output.dropLast(3).write(to: self.folder.appendingPathComponent(selection + ".localproj"), atomically: true, encoding: String.Encoding.utf8)
            // Progress(status: $status, progress: $progress).log(string: "Project \"\(selection)\" written to internal application storage")
        } catch {
            NSLog(error.localizedDescription)
            // Progress(status: $status, progress: $progress).log(string: "Failed to write project \"\(selection)\"")
        }
        
    }
    
    func remove(status: [String], selection: String) {
        
        do {
            let fileManager = FileManager.default
            let filePath = (self.folder.absoluteString + selection + ".localproj").replacingOccurrences(of: "file://", with: "")
            try fileManager.removeItem(atPath: filePath)
            Progress(status: $status, progress: $progress).load(string: "Project \"\(selection)\" deleted")
        }
        catch {
            Progress(status: $status, progress: $progress).load(string: "Project could not be deleted")
        }
        
    }
    
}
