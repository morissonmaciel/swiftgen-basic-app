//
//  Reader+Model.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 10/01/23.
//

import Foundation

struct ReaderDataModel {
    var id = UUID()
    var title: String
    var sourceURL: URL
    var publishedAt: String
    var previewImage: String?
}
