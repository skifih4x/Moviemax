//
//  AuthManager.swift
//  Moviemax
//
//  Created by Sergey on 04.04.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

protocol AuthInputProtocol: AnyObject {
    
    func createUser(userName: String, email: String, password: String, completionBlock: @escaping(Result<UserAuthData, Error>)-> Void)
    func signIn(email: String, password: String, completionBlock: @escaping(Result<UserAuthData, Error>)-> Void)
    func googleSignIn(view: UIViewController, completionBlock: @escaping(Result<UserAuthData, Error>) -> Void)
    func restorePassword(email: String, completionBlock: @escaping(Result<Bool, Error>)-> Void)
    func changePassword(newPassword: String, completionBlock: @escaping(Result<Bool, Error>)-> Void)
    func deleteUser(completionBlock: @escaping(Result<Bool, Error>)-> Void)
    func checkCurrentUser(email: String, password: String, completionBlock: @escaping(Result<Bool, Error>) -> Void)
    func signOut(completionBlock: @escaping(Result<Bool, Error>) -> Void)
    
}

class AuthManager: AuthInputProtocol {
    
    var user: UserAuthData!
    
    //MARK: - Creation new user
    
    func createUser(userName: String, email: String, password: String, completionBlock: @escaping (Result<UserAuthData, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completionBlock(.failure(error))
                return
            } else {
                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    currentUser.displayName = userName
                    currentUser.commitChanges { [self] (error) in
                        if let error = error {
                            completionBlock(.failure(error))
                        } else {
                            if let curUser = Auth.auth().currentUser {
                                user = UserAuthData(userName: curUser.displayName ?? "",
                                                    userEmail: curUser.email!,
                                                    userPassword: password,
                                                    uid: curUser.uid)
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
                    user = UserAuthData(userName: currentUser.displayName ?? "noName",
                                        userEmail: currentUser.email ?? email,
                                        userPassword: password,
                                        uid: currentUser.uid)
                }
                completionBlock(.success(user))
            }
        }
        
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
    
    //MARK: - SignIn with Google
    
    func googleSignIn(view: UIViewController, completionBlock: @escaping(Result<UserAuthData, Error>) -> Void) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { [weak self] result, error in
            guard let self = self else { return }
            if error == nil  {
                completionBlock(.failure(error!))
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            let googleUser = UserAuthData(userName: user.profile?.name ?? "",
                                          userEmail: user.profile?.email ?? "",
                                          userPassword: "",
                                          uid: user.accessToken.tokenString)
            completionBlock(.success(googleUser))
        }
    }
    
    //MARK: - SignOut
    
    func signOut(completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completionBlock(.success(true))
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completionBlock(.failure(signOutError))
        }
        
    }
    
}
