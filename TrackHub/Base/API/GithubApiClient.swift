//
//  GithubApiClient.swift
//  TrackHub
//
//  Created by Sanjay Soni on 30/07/23.
//

import Foundation

protocol GithubApiClient {
    func fetchCurrentUser() async throws -> User
    func fetchUserProfile(_ username: String) async throws -> User

    func fetchFollowers(after username: String?) async throws -> [BasicUser]
    func fetchFollowing(after username: String?) async throws -> [BasicUser]

    func followUser(_ username: String) async throws
    func unfollowUser(_ username: String) async throws
}

final class GithubApiClientImp: GithubApiClient {
    // MARK: Internal

    func fetchCurrentUser() async throws -> User {
        try await call(.profile, method: .GET)
    }

    func fetchFollowers(after username: String? = nil) async throws -> [BasicUser] {
        return try await call(.followers, method: .GET, queries: defaultQueries(username))
    }

    func fetchFollowing(after username: String? = nil) async throws -> [BasicUser] {
        return try await call(.following, method: .GET, queries: defaultQueries(username))
    }

    func followUser(_ username: String) async throws {
        try await call(.follow(username), method: .PUT)
    }

    func unfollowUser(_ username: String) async throws {
        try await call(.unfollow(username), method: .DELETE)
    }

    func fetchUserProfile(_ username: String) async throws -> User {
        return try await call(.users(username), method: .GET)
    }

    // MARK: Private

    private enum Method: String {
        case GET
        case PUT
        case DELETE
    }

    private enum Endpoint {
        case profile
        case followers
        case following
        case users(String)
        case follow(String)
        case unfollow(String)

        // MARK: Internal

        var rawValue: String {
            switch self {
            case .profile:
                return "/user"
            case .followers:
                return "/user/followers"
            case .following:
                return "/user/following"
            case .users(let username):
                return "/users/\(username)"
            case .follow(let username):
                return "/user/following/\(username)"
            case .unfollow(let username):
                return "/user/following/\(username)"
            }
        }
    }

    private enum QueryKey: String {
        case perPage = "per_page"
        case since
    }

    private let baseURL = "https://api.github.com"

    private var authToken: String? {
        UserDefaults.standard.string(forKey: Keys.AuthToken.rawValue)
    }

    private func defaultQueries(_ username: String?) -> [String: String] {
        var queries = [QueryKey.perPage.rawValue: "100"]

        if let username {
            queries.updateValue(QueryKey.since.rawValue, forKey: username)
        }
        return queries
    }

    private func call<T: Codable>(_ endPoint: Endpoint, method: Method, queries: [String: String]? = nil) async throws -> T {
        let urlRequest = try request(for: endPoint, method: method, queries: queries)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let decoded = try JSONDecoder().decode(T.self, from: try mapResponse(response: (data, response)))
        return decoded
    }

    private func call(_ endPoint: Endpoint, method: Method) async throws {
        let urlRequest = try request(for: endPoint, method: method, queries: nil)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        _ = try mapResponse(response: (data, response))
    }

    private func request(for endpoint: Endpoint, method: Method, queries: [String: String]?) throws -> URLRequest {
        let path = "\(baseURL)\(endpoint.rawValue)"

        guard let authToken else {
            throw APIError.unauthorised
        }

        guard var url = URL(string: path) else {
            throw APIError.badRequest
        }

        if let queries {
            url.append(queryItems: queries.map { .init(name: $0, value: $1) })
        }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        request.allHTTPHeaderFields = [
            "accept": "application/vnd.github+json",
            "Authorization": "Bearer \(authToken)"
        ]

        return request
    }
}
