//
//  Repository.swift
//  RepoWatcher
//
//  Created by Josafat Vicente Pérez on 27/1/23.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    static let placeholder = Repository(name: "Your Repo", owner: Owner(avatarUrl: ""), hasIssues: true, forks: 65, watchers: 113, openIssues: 5, pushedAt: "2021-01-06T18:19:30Z")
}

struct Owner: Decodable {
    let avatarUrl: String
}
