//
//  UserSession.swift
//  Hotpet
//
//  Created by Grim on 11/3/2023.
//

import Foundation

func saveSession(user: User) {
    do {
        saveLastLoggedEmail(email: user.email)
        try UserDefaults.standard.set(JSONEncoder().encode(user), forKey: USER_DEFAULTS_USER)
    } catch {
        print("Unable to encode user (\(error))")
    }
}

func loadSession() -> User? {
    if UserDefaults.standard.data(forKey: USER_DEFAULTS_USER) != nil {
        if let userData = UserDefaults.standard.data(forKey: USER_DEFAULTS_USER) {
            do {
                return try JSONDecoder().decode(User.self, from: userData)
            } catch {
                print("Unable to decode user (\(error))")
            }
        }
    }
    return nil
}

func saveLastLoggedEmail(email: String) {
    UserDefaults.standard.set(email, forKey: USER_DEFAULTS_LAST_LOGGED_EMAIL)
}

func loadLastLoggedEmail() -> String {
    if UserDefaults.standard.string(forKey: USER_DEFAULTS_LAST_LOGGED_EMAIL) != nil {
        return UserDefaults.standard.string(forKey: USER_DEFAULTS_LAST_LOGGED_EMAIL)!
    }
    return ""
}

func resetSession() {
    UserDefaults.standard.set(nil, forKey: USER_DEFAULTS_USER)
}
