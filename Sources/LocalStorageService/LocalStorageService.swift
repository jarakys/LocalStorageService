// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

protocol LocalStorageService<TKey> {
    associatedtype TKey: CustomStringConvertible
    func set(_ value: Any?, key: TKey)
    func get(key: TKey) -> Any?
    func getBool(key: TKey) -> Bool
    func getString(key: TKey) -> String?
    func get<T>(key: TKey) -> T? where T : Decodable
    func get<T>(key: TKey, defaultValue: T) -> T where T : Decodable
    func set<T>(key: TKey, value: T) where T : Codable
}

final class UserDefaultsService<TKey: CustomStringConvertible>: LocalStorageService {
    typealias TKey = TKey
    
    private let defaults = UserDefaults.standard

    func set(_ value: Any?, key: TKey) {
        defaults.setValue(value, forKey: key.description)
    }
    
    func set<T>(key: TKey, value: T) where T : Codable {
        defaults.set(try? JSONEncoder().encode(value), forKey: key.description)
    }

    func get(key: TKey) -> Any? {
        return defaults.value(forKey: key.description)
    }
    
    func get<T>(key: TKey) -> T? where T : Decodable {
        guard let data = defaults.object(forKey: key.description) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func get<T>(key: TKey, defaultValue: T) -> T where T : Decodable {
        guard let data = defaults.object(forKey: key.description) as? Data else { return defaultValue }
        return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }

    func getBool(key: TKey) -> Bool {
        return defaults.bool(forKey: key.description)
    }

    func getString(key: TKey) -> String? {
        return defaults.string(forKey: key.description)
    }
}
