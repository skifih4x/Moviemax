//
//  MultimediaLoader.swift
//  Movve
//
//  Created by Aleksey Kosov on 22.01.2023.
//

import UIKit


protocol MultimediaLoaderProtocol: AnyObject {
    func getMediaData(for type: MultimediaTypeURL, completion: @escaping (([MultimediaViewModel]) -> Void))
}

enum MultimediaTypeURL: String, CaseIterable {
    case movie = "movie"
    case tvShow = "tv"
}

final class MultimediaLoader {

    private init() {}

   static let shared = MultimediaLoader()

    var bookmarks = [MultimediaViewModel]()

    weak var delegate: UIViewController?

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let networkManager = NetworkManager()

    static let cache = NSCache<NSString, UIImage>()

    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "594bcc6cf3865f6c3e8326fd2d8f3f17"

    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"

    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }

    //MARK: - Main ViewController Functions

    func searchMedia(type: MultimediaTypeURL, query: String, page: Int = 1, completion: @escaping (Result<MultimediaModel, Error>) -> Void) {
        let urlString: String
        switch type {
        case .movie:
            urlString = "\(baseURL)search/tv?api_key=\(apiKey)&language=en-US&query=\(query)&page=\(page)"
        case .tvShow:
            urlString = "\(baseURL)search/movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=\(page)"
        }
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            return
        }
        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try self.decoder.decode(MultimediaModel.self, from: data)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMoviesByGenre(genre: MovieGenre, completion: @escaping (Result<MultimediaModel, Error>) -> Void) {
        let urlString = "\(baseURL)discover/movie?api_key=\(apiKey)&with_genres=\(genre.rawValue)"
        guard let url = URL(string: urlString) else { return }
        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try self.decoder.decode(MultimediaModel.self, from: data)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchTvSeriesByGenre(genre: TvShowGenre, completion: @escaping (Result<MultimediaModel, Error>) -> Void) {
        let urlString = "\(baseURL)discover/tv?api_key=\(apiKey)&with_genres=\(genre.rawValue)"
        guard let url = URL(string: urlString) else { return }
        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let tvSeries = try self.decoder.decode(MultimediaModel.self, from: data)
                    completion(.success(tvSeries))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func getMediaData(for type: MultimediaTypeURL, completion: @escaping (([MultimediaTypeURL: [MultimediaViewModel]]) -> Void)) {
        var multimediaViewModel = [MultimediaViewModel]()
        var alldataDict = [MultimediaTypeURL: [MultimediaViewModel]]()

        fetchMultimedia(for: type) { movie in
            guard let result = movie.results else { return }
            result.forEach { movieResult in

                let posterURL = self.imageBaseUrl + (movieResult.posterPath ?? "")
                let formattedDate: String
                let genre: String
                let title: String

                switch type {
                case .movie:
                       formattedDate = movieResult.releaseDate?.convertDateString() ?? "Unknown date"
                    if let genreId = movieResult.genreIds.first,
                          let genreEnum = MovieGenre(rawValue: genreId) {
                           genre = genreEnum.name
                       } else {
                           genre = "Unknown genre"
                       }
                       title = movieResult.title ?? "Unknown movie"


                case .tvShow:
                    formattedDate = movieResult.firstAirDate?.convertDateString() ?? "Unknown date"
                    if let genreId = movieResult.genreIds.first,
                       let genreEnum = TvShowGenre(rawValue: genreId) {
                        genre = genreEnum.name
                    } else {
                        genre = "Unknown genre"
                    }
                    title = movieResult.name ?? "Unknown name"

                }

                multimediaViewModel.append(MultimediaViewModel(id: movieResult.id,
                                                               type: type,
                                                               posterImageLink: posterURL,
                                                               titleName: title,
                                                               releaseDate: formattedDate,
                                                               genre: genre,
                                                               description: movieResult.overview,
                                                               rating: movieResult.voteAverage))
                alldataDict.updateValue(multimediaViewModel, forKey: type)
            }
            completion(alldataDict)

        }
    }

    func getAllTypesOfMediaData(completion: @escaping (([MultimediaTypeURL: [MultimediaViewModel]]) -> Void)) {
        var dictOfAllData = [MultimediaTypeURL: [MultimediaViewModel]]()
        let group = DispatchGroup()
        MultimediaTypeURL.allCases.forEach { mediaType in
            group.enter()
            getMediaData(for: mediaType) { multiMediaArray in
                 dictOfAllData = dictOfAllData.merging(multiMediaArray) { (current, _) in current }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print(dictOfAllData)
           completion(dictOfAllData)
        }
    }
    private func fetchMultimedia(for type: MultimediaTypeURL, completion: @escaping (MultimediaModel) -> Void) {

        guard let url = URL(string: baseURL + "discover/" + type.rawValue + "?api_key=" + apiKey) else {
            return
        }

        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let multimedia = try self.decoder.decode(MultimediaModel.self, from: data)
                    completion(multimedia)
                } catch {
                    self.delegate?.presentDefaultError()
                }
            case .failure:
                self.delegate?.presentAlert(message: MovieError.codeError.rawValue, completion: {
                    if let mainVC = self.delegate as? HomeViewController {
                     //   mainVC.fetchAllTypesOfMedia()
                    }
                })
            }
        }
    }
