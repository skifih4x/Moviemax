//
//  MovieData.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 11.04.2023.
//

import Foundation
import RealmSwift

final class MovieData: Object {
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var releaseDate: String
    @Persisted var posterPath: String
    @Persisted var genre: String
    @Persisted var voteAverage: Double
    @Persisted var isFavorite: Bool
    @Persisted var isWatched: Bool
    
    convenience init(id: Int, title: String, releaseDate: String, posterPath: String, genre: String, voteAverage: Double, isFavorite: Bool = false, isWatched: Bool = false) {
        self.init()
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.genre = genre
        self.voteAverage = voteAverage
        self.isFavorite = isFavorite
        self.isWatched = isWatched
    }
}
