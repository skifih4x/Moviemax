//
//  CastModel.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import Foundation

// MARK: - CastModel
struct CastModel: Codable {
    let id: Int?
    let cast: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
    let name: String
    let originalName: String
    let profilePath: String?
    let character: String
} 
