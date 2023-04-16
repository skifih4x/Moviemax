//
//  UserData.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 14.04.2023.
//

import Foundation
import RealmSwift

final class UserData: Object {    
    @Persisted var userFirstName: String
    @Persisted var userLastName: String
    @Persisted var userEmail: String
    @Persisted var userPassword: String
    @Persisted var uid: String
    @Persisted var userImageUrl: String
    @Persisted var userImage: Data
    @Persisted var isGoogleUser: Bool
    @Persisted var userIsMale: Bool
    @Persisted var userBDate: String
    @Persisted var userLocation: String
    
    convenience init(userFirstName: String, userLastName: String, userEmail: String, userPassword: String, uid: String, userImageUrl: String, userImage: Data, isGoogleUser: Bool, userIsMale: Bool, userBDate: String, userLocation: String) {
        self.init()
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userEmail = userEmail
        self.userPassword = userPassword
        self.uid = uid
        self.userImageUrl = userImageUrl
        self.userImage = userImage
        self.isGoogleUser = isGoogleUser
        self.userIsMale = userIsMale
        self.userBDate = userBDate
        self.userLocation = userLocation
    }
}
