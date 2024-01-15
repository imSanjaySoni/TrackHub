//
//  RequestState.swift
//  TrackHub
//
//  Created by Sanjay Soni on 30/07/23.
//

import Foundation

enum RequestPhase<T> {
    case idle
    case loading
    case empty
    case error(_ message: String)
    case data(_ data: T?)
}

enum AuthPhase {
    case idle
    case loading
    case fail
    case success
}

extension RequestPhase {
    var unwrappedData: T? {
        switch self {
        case .empty,
             .error,
             .idle,
             .loading: nil
        case .data(let data): data
        }
    }
}
