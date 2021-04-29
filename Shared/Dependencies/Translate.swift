import SwiftUI

// Translates strings by querying LibreTranslate API

struct Translation {
    
    @Binding var document: Document
    
    func translate() {
        
        let base: String = document.data.translations.filter{$0.language == document.data.base}[0].request
        let target: String = document.data.translations.filter{$0.language == document.data.target}[0].request
        document.data.translations.indices.forEach { index in
            if document.data.translations[index].language == document.data.target {
                document.data.translations[index].texts.keys.forEach { string in
                    if document.data.translations[index].texts[string]!.translation == "" {
                        query(base: base, target: target, string: string) { translation in
                            document.data.translations[index].texts[string] = Document.Format.Text(
                                order: document.data.translations[index].texts[string]!.order,
                                translation: translation,
                                pinned: document.data.translations[index].texts[string]!.pinned,
                                single: document.data.translations[index].texts[string]!.single,
                                multi: document.data.translations[index].texts[string]!.multi
                            )
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
                if error != nil { print("Failed to translate string") ; return }
                
                DispatchQueue.main.async {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data!)
                        if let responseJSON = responseJSON as? [String: Any],
                           let result = responseJSON["translatedText"] as? String {
                            if result.last == "." && string.last != "." {
                                completion(String(result.dropLast()))
                                print("Translated \"\(string)\" to \"\(String(result.dropLast()))\"")
                            } else {
                                completion(result)
                                print("Translated \"\(string)\" to \"\(result)\"")
                            }
                        } else {
                            print("Failed to translate \"\(string)\"")
                        }
                    } catch {
                        print("Failed to translate \"\(string)\"")
                    }
                }
            }
            .resume()
            
        } catch {
            print("Failed to translate \"\(string)\"")
        }
        
    }
}
