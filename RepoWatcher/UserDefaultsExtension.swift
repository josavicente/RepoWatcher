//
//  UserDefaultsExtension.swift
//  RepoWatcher
//
//  Created by Josafat Vicente Pérez on 1/2/23.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.code.josavicente.RepoWatcher")!
    }
    static let repoKey = "repos"
}
