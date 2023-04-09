//
//  Multimedia.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import Foundation

// MARK: - Multimedia
struct MultimediaModel: Codable {
    let page: Int
    let results: [Movie]?
    enum CodingKeys: String, CodingKey {
        case page, results
    }
}

// MARK: - Result
struct Movie: Codable {
    let genreIds: [Int]
    let id: Int
    let overview: String
    let releaseDate, title: String?
    let posterPath: String?
    let voteAverage: Double
    let firstAirDate, name: String?
}
