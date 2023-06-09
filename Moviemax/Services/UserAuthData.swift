//
//  UserAuthData.swift
//  Moviemax
//
//  Created by Sergey on 04.04.2023.
//

import Foundation
struct UserAuthData {
    var userFirstName: String
    var userLastName: String
    var userEmail: String
    var userPassword: String
    var uid: String
    var userImageUrl: URL?
    var userImage: Data?
    var isGoogleUser: Bool
    var userIsMale: Bool?
    var userBDate: String?
    var userLocation: String?
}
