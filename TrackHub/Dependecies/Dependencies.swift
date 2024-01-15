//
//  Dependencies.swift
//  TrackHub
//
//  Created by Sanjay Soni on 16/08/23.
//

import Foundation
import SwiftUI

protocol Dependencies {
    var cacheService: CacheService { get }
    var authService: AuthService { get }
    var apiClient: GithubApiClient { get }
    var userDefaultsService: UserDefaultsService { get }
    var usersService: UsersService { get }
}

final class AppDependencies: Dependencies {
    let cacheService: CacheService
    let authService: AuthService
    let apiClient: GithubApiClient
    let userDefaultsService: UserDefaultsService
    let usersService: UsersService

    static let shared: AppDependencies = .init()

    private init() {
        let cacheService = CacheServiceImp()

        let userDefaultsService = UserDefaultsServiceImp()

        let apiClient = GithubApiClientImp(userDefaultService: userDefaultsService)

        let authService = AuthServiceImp(userDefaultService: userDefaultsService)

        let usersService = UsersServiceImp(apiClient: apiClient, cacheService: cacheService)

        self.cacheService = cacheService
        self.userDefaultsService = userDefaultsService
        self.apiClient = apiClient
        self.authService = authService
        self.usersService = usersService
    }
}
