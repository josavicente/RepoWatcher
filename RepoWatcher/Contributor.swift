//
//  Contributor.swift
//  RepoWatcher
//
//  Created by Josafat Vicente Pérez on 30/1/23.
//

import Foundation

struct Contributor : Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data
}

extension Contributor {
    struct codingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int
        
        var contributor : Contributor {
            Contributor(login: login, avatarUrl: avatarUrl, contributions: contributions, avatarData: Data())
        }
    }
}
