// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public protocol LocalStorageService<TKey> {
    associatedtype TKey: CustomStringConvertible
    func set(_ value: Any?, key: TKey)
    func get(key: TKey) -> Any?
    func getBool(key: TKey) -> Bool
    func getString(key: TKey) -> String?
    func get<T>(key: TKey) -> T? where T : Decodable
    func get<T>(key: TKey, defaultValue: T) -> T where T : Decodable
    func set<T>(key: TKey, value: T) where T : Codable
}

public final class UserDefaultsService<TKey: CustomStringConvertible>: LocalStorageService {
    public typealias TKey = TKey
    
    private let defaults = UserDefaults.standard

    public func set(_ value: Any?, key: TKey) {
        defaults.setValue(value, forKey: key.description)
    }
    
    public func set<T>(key: TKey, value: T) where T : Codable {
        defaults.set(try? JSONEncoder().encode(value), forKey: key.description)
    }

    public func get(key: TKey) -> Any? {
        return defaults.value(forKey: key.description)
    }
    
    public func get<T>(key: TKey) -> T? where T : Decodable {
        guard let data = defaults.object(forKey: key.description) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func get<T>(key: TKey, defaultValue: T) -> T where T : Decodable {
        guard let data = defaults.object(forKey: key.description) as? Data else { return defaultValue }
        return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }

    public func getBool(key: TKey) -> Bool {
        return defaults.bool(forKey: key.description)
    }

    public func getString(key: TKey) -> String? {
        return defaults.string(forKey: key.description)
    }
}
