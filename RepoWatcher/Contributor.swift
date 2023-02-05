//
//  Contributor.swift
//  RepoWatcher
//
//  Created by Sean Allen on 8/16/22.
//

import Foundation

struct Contributor: Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data
}

extension Contributor {
    struct CodingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int

        var contributor: Contributor {
            Contributor(login: login,
                        avatarUrl: avatarUrl,
                        contributions: contributions,
                        avatarData: Data())
        }
    }
}
