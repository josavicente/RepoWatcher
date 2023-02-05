//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Sean Allen on 9/17/22.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.co.seanallen.RepoWatcher")!
    }

    static let repoKey = "repos"
}

enum UserDefaultsError: Error {
    case retrieval
}
