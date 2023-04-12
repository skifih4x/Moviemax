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
    func addToFavorites(_ movie: Movie, genre: String)
    func fetchFavorites() -> [MultimediaViewModel]
    func deleteMovie(_ movie: Movie)
    func deleteAllMovies()
}

final class RealmService: DatabaseService {
    private init() {}
    static let shared = RealmService()
    private var lock = NSLock()
    
    func addToFavorites(_ movie: MultimediaViewModel) {
        do {
            lock.lock()
            let realm = try Realm()
            let movieData = MovieData(id: movie.id, title: movie.titleName, releaseDate: movie.releaseDate, posterPath: movie.posterImageLink, genre: movie.genre ?? "No genre", voteAverage: movie.rating)
            let data = realm.objects(MovieData.self)
            if !data.contains(where: { $0.id == movieData.id }) {
                try realm.write {
                    realm.add(movieData)
                }
            }
            lock.unlock()
        } catch {
            print("Realm thrown an error")
        }
    }
    
    func addToFavorites(_ movie: Movie, genre: String) {
        do {
            lock.lock()
            let realm = try Realm()
            let movieData = MovieData(id: movie.id, title: movie.title ?? "No title", releaseDate: movie.releaseDate ?? "No release date", posterPath: movie.posterPath ?? "No url path", genre: genre, voteAverage: movie.voteAverage)
            let data = realm.objects(MovieData.self)
            if !data.contains(where: { $0.id == movieData.id }) {
                try realm.write {
                    realm.add(movieData)
                }
            }
            lock.unlock()
        } catch {
            print("Realm thrown an error")
        }
    }
    
    func fetchFavorites() -> [MultimediaViewModel] {
        var favorites: [MultimediaViewModel] = []
        do {
            lock.lock()
            let realm = try Realm()
            let data = realm.objects(MovieData.self)
            lock.unlock()
            favorites = data.map { MultimediaViewModel(id: $0.id, type: .movie, posterImageLink: $0.posterPath, titleName: $0.title, releaseDate: $0.releaseDate, genre: $0.genre, description: $0.description, rating: $0.voteAverage) }
        } catch {
            print("Realm thrown an error")
        }
        return favorites
    }
    
    func deleteMovie(_ movie: Movie) {
        do {
            lock.lock()
            let realm = try Realm()
            let favorites = realm.objects(MovieData.self)
            let movieToDelete = favorites.first { $0.id == movie.id }
            guard let movieToDelete else { return }
            try realm.write {
                realm.delete(movieToDelete)
            }
            lock.unlock()
        } catch {
            print("Realm thrown an error")
        }
    }
    
    func deleteAllMovies() {
        do {
            lock.lock()
            let realm = try Realm()
            let favorites = realm.objects(MovieData.self)
            try realm.write {
                realm.delete(favorites)
            }
            lock.unlock()
        } catch {
            print("Realm thrown an error")
        }
    }
}
