//
//  Common.swift
//  CovidCases
//
//  Created by Imthath M on 04/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation
import UIKit

protocol Location {
    var name: String { get }
    var id: String { get }
    var totalCases: Int { get }
    var activeCases: Int { get }
    var recoveredCases: Int { get }
}

extension String {
    var date: Date? {
        Cache.dateFormatter.date(from: self)
    }
    
    var number: Int { Int(self) ?? 0 }
}

class Cache {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}

@propertyWrapper
public struct SDDefault<T> {
    let key: String
    let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

public struct Defaults {
    @SDDefault("updatedTime", defaultValue: nil)
    static var updatedTime: Date?
}

public protocol LoggerProtocol {
    func log(_ message: String)
}

internal class Console: LoggerProtocol {
    internal static let shared = Console()
    
    private init() { }
    
    func log(_ message: String) {
        print(message)
    }
}

public class FileIO {
    
    let logger: LoggerProtocol
    public static let shared = FileIO(logger: Console.shared)
    
    private var encoder: JSONEncoder { JSONEncoder() }
    private var decoder: JSONDecoder { JSONDecoder() }
    
    public init(logger: LoggerProtocol) {
        self.logger = logger
    }

    public func getBundledObject<T: Codable>(inFile filename: String, ofType type: FileType) -> T? {
        guard let bundlePath = Bundle(for: FileIO.self)
            .path(forResource: filename, ofType: type.rawValue),
            let data = try? Data(contentsOf: URL(fileURLWithPath: bundlePath)) else {
                return nil
        }
        
        let object = try? decoder.decode(T.self, from: data)
        print("\(filename).\(type.rawValue) is loaded from bundle")
        return object
    }
//    public func getOjbectsFromFile<T: Codable>(named name: String, withType type: FileType) -> [T] {
//        var objects = [T]()
//        do {
//            if let data = readData(from: name, type: type) {
//                objects = try decoder.decode([T].self, from: data)
//            }
//        } catch let error as NSError {
//            logger.log("unable to decode objects from text file: \(error.description)")
//        }
//        return objects
//    }

    public func getOjbectFromFile<T: Codable>(named name: String, withType type: FileType) -> T? {
        var object: T?
        do {
            if let data = readData(from: name, type: type) {
                object = try decoder.decode(T.self, from: data)
            }
        } catch let error as NSError {
            logger.log("unable to decode object from text file: \(error.description)")
        }
        return object
    }

    public func save<T>(_ object: T, to name: String, as type: FileType = .text) where T: Codable {
        do {
            encoder.outputFormatting = .prettyPrinted
            
            let url = try getUrl(of: name, type: type)
            let data = try encoder.encode(object)
            
            switch type {
            case .text:
                if let text = String(data: data, encoding: .utf8) {
                    try text.write(to: url, atomically: true, encoding: .utf8)
                    logger.log("Saved text file \(name)")
                }
            case .json:
                try data.write(to: url)
                logger.log("Saved \(name).\(type.rawValue)")
            }
            
        } catch let error as NSError {
            logger.log("unable to save: \(error.description)")
        }
    }

    public func readData(from name: String, type: FileType) -> Data? {
        var result: Data?
        do {
            let url = try getUrl(of: name, type: type)
            result = try Data(contentsOf: url)
        } catch let error as NSError {
            logger.log("unable to read data of type \(type.rawValue) from file \(name)")
            logger.log("Error: \(error.description)")
        }
        return result
    }

    public func readText(from name: String) -> String? {
        var result: String?
        do {
            let url = try getUrl(of: name)
            result = try String(contentsOf: url)
        } catch let error as NSError {
            logger.log("unable to read text from file \(name)")
            logger.log("Error: \(error.description)")
        }
        return result
    }

    public func getUrl(of name: String, type: FileType = .json) throws -> URL {
        let docDirectoryUrl = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)
        return docDirectoryUrl.appendingPathComponent(name).appendingPathExtension(type.rawValue)
    }
}

public enum FileType: String {
    case text = "txt"
    case json = "json"
}

final class Device: ObservableObject {

    public static let shared = Device()

    enum Orientation {
        case portrait
        case landscape
    }

    @Published var orientation: Orientation

    private var _observer: NSObjectProtocol?

    private init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        }
        else {
            self.orientation = .portrait
        }

        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                self.orientation = .portrait
            }
            else if device.orientation.isLandscape {
                self.orientation = .landscape
            }
        }
    }

    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
