//
//  FeaturedItem+Model.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 24/12/22.
//

import Foundation

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsAPIArticle]
}

struct NewsAPIArticle: Codable {
    var id = UUID()
    let source: NewsAPISource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    enum CodingKeys: CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

struct NewsAPISource: Codable {
    let id: String?
    let name: String
}

// MARK: - Date time extensions for Article
extension NewsAPIArticle {
    var publishedTime: Date? {
        let formatter  = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        guard let date = formatter.date(from: publishedAt) else {
            return nil
        }
        
        return date
    }
    
    var ellapsedTime: String? {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        guard let published = publishedTime else {
            return nil
        }
        
        return formatter.localizedString(for: published, relativeTo: Date())
    }
}
