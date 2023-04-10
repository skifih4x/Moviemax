//
//  DetailMultimediaViewModel.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import Foundation

struct DetailMultimediaViewModel: Codable {
    let genres: String
    let id: Int
    let overview: String
    let releaseYear: String
    let title: String
    let posterPath: String
    let voteAverage: Double
    let runtime: String?
}

// MARK: - Result

