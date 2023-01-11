//
//  Reader+ViewModel.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 10/01/23.
//

import Foundation
import SwiftSoup
import AVFoundation

class ReaderViewModel: ObservableObject {
    static let shared = ReaderViewModel()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var dataTask: URLSessionDataTask?
    private init() { }
    
    @Published var isSpeeching = false
    
    func reproduceSpeech(_ contents: [String]) {
        stopSpeech()
        
        let utterance = AVSpeechUtterance(string: contents.joined(separator: "\n\n"))
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
         
        speechSynthesizer.speak(utterance)
        isSpeeching = true
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeeching = false
    }
    
    func extractArticleContents(for articleURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let request = URLRequest(url: articleURL)
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let htmlContents = String(data: data, encoding: .utf8) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let cleaned = try SwiftSoup.clean(htmlContents, .basicWithImages())!
                let dom = try SwiftSoup.parse(cleaned)
                let text = try dom.getElementsByTag("p").map { try $0.text() }.joined(separator: "\n\n")
                completion(.success(text))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask?.resume()
    }
}
