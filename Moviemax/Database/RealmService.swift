//
//  RealmService.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 11.04.2023.
//

import Foundation
import RealmSwift

protocol DatabaseService {
    func addToFavorites(_ movie: MultimediaViewModel)
    func addToFavorites(_ movie: Movie, genre: MovieGenre)
    func fetchFavorites() -> [MultimediaViewModel]
    func isInFavorites(_ movieId: Int) -> Bool
    func addToRecentWatch(_ movie: MultimediaViewModel)
    func addToRecentWatch(_ movie: Movie, genre: MovieGenre)
    func fetchRecentWatch() -> [MultimediaViewModel]
    func isInRecentWatch(_ movieId: Int) -> Bool
    func deleteMovie(_ movieId: Int)
    func deleteAllMovies()
}

final class RealmService: DatabaseService {
    private init() {}
    static let shared = RealmService()
    private var lock = NSLock()
    
    //MARK: - favorites methods
    func addToFavorites(_ movie: MultimediaViewModel) {
        do {
            
            let realm = try Realm()
            let movieData = MovieData(id: movie.id, title: movie.titleName, releaseDate: movie.releaseDate, posterPath: movie.posterImageLink, genre: movie.genre ?? "No genre", voteAverage: movie.rating, isFavorite: true)
            let data = realm.objects(MovieData.self)
            if !data.contains(where: { $0.id == movieData.id && $0.isFavorite == true }) {
                try realm.write {
                    realm.add(movieData)
                }
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func addToFavorites(_ movie: Movie, genre: MovieGenre) {
        do {
            
            let realm = try Realm()
            let movieData = MovieData(id: movie.id, title: movie.title ?? "No title", releaseDate: movie.releaseDate ?? "No release date", posterPath: movie.posterPath ?? "No url path", genre: genre.name, voteAverage: movie.voteAverage, isFavorite: true)
            let data = realm.objects(MovieData.self)
            if !data.contains(where: { $0.id == movieData.id && $0.isFavorite == true }) {
                try realm.write {
                    realm.add(movieData)
                }
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchFavorites() -> [MultimediaViewModel] {
        var favorites: [MultimediaViewModel] = []
        do {
            
            let realm = try Realm()
            let data = realm.objects(MovieData.self)
            let favoritesData = data.where { $0.isFavorite == true }
            
            favorites = favoritesData.map { MultimediaViewModel(id: $0.id, type: .movie, posterImageLink: $0.posterPath, titleName: $0.title, releaseDate: $0.releaseDate, genre: $0.genre, description: $0.description, rating: $0.voteAverage, isFavorite: $0.isFavorite) }
        } catch {
            debugPrint(error)
        }
        print(favorites.count)
        return favorites
    }
    
    func deleteMovie(_ movieId: Int) {
        do {
            
            let realm = try Realm()
            let favorites = realm.objects(MovieData.self)
            let movieToDelete = favorites.first { $0.id == movieId && $0.isFavorite == true }
            guard let movieToDelete else { return }
            try realm.write {
                realm.delete(movieToDelete)
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func deleteAllMovies() {
        do {
            
            let realm = try Realm()
            let favorites = realm.objects(MovieData.self)
            try realm.write {
                realm.delete(favorites)
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func isInFavorites(_ movieId: Int) -> Bool {
        do {
            
            let realm = try Realm()
            let data = realm.objects(MovieData.self)
            let favoritesData = data.where { $0.isFavorite == true }
            if favoritesData.contains(where: { $0.id == movieId }) {
                return true
            }
            
        } catch {
            debugPrint(error)
        }
        return false
    }
    
    //MARK: - recentWatch methods
    func addToRecentWatch(_ movie: MultimediaViewModel) {
        do {
            
            let realm = try Realm()
            let movieData = MovieData(id: movie.id, title: movie.titleName, releaseDate: movie.releaseDate, posterPath: movie.posterImageLink, genre: movie.genre ?? "No genre", voteAverage: movie.rating, isWatched: true)
            let data = realm.objects(MovieData.self)
            if !data.contains(where: { $0.id == movieData.id && $0.isWatched == true }) {
                try realm.write {
                    realm.add(movieData)
                }
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func addToRecentWatch(_ movie: Movie, genre: MovieGenre) {
        do {
            
            let realm = try Realm()
            let movieData = MovieData(id: movie.id, title: movie.title ?? "No title", releaseDate: movie.releaseDate ?? "No release date", posterPath: movie.posterPath ?? "No url path", genre: genre.name, voteAverage: movie.voteAverage, isWatched: true)
            let data = realm.objects(MovieData.self)
            if !data.contains(where: { $0.id == movieData.id && $0.isWatched == true }) {
                try realm.write {
                    realm.add(movieData)
                }
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchRecentWatch() -> [MultimediaViewModel] {
        var watched: [MultimediaViewModel] = []
        do {
            
            let realm = try Realm()
            let data = realm.objects(MovieData.self)
            let recentWatchData = data.where { $0.isWatched == true }
            
            watched = recentWatchData.map { MultimediaViewModel(id: $0.id, type: .movie, posterImageLink: $0.posterPath, titleName: $0.title, releaseDate: $0.releaseDate, genre: $0.genre, description: $0.description, rating: $0.voteAverage, isWatched: true) }
        } catch {
            debugPrint(error)
        }
        return watched
    }
    
    func isInRecentWatch(_ movieId: Int) -> Bool {
        do {
            
            let realm = try Realm()
            let data = realm.objects(MovieData.self)
            if data.contains(where: { $0.id == movieId && $0.isWatched == true }) {
                return true
            }
            
        } catch {
            debugPrint(error)
        }
        return false
    }
}
