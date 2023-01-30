//
//  MockData.swift
//  RepoWatcher
//
//  Created by Josafat Vicente Pérez on 30/1/23.
//

import Foundation

struct MockData {
    static let repoOne = Repository(name: "Repo One", owner: Owner(avatarUrl: ""), hasIssues: true, forks: 15, watchers: 14, openIssues: 6, pushedAt: "2023-01-06T18:19:30Z", avatarData: Data(), contributors: [
        Contributor(login: "Sean Allen", avatarUrl: "", contributions: 42, avatarData: Data()),
        Contributor(login: "Michael Jordan", avatarUrl: "", contributions: 23, avatarData: Data()),
        Contributor(login: "Steph Curry", avatarUrl: "", contributions: 30, avatarData: Data()),
        Contributor(login: "LeBron James", avatarUrl: "", contributions: 6, avatarData: Data())])
    static let repoTwo = Repository(name: "Repo Two", owner: Owner(avatarUrl: ""), hasIssues: true, forks: 65, watchers: 113, openIssues: 5, pushedAt: "2021-01-06T18:19:30Z", avatarData: Data())
}
