//
//  NetworkManager.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import Foundation

final class NetworkManager {

    
    func fetchData(with url: URL, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(error.unsafelyUnwrapped) )
                return
            }

            guard let data = data else { return }
            completion(.success(data))
        }
        task.resume()
    }
}






// https://api.themoviedb.org/3/discover/movie?api_key=594bcc6cf3865f6c3e8326fd2d8f3f17 movie link
// https://api.themoviedb.org/3/discover/movie?api_key594bcc6cf3865f6c3e8326fd2d8f3f17

// https://api.themoviedb.org/3/discover/tv?api_key=594bcc6cf3865f6c3e8326fd2d8f3f17

// https://image.tmdb.org/t/p/w500/ imagepath

// https://api.themoviedb.org/3/movie/315162?api_key=594bcc6cf3865f6c3e8326fd2d8f3f17 detail VC

// https://api.themoviedb.org/3/movie/536554/credits?api_key=594bcc6cf3865f6c3e8326fd2d8f3f17 cast link
