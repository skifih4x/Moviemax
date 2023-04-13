//
//  MultimediaViewModel.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import UIKit

struct MultimediaViewModel: Hashable {
    let id: Int
    let type: MultimediaTypeURL
    let posterImageLink: String
    let titleName: String
    let releaseDate: String
    let genre: String?
    let description: String
    let rating: Double
    var isFavorite: Bool = false
    var isWatched: Bool? = false
}
