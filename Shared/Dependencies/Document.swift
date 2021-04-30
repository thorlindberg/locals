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
        var tooltip: String
        var toggles: Toggles
        var fields: Fields
        var filters: Filters
        var styles: Styles
        var extensions: [String:Bool]
        var translations: [Translations]
        
        struct Toggles: Hashable {
            var intro: Bool
            var alerts: Bool
            var popover: Bool
            var editing: Bool
            var alert: Bool
            var importing: Bool
            var exporting: Bool
            var dropping: Bool
        }
        
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
    
    // tell the system which file type to support
    static var readableContentTypes = [UTType.localproj]

    // by default our document is empty
    var data = Format(
        base: "English (United Kingdom)",
        target: "",
        tooltip: "",
        toggles: Format.Toggles(
            intro: !UserDefaults.standard.bool(forKey: "hasLaunchedBefore"), alerts: !UserDefaults.standard.bool(forKey: "hasLaunchedBefore"),
            popover: false, editing: false, alert: false, importing: false, exporting: false, dropping: false
        ),
        fields: Format.Fields(query: "", entry: "", rename: "", language: ""),
        filters: Format.Filters(unpinned: true, singleline: true, multiline: true, parenthesis: true, nummerical: true, symbols: true),
        styles: Format.Styles(font: "San Francisco", size: CGFloat(14), weight: Font.Weight.regular, color: Color.orange, vibrancy: 1),
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

    init() {
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let text = configuration.file.regularFileContents {
            
            let savedString = String(decoding: text, as: UTF8.self)
            let savedArray = savedString.components(separatedBy: " ; ")
            
            var targets: [String] = []
            
            savedArray.forEach { line in
                
                let line = line.components(separatedBy: " : ")
                
                switch line[0] {
                
                case "base":
                    
                    // "base" : language ;
                    data.base = line[1]
                
                case "alerts":
                    
                    // "alerts" : Bool ;
                    data.toggles.alerts = Bool(line[1])!
                
                case "targets":
                    
                    // "targets" : language , language , language ;
                    line[1].components(separatedBy: " , ").forEach { target in
                        targets.append(target)
                    }
                
                case "filters":
                    
                    // "filters" : unpinned : singleline : multiline : parenthesis : nummerical : symbols ;
                    data.filters.unpinned = Bool(line[1])!
                    data.filters.singleline = Bool(line[2])!
                    data.filters.multiline = Bool(line[3])!
                    data.filters.parenthesis = Bool(line[4])!
                    data.filters.nummerical = Bool(line[5])!
                    data.filters.symbols = Bool(line[6])!
                
                case "styles":
                    
                    // "styles" : font : size : weight : color : vibrancy ;
                    data.styles.font = line[1]
                    data.styles.size = CGFloat(Int(line[2])!)
                    if line[3] == "Regular" { data.styles.weight = Font.Weight.regular }
                    if line[3] == "Heavy" { data.styles.weight = Font.Weight.heavy }
                    if line[3] == "Black" { data.styles.weight = Font.Weight.black }
                    if line[3] == "Bold" { data.styles.weight = Font.Weight.bold }
                    if line[3] == "Semi-bold" { data.styles.weight = Font.Weight.semibold }
                    if line[3] == "Medium" { data.styles.weight = Font.Weight.medium }
                    if line[3] == "Thin" { data.styles.weight = Font.Weight.thin }
                    if line[3] == "Light" { data.styles.weight = Font.Weight.light }
                    if line[3] == "Ultra light" { data.styles.weight = Font.Weight.ultraLight }
                    if line[4] == "Accent" { data.styles.color = Color.accentColor }
                    if line[4] == "Blue" { data.styles.color = Color.blue }
                    if line[4] == "Gray" { data.styles.color = Color.gray }
                    if line[4] == "Green" { data.styles.color = Color.green }
                    if line[4] == "Orange" { data.styles.color = Color.orange }
                    if line[4] == "Pink" { data.styles.color = Color.pink }
                    if line[4] == "Purple" { data.styles.color = Color.purple }
                    if line[4] == "Red" { data.styles.color = Color.red }
                    if line[4] == "Yellow" { data.styles.color = Color.yellow }
                    data.styles.vibrancy = Int(line[5])!
                
                case "extension":
                    
                    // "extension" : extension : bool ;
                    data.extensions[line[1]] = Bool(line[2])
                
                default:
                    
                    // id : pinned : string : translation : order ;
                    data.translations.indices.forEach { index in
                        if targets.contains(data.translations[index].language) {
                            data.translations[index].target = true
                        } else {
                            data.translations[index].target = false
                        }
                        if data.translations[index].id == line[0] {
                            if "_" == line[3] {
                                data.translations[index].texts[line[2].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";")] = Format.Text(
                                    order: Int(line[4])!,
                                    translation: "",
                                    pinned: Bool(line[1])!,
                                    single: true,
                                    multi: false
                                )
                            } else {
                                data.translations[index].texts[line[2].replacingOccurrences(of: "/:", with: ":").replacingOccurrences(of: "/;", with: ";")] = Format.Text(
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
            
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        var output = ""
        
        // "base" : language ;
        output += "base : " + data.base + " ; "
        
        // "alerts" : Bool ;
        output += "alerts : " + String(data.toggles.alerts) + " ; "
        
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
        
        return FileWrapper(regularFileWithContents: Data(output.dropLast(3).utf8))
        
    }
    
}
