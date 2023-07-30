//
//  APIError.swift
//  TrackHub
//
//  Created by Sanjay Soni on 30/07/23.
//

import Foundation

enum APIError: Error, LocalizedError {
    case missingRequiredFields(String)

    case badRequest

    case unauthorised

    case forbidden

    case notFound

    case http(httpResponse: HTTPURLResponse, data: Data)

    case invalidResponse(Data)

    case deleteOperationFailed(String)

    case network(URLError)

    case unknown(Error?)
}

func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
    guard let httpResponse = response.response as? HTTPURLResponse else {
        throw APIError.invalidResponse(response.data)
    }

    switch httpResponse.statusCode {
    case 200 ..< 300:
        return response.data
    case 304:
        throw APIError.deleteOperationFailed("")
    case 400:
        throw APIError.badRequest
    case 401:
        throw APIError.unauthorised
    case 403:
        throw APIError.forbidden
    case 404:
        throw APIError.notFound
    default:
        throw APIError.http(httpResponse: httpResponse, data: response.data)
    }
}
