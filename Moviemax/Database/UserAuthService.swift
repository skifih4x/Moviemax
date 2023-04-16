//
//  UserAuthService.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 14.04.2023.
//

import Foundation
import RealmSwift
import UIKit

final class UserAuthService {
    
    //структура добавлена здесь, чтобы saveUserData не выдавал ошибки. Удалить ее отсюда после добавления в положенном месте
//    struct UserAuthData {
//        var userFirstName: String
//        var userLastName: String
//        var userEmail: String
//        var userPassword: String
//        var uid: String
//        var userImageUrl: URL?
//        var isGoogleUser: Bool
//        var userIsMale: Bool?
//        var userBDate: String?
//        var userLocation: String?
//    }
    
    func saveUserData(_ data: UserAuthData) {
        do {
            let realm = try Realm()
            let userData = UserData(userFirstName: data.userFirstName, userLastName: data.userLastName, userEmail: data.userEmail, userPassword: data.userPassword, uid: data.uid, userImageUrl: String(describing: data.userImageUrl), userImage: (data.userImage ?? UIImage(named: "ProfileImage")!.pngData())!, isGoogleUser: data.isGoogleUser, userIsMale: data.userIsMale ?? false, userBDate: data.userBDate ?? "", userLocation: data.userLocation ?? "")
            let users = realm.objects(UserData.self)
            if !users.contains(where: { $0.userEmail == userData.userEmail }) {
                try realm.write {
                    realm.add(userData)
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func getUserData() -> UserAuthData? {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            let userAuth = users.map { UserAuthData(userFirstName: $0.userFirstName, userLastName: $0.userLastName, userEmail: $0.userEmail, userPassword: $0.userPassword, uid: $0.uid, userImageUrl: URL(string: $0.userImageUrl), isGoogleUser: $0.isGoogleUser, userIsMale: $0.userIsMale, userBDate: $0.userBDate, userLocation: $0.userLocation) }.first
            return userAuth
        } catch {
            debugPrint(error)
        }
        return nil
    }
    
    func deleteUser(with email: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            let userToDelete = users.first { $0.userEmail == email}
            guard let userToDelete else { return }
            try realm.write {
                realm.delete(userToDelete)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    //MARK: - stupid update methods
    func updateUserFirstName(with name: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userFirstName = name
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserLastName(with name: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userLastName = name
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserEmail(with email: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userEmail = email
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserPassword(with password: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userPassword = password
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserImageURL(with url: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userImageUrl = url
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateIsGoogleUser(with state: Bool) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.isGoogleUser = state
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserIsMale(with state: Bool) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userIsMale = state
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserBDate(with date: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userBDate = date
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func updateUserLocation(with location: String) {
        do {
            let realm = try Realm()
            let users = realm.objects(UserData.self)
            guard let userToUpdate = users.first else { return }
            try realm.write {
                userToUpdate.userLocation = location
            }
        } catch {
            debugPrint(error)
        }
    }
}
