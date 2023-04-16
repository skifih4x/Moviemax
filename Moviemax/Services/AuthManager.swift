//
//  AuthManager.swift
//  Moviemax
//
//  Created by Sergey on 04.04.2023.
//

import Foundation
import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

protocol AuthInputProtocol: AnyObject {
    
    func createUser(userFirstName: String, userLastName: String, email: String, password: String, completionBlock: @escaping(Result<UserAuthData, Error>)-> Void)
    func signIn(email: String, password: String, completionBlock: @escaping(Result<UserAuthData, Error>)-> Void)
    func signInWithGoogle(view: UIViewController, completionBlock: @escaping(Result<UserAuthData, Error>) -> Void)
    func signOutFromGoogle(email: String)
    func restorePassword(email: String, completionBlock: @escaping(Result<Bool, Error>)-> Void)
    func changePassword(newPassword: String, completionBlock: @escaping(Result<Bool, Error>)-> Void)
    func deleteUser(completionBlock: @escaping(Result<Bool, Error>)-> Void)
    func checkCurrentUser(email: String, password: String, completionBlock: @escaping(Result<Bool, Error>) -> Void)
    func signOut(email: String, completionBlock: @escaping(Result<Bool, Error>) -> Void)
    func registerAuthStateHandler(completionBlock: @escaping (Result<Bool, Error>) -> Void)
    
    
}

class AuthManager: AuthInputProtocol {
    
    private var databaseService = RealmService.userAuth
    
    var user: UserAuthData!
    
    // add listener
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler(completionBlock: @escaping (Result<Bool, Error>) -> Void) {
    
        if handle == nil {
            handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
                if user == nil {
                    completionBlock(.failure(ValidateInputError.emptyString))
                } else {
                    completionBlock(.success(user != nil))
                }
            })
        }
        
    }
    
    
    //MARK: - Creation new user
    
    func createUser(userFirstName: String, userLastName: String, email: String, password: String, completionBlock: @escaping (Result<UserAuthData, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completionBlock(.failure(error))
                return
            } else {
                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    currentUser.displayName = String("\(userFirstName) \(userLastName)")
                    currentUser.commitChanges { [self] (error) in
                        if let error = error {
                            completionBlock(.failure(error))
                        } else {
                            if let curUser = Auth.auth().currentUser {
                                user = UserAuthData(userFirstName: userFirstName,
                                                    userLastName: userLastName,
                                                    userEmail: curUser.email!,
                                                    userPassword: password,
                                                    uid: curUser.uid,
                                                    userImageUrl: curUser.photoURL,
                                                    isGoogleUser: false)
                            }
                            completionBlock(.success(user))
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - SignIn user
    
    func signIn(email: String, password: String, completionBlock: @escaping (Result<UserAuthData, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] (authResult, error) in
            if let error = error {
                completionBlock(.failure(error))
                return
            } else {
                if let currentUser = Auth.auth().currentUser {
                    let fullName: String = currentUser.displayName ?? "noName noName"
                    let fullNameArray = fullName.components(separatedBy: " ")
                    user = UserAuthData(userFirstName: fullNameArray[0],
                                        userLastName: fullNameArray[1],
                                        userEmail: currentUser.email ?? email,
                                        userPassword: password,
                                        uid: currentUser.uid,
                                        isGoogleUser: false)
                }
                completionBlock(.success(user))
            }
        }
        
    }
    
    //MARK: - SignIn with Google
    
    func signInWithGoogle(view: UIViewController, completionBlock: @escaping (Result<UserAuthData, Error>) -> Void) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString
            else {
                completionBlock(.failure(ValidateInputError.findNil))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completionBlock(.failure(error))
                    return
                } else {
                    let userData = UserAuthData(userFirstName: user.profile?.name.components(separatedBy: " ")[0] ?? "noName",
                                                userLastName: user.profile?.familyName ?? "noName",
                                                userEmail: user.profile?.email ?? "",
                                                userPassword: "",
                                                uid: result?.user.uid ?? user.accessToken.tokenString,
                                                userImageUrl: user.profile?.imageURL(withDimension: .max), isGoogleUser: true)
                    completionBlock(.success(userData))
                }
            }
            
            
        }
    
        
    }
    
    //MARK: -  SignOut from google
    
    func signOutFromGoogle(email: String) {
        GIDSignIn.sharedInstance.signOut()
        databaseService.deleteUser(with: email)
        user = nil
    }
    
    
    //MARK: - Restore password
    
    func restorePassword(email: String, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(true))
            }
        }
        
    }
    
    //MARK: - Change password
    
    func changePassword(newPassword: String, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(true))
            }
        })
        
    }
    
    //MARK: - Delete user
    
    func deleteUser(completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        let userToDelete = Auth.auth().currentUser
        userToDelete?.delete(completion: { (error) in
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(true))
            }
            
        })
        
    }
    
    func checkCurrentUser(email: String, password: String, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        if let fireUser = Auth.auth().currentUser {
            if fireUser.email == email { completionBlock(.success(true)) } else { completionBlock(.failure(ValidateInputError.authError)) }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error)  in
                if let error = error {
                    completionBlock(.failure(error))
                } else {
                    completionBlock(.success(true))
                    
                }
                
            }
        }
        
    }
    
    func signOut(email: String, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            databaseService.deleteUser(with: email)
            completionBlock(.success(true))
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completionBlock(.failure(signOutError))
        }
        
    }
    
    func signOutFaster( completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
            completionBlock(.success(true))
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completionBlock(.failure(signOutError))
        }
        
    }
    
}