//MARK: - DetailMedia Controller Functions
    func fetchDetailData(multimedia: MultimediaViewModel, completion: @escaping (DetailMultimediaModel) -> Void) {
        guard let url = URL(string: baseURL + "\(multimedia.type.rawValue)/\(multimedia.id)?api_key=\(apiKey)") else { return }

        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let detailMultimedia = try self.decoder.decode(DetailMultimediaModel.self, from: data)
                    completion(detailMultimedia)
                } catch {
                    self.delegate?.presentDefaultError()

                }
            case .failure:
                self.delegate?.presentAlert(message: MovieError.codeError.rawValue, completion: {
                    self.fetchDetailData(multimedia: multimedia, completion: completion)
                })
            }
        }
    }

    func fetchCastData(multimedia: MultimediaViewModel, completion: @escaping (CastModel) -> Void) {
        guard let url = URL(string: baseURL + "\(multimedia.type.rawValue)/\(multimedia.id)/credits?api_key=\(apiKey)") else { return }

        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let detailMultimedia = try self.decoder.decode(CastModel.self, from: data)
                    completion(detailMultimedia)
                } catch {
                    self.delegate?.presentDefaultError()
                }
            case .failure:
                self.delegate?.presentAlert(message: MovieError.codeError.rawValue, completion: {
                    self.fetchCastData(multimedia: multimedia, completion: completion)
                })
            }
        }
    }

    func convertDetailMMtoViewModel(detailMultimedia: DetailMultimediaModel, type: MultimediaTypeURL) -> DetailMultimediaViewModel {

        let title: String
        let id: Int
        let releaseYear: String
        var genres: String
        let posterPath: String
        let voteAverage: Double
        let time: String?
        let overview: String

        switch type {
        case .movie:
            title = detailMultimedia.title ?? "No name"
            let timeTuple = minutesToHoursAndMinutes(detailMultimedia.runtime ?? 0)

             time = "\(timeTuple.hours) h \(timeTuple.leftMinutes) min"

        case .tvShow:
            title = detailMultimedia.name ?? "No name"

           let timeTuple = minutesToHoursAndMinutes(detailMultimedia.episodeRunTime?.first ?? 0)

            time = "\(timeTuple.hours) h \(timeTuple.leftMinutes) min"

        }

        id = detailMultimedia.id
        releaseYear = detailMultimedia.releaseDate?.convertToYear() ?? ""
        genres = detailMultimedia.genres.first?.name ?? ""
        if detailMultimedia.genres.count >= 2 {
            genres += ", " + detailMultimedia.genres[1].name
        }
        posterPath = detailMultimedia.posterPath
        voteAverage = detailMultimedia.voteAverage
        overview = detailMultimedia.overview



        return DetailMultimediaViewModel(genres: genres,
                                         id: id,
                                         overview: overview,
                                         releaseYear: releaseYear,
                                         title: title,
                                         posterPath: posterPath,
                                         voteAverage: voteAverage,
                                         runtime: time)
    }

    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }


    func fetchImage(from endpoint: String, completion: @escaping (UIImage?) -> Void) {
       let cacheKey = NSString(string: endpoint)
        if let image = MultimediaLoader.cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }

        guard let url = URL(string: imageBaseUrl + endpoint) else { return }
        networkManager.fetchData(with: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    self.delegate?.presentDefaultError(errorText: MovieError.errorLoadingImage.rawValue)
                    completion(nil)
                    return
                }
                MultimediaLoader.cache.setObject(image, forKey: cacheKey)
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(let error):
                completion(nil)
                print(error.localizedDescription)
            }
        }
    }
}
