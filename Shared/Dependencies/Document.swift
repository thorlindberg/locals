import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var localproj: UTType {
        UTType.types(tag: "localproj", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}

struct Document: FileDocument {
    // data structure
    struct Format: Hashable {
        
        var base: String
        var target: String
        var alerts: Bool
        var fields: Fields
        var filters: Filters
        var styles: Styles
        var extensions: [String:Bool]
        var translations: [Translations]
        
        struct Fields: Hashable {
            var query: String
            var entry: String
            var rename: String
            var language: String
        }
        
        struct Filters: Hashable {
            var unpinned: Bool
            var singleline: Bool
            var multiline: Bool
            var parenthesis: Bool
            var nummerical: Bool
            var symbols: Bool
        }
        
        struct Styles: Hashable {
            var columns: Int
            var font: String
            var size: CGFloat
            var weight: Font.Weight
            var color: Color
            var vibrancy: Int
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
            var order: Int
            var translation: String
            var pinned: Bool
            var single: Bool
            var multi: Bool
        }
        
    }
    
    var data = Format(
        base: "English (United Kingdom)",
        target: "Japanese",
        alerts: !UserDefaults.standard.bool(forKey: "hasLaunchedBefore"),
        fields: Format.Fields(query: "", entry: "", rename: "", language: ""),
        filters: Format.Filters(unpinned: true, singleline: true, multiline: true, parenthesis: true, nummerical: true, symbols: true),
        styles: Format.Styles(columns: 3, font: "San Francisco", size: CGFloat(14), weight: Font.Weight.regular, color: Color.orange, vibrancy: 1),
        extensions: ["swift" : true, "h" : true, "m" : true],
        translations: [
            Format.Translations(id: "1", language: "English (United Kingdom)", abbreviation: "(en-GB)", request: "en", target: false, texts: [:]),
            Format.Translations(id: "2", language: "English (Australia)", abbreviation: "(en-AU)", request: "en", target: false, texts: [:]),
            Format.Translations(id: "3", language: "English (India)", abbreviation: "(en-IN)", request: "en", target: false, texts: [:]),
            Format.Translations(id: "4", language: "Chinese Simplified", abbreviation: "(zh-Hans)", request: "zh", target: false, texts: [:]),
            Format.Translations(id: "5", language: "Chinese Traditional", abbreviation: "(zh-Hant)", request: "zh", target: false, texts: [:]),
            Format.Translations(id: "6", language: "Chinese (Hong Kong)", abbreviation: "(zh-HK)", request: "zh", target: false, texts: [:]),
            Format.Translations(id: "7", language: "Japanese", abbreviation: "(ja)", request: "ja", target: true, texts: [:]),
            Format.Translations(id: "8", language: "Spanish", abbreviation: "(es)", request: "", target: true, texts: [:]),
            Format.Translations(id: "9", language: "Spanish (Latin America)", abbreviation: "(es-419)", request: "es", target: false, texts: [:]),
            Format.Translations(id: "10", language: "French", abbreviation: "(fr)", request: "fr", target: true, texts: [:]),
            Format.Translations(id: "11", language: "French (Canada)", abbreviation: "(fr-CA)", request: "fr", target: false, texts: [:]),
            Format.Translations(id: "12", language: "German", abbreviation: "(de)", request: "de", target: true, texts: [:]),
            Format.Translations(id: "13", language: "Russian", abbreviation: "(ru)", request: "ru", target: false, texts: [:]),
            Format.Translations(id: "14", language: "Portuguese (Brazil)", abbreviation: "(pt-BR)", request: "pt", target: false, texts: [:]),
            Format.Translations(id: "15", language: "Portuguese (Portugal)", abbreviation: "(pt-PT)", request: "pt", target: false, texts: [:]),
            Format.Translations(id: "16", language: "Italian", abbreviation: "(it)", request: "it", target: true, texts: [:]),
            Format.Translations(id: "17", language: "Korean", abbreviation: "(ko)", request: "ko", target: false, texts: [:]),
            Format.Translations(id: "18", language: "Turkish", abbreviation: "(tr)", request: "tr", target: false, texts: [:]),
            Format.Translations(id: "19", language: "Dutch", abbreviation: "(nl)", request: "næ", target: false, texts: [:]),
            Format.Translations(id: "20", language: "Arabic", abbreviation: "(ar)", request: "ar", target: false, texts: [:]),
            Format.Translations(id: "21", language: "Thai", abbreviation: "(th)", request: "th", target: false, texts: [:]),
            Format.Translations(id: "22", language: "Swedish", abbreviation: "(sv)", request: "sv", target: true, texts: [:]),
            Format.Translations(id: "23", language: "Danish", abbreviation: "(da)", request: "da", target: true, texts: [:]),
            Format.Translations(id: "24", language: "Vietnamese", abbreviation: "(vi)", request: "vi", target: false, texts: [:]),
            Format.Translations(id: "25", language: "Norwegian Bokmål", abbreviation: "(nb)", request: "no", target: true, texts: [:]),
            Format.Translations(id: "26", language: "Polish", abbreviation: "(pl)", request: "pl", target: false, texts: [:]),
            Format.Translations(id: "27", language: "Finnish", abbreviation: "(fi)", request: "fi", target: true, texts: [:]),
            Format.Translations(id: "28", language: "Indonesian", abbreviation: "(id)", request: "id", target: false, texts: [:]),
            Format.Translations(id: "29", language: "Hebrew", abbreviation: "(he)", request: "iw", target: false, texts: [:]),
            Format.Translations(id: "30", language: "Greek", abbreviation: "(el)", request: "el", target: false, texts: [:]),
            Format.Translations(id: "31", language: "Romanian", abbreviation: "(ro)", request: "ro", target: false, texts: [:]),
            Format.Translations(id: "32", language: "Hungarian", abbreviation: "(hu)", request: "hu", target: false, texts: [:]),
            Format.Translations(id: "33", language: "Czech", abbreviation: "(cs)", request: "cs", target: false, texts: [:]),
            Format.Translations(id: "34", language: "Catalan", abbreviation: "(ca)", request: "ca", target: false, texts: [:]),
            Format.Translations(id: "35", language: "Slovak", abbreviation: "(sk)", request: "sk", target: false, texts: [:]),
            Format.Translations(id: "36", language: "Ukranian", abbreviation: "(uk)", request: "uk", target: false, texts: [:]),
            Format.Translations(id: "37", language: "Croatian", abbreviation: "(hr)", request: "hr", target: false, texts: [:]),
            Format.Translations(id: "38", language: "Malay", abbreviation: "(ms)", request: "ms", target: false, texts: [:]),
            Format.Translations(id: "39", language: "Hindi", abbreviation: "(hi)", request: "hi", target: false, texts: [:])
        ]
    )
    
    func read(text: String) -> Format {
        
        var baseData = self.data
        
        do {
            
            let savedString = text
            let savedArray = savedString.components(separatedBy: " ; ")
            
            var targets: [String] = []
            
            savedArray.forEach { line in
                
                let line = line.components(separatedBy: " : ")
                
                switch line[0] {
                
                case "base":
                    
                    // "base" : language ;
                    baseData.base = line[1]
                
                case "alerts":
                    
                    // "alerts" : Bool ;
                    baseData.alerts = Bool(line[1])!
                
                case "targets":
                    
                    // "targets" : language , language , language ;
                    line[1].components(separatedBy: " , ").forEach { target in
                        targets.append(target)
                    }
                
                case "filters":
                    
                    // "filters" : unpinned : singleline : multiline : parenthesis : nummerical : symbols ;
                    baseData.filters.unpinned = Bool(line[1])!
                    baseData.filters.singleline = Bool(line[2])!
                    baseData.filters.multiline = Bool(line[3])!
                    baseData.filters.parenthesis = Bool(line[4])!
                    baseData.filters.nummerical = Bool(line[5])!
                    baseData.filters.symbols = Bool(line[6])!
                
                case "styles":
                    
                    // "styles" : columns : font : size : weight : color : vibrancy ;
                    baseData.styles.columns = Int(line[1])!
                    baseData.styles.font = line[2]
                    baseData.styles.size = CGFloat(Int(line[3])!)
                    if line[4] == "Regular" { baseData.styles.weight = Font.Weight.regular }
                    if line[4] == "Heavy" { baseData.styles.weight = Font.Weight.heavy }
                    if line[4] == "Black" { baseData.styles.weight = Font.Weight.black }
                    if line[4] == "Bold" { baseData.styles.weight = Font.Weight.bold }
                    if line[4] == "Semi-bold" { baseData.styles.weight = Font.Weight.semibold }
                    if line[4] == "Medium" { baseData.styles.weight = Font.Weight.medium }
                    if line[4] == "Thin" { baseData.styles.weight = Font.Weight.thin }
                    if line[4] == "Light" { baseData.styles.weight = Font.Weight.light }
                    if line[4] == "Ultra light" { baseData.styles.weight = Font.Weight.ultraLight }
                    if line[5] == "Accent" { baseData.styles.color = Color.accentColor }
                    if line[5] == "Blue" { baseData.styles.color = Color.blue }
                    if line[5] == "Gray" { baseData.styles.color = Color.gray }
                    if line[5] == "Green" { baseData.styles.color = Color.green }
                    if line[5] == "Orange" { baseData.styles.color = Color.orange }
                    if line[5] == "Pink" { baseData.styles.color = Color.pink }
                    if line[5] == "Purple" { baseData.styles.color = Color.purple }
                    if line[5] == "Red" { baseData.styles.color = Color.red }
                    if line[5] == "Yellow" { baseData.styles.color = Color.yellow }
                    baseData.styles.vibrancy = Int(line[6])!
                
                case "extension":
                    
                    // "extension" : extension : bool ;
                    baseData.extensions[line[1]] = Bool(line[2])
                
                default:
                    
                    // id : pinned : string : translation : order ;
                    self.data.translations.indices.forEach { index in
                        if targets.contains(self.data.translations[index].language) {
                            baseData.translations[index].target = true
                        }
                        if self.data.translations[index].id == line[0] {
                            if "_" == line[3] {
                                baseData.translations[index].texts[line[2].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";")] = Format.Text(
                                    order: Int(line[4])!,
                                    translation: "",
                                    pinned: Bool(line[1])!,
                                    single: true,
                                    multi: false
                                )
                            } else {
                                baseData.translations[index].texts[line[2].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";")] = Format.Text(
                                    order: Int(line[4])!,
                                    translation: line[3].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";"),
                                    pinned: Bool(line[1])!,
                                    single: true,
                                    multi: false
                                )
                            }
                        }
                    }
                
                }
                
            }
            
            print("Read project")
            return baseData
            
        }
        
    }
    
    func write(data: Format) -> String {
        
        var output = ""
        
        // "base" : language ;
        output += "base : " + data.base + " ; "
        
        // "alerts" : Bool ;
        output += "alerts : " + String(data.alerts) + " ; "
        
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
        
        // "filters" : unpinned : singleline : multiline : parenthesis : nummerical : symbols ;
        output += "filters : "
        output += String(data.filters.unpinned) + " : "
        output += String(data.filters.singleline) + " : "
        output += String(data.filters.multiline) + " : "
        output += String(data.filters.parenthesis) + " : "
        output += String(data.filters.nummerical) + " : "
        output += String(data.filters.symbols)
        output += " ; "
        
        // "styles" : font : size : weight : color : vibrancy ;
        output += "styles : "
        output += String(data.styles.columns) + " : "
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
        if data.styles.color == Color.accentColor { output += "Accent" + " : " }
        if data.styles.color == Color.blue { output += "Blue" + " : " }
        if data.styles.color == Color.gray { output += "Gray" + " : " }
        if data.styles.color == Color.green { output += "Green" + " : " }
        if data.styles.color == Color.orange { output += "Orange" + " : " }
        if data.styles.color == Color.pink { output += "Pink" + " : " }
        if data.styles.color == Color.purple { output += "Purple" + " : " }
        if data.styles.color == Color.red { output += "Red" + " : " }
        if data.styles.color == Color.yellow { output += "Yellow" + " : " }
        output += String(data.styles.vibrancy)
        output += " ; "
        
        // "extension" : extension : bool ;
        Array(data.extensions.keys).forEach { format in
            output += "extension : "
            output += format + " : "
            output += String(data.extensions[format]!)
            output += " ; "
        }
        
        // id : pinned : string : translation : order ;
        data.translations.indices.forEach { index in
            if data.translations[index].texts != [:] {
                data.translations[index].texts.keys.forEach { string in
                    output += data.translations[index].id + " : "
                    output += String(data.translations[index].texts[string]!.pinned) + " : "
                    output += string.replacingOccurrences(of: ":", with: "/:").replacingOccurrences(of: ";", with: "/;") + " : "
                    if data.translations[index].texts[string]!.translation == "" {
                        output += "_" + " : "
                    } else {
                        output += data.translations[index].texts[string]!.translation.replacingOccurrences(of: ":", with: "/:").replacingOccurrences(of: ";", with: "/;") + " : "
                    }
                    output += String(data.translations[index].texts[string]!.order) + " ; "
                }
            }
        }
        
        return output // .dropLast(3)
        
    }
    
    // tell the system which file type to support
    let localproj: UTType = .localproj
    static var readableContentTypes = [UTType.localproj]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
