//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Josafat Vicente Pérez on 27/1/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init(){
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(atURL urlString: String) async throws -> Repository {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidRepoURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            return try decoder.decode(Repository.self, from: data)
        } catch {
            throw NetworkError.inavalidRepoData
        }
    }
}


enum NetworkError: Error {
    case invalidRepoURL
    case invalidResponse
    case inavalidRepoData
}

enum RepoURL{
    static let repoMidu = "https://api.github.com/repos/midudev/aprendiendo-react"
    static let repoJosa = "https://api.github.com/repos/josavicente/josavicente-dev "
}
