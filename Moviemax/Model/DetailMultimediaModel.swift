//
//  DetailMultimediaModel.swift
//
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import Foundation

struct DetailMultimediaModel: Codable {
    let genres: [Genre]
    let id: Int
    let overview: String
    let releaseDate, title: String?
    let posterPath: String
    let voteAverage: Double
    let firstAirDate, name: String?
    let episodeRunTime: [Int]?
    let runtime: Int?
}

// MARK: - Result
struct Genre: Codable {
    let id: Int
    let name: String
}
