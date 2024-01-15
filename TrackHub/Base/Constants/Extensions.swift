//
//  Extensions.swift
//  TrackHub
//
//  Created by Sanjay Soni on 15/08/23.
//

import Foundation

extension UserDefaults {
    func setObject<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error encoding: \(error)")
        }
    }

    func getObject<T: Codable>(forKey key: String) -> T? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error decoding: \(error)")
            return nil
        }
    }
}
