import SwiftUI

// Translates strings by querying Libre Translate API

struct Translation {
    
    @Binding var status: [String]
    @Binding var progress: CGFloat
    @Binding var data: Storage.Format
    
    func translate() {
        
        let base: String = data.translations.filter{$0.language == data.base}[0].request
        let target: String = data.translations.filter{$0.language == data.target}[0].request
        data.translations.indices.forEach { index in
            if data.translations[index].language == data.target {
                data.translations[index].texts.keys.forEach { string in
                    if data.translations[index].texts[string]!.translation == "" {
                        query(base: base, target: target, string: string) { translation in
                            data.translations[index].texts[string] = Storage.Format.Text(translation: translation, pinned: data.translations[index].texts[string]!.pinned)
                        }
                    }
                }
            }
        }
        
    }
    
    func query(base: String, target: String, string: String, completion: @escaping (String) -> Void) {
        
        // LibreTranslate @ https://github.com/uav4geo/LibreTranslate
        
        let body: [String: String] = ["q": string, "source": base, "target": target]
        
        do {
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let url = URL(string: "https://libretranslate.com/translate")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.httpBody = bodyData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil { Progress(status: $status, progress: $progress).load(string: "Failed to translate string") ; return }
                
                DispatchQueue.main.async {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data!)
                        if let responseJSON = responseJSON as? [String: Any],
                            let result = responseJSON["translatedText"] as? String {
                            if result.last == "." && string.last != "." {
                                completion(String(result.dropLast()))
                                Progress(status: $status, progress: $progress).load(string: "Translated \"\(string)\" to \"\(String(result.dropLast()))\"")
                            } else {
                                completion(result)
                                Progress(status: $status, progress: $progress).load(string: "Translated \"\(string)\" to \"\(result)\"")
                            }
                        } else {
                            Progress(status: $status, progress: $progress).load(string: "Failed to translate \"\(string)\"")
                        }
                    } catch {
                        Progress(status: $status, progress: $progress).load(string: "Failed to translate \"\(string)\"")
                    }
                }
            }
            .resume()
            
        } catch {
            Progress(status: $status, progress: $progress).load(string: "Failed to translate \"\(string)\"")
        }
        
    }
}
