//
//  LocalJsonFile.swift
//  sysvpn-macos
//
//  Created by doragon on 07/10/2022.
//

import Foundation

enum FileLocalName: String {
    case listCountry = "list_country"
}

struct LocalJsonFile {
    static var shared: LocalJsonFile = .init()
    
    func loadConfig(file: FileLocalName) -> Data? {
        guard let url = Bundle.main.url(forResource: file.rawValue.withBuildType, withExtension: "json") else {
            return nil
        }
        var data: Data?
        do {
            data = try Data(contentsOf: url)
            return data
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    func cacheFile(file: FileLocalName, data: Data) {
        print("[CacheConfig] save data to file \(file) success")
        let urlFile = saveFilePath().appendingPathComponent(file.rawValue)
        try? data.write(to: urlFile)
    }
     
    func saveFilePath() -> URL {
        let fm = FileManager.default
        let file = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return file
    }
}

extension String {
    var withBuildType: String {
        if contains("-dev") || contains("-prod") {
            return self
        }
        #if DEV
            return self + "-dev"
        #else
            return self + "-prod"
        #endif
    }
}

public extension FileManager {
    func exist(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists
    }
}
