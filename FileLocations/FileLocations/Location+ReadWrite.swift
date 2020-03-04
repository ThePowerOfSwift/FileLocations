//
//  Location+ReadWrite.swift
//  FileLocations
//
//  Copyright (c) 2019 Nick Meepo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if canImport(Foundation)
import Foundation

//MARK: Read & Write Data
extension Location {
    /// Returns Item Data.
    public func data() -> Data? {
        return manager.contents(atPath: path)
    }
    
    
    /// Data write in item.
    ///
    /// dir_loc.write(data: data, inFile: "file", attributes: attr)
    public func write(data: Data, inFile name: String, attributes: [FileAttributeKey : Any]? = nil)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        let res = manager.createFile(atPath: self[name].path, contents: data, attributes: attributes)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
    
    
    /// Data save in current path.
    ///
    /// dir_loc["file"].save(data: data, attributes: attr)
    ///
    /// file_loc.save(data: data)
    public func save(data: Data, attributes: [FileAttributeKey : Any]? = nil)throws {
        let res = manager.createFile(atPath: self.path, contents: data, attributes: attributes)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
}

//MARK: Read & Write String
extension Location {
    /// Return item string.
    ///
    /// dir_loc["file"].string(encoding)
    ///
    /// file_loc.string()
    public func string(_ encoding: String.Encoding = .utf8) -> String? {
        return try? String(contentsOf: url, encoding: encoding)
    }
    
    
    /// String write in item.
    ///
    /// dir_loc.write(string: str, inFile: "file", encoding: encoding)
    public func write(string str: String, inFile name: String, encoding: String.Encoding = .utf8)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        do {
            let url = self[name].url
            try str.write(to: url, atomically: true, encoding: encoding)
        } catch let error {
            throw LocationError.CreateFileFail(message: error.localizedDescription)
        }
    }
    
    /// String save in current path.
    ///
    /// file_loc.save(string: str)
    ///
    /// dir_loc["file"].save(string: str)
    public func save(string str: String, encoding: String.Encoding = .utf8)throws {
        do {
            try str.write(to: self.url, atomically: true, encoding: encoding)
        } catch {
            throw LocationError.CreateFileFail(message: error.localizedDescription)
        }
    }
}

//MARK: Read & Write Dictionary
extension Location {
    /// Return item dictionary.
    ///
    /// dir_loc["file"].dictionary()
    ///
    /// file_loc.dictionary()
    public func dictionary() -> [String: Any]? {
        return NSDictionary(contentsOf: url) as? [String: Any]
    }
    
    /// Dictionary write in item.
    ///
    /// dir_loc.write(dictionary: dict, inFile: "file")
    public func write(dictionary: [String: Any], inFile name: String)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        let url = self[name].url
        let res = NSDictionary(dictionary: dictionary).write(to: url, atomically: true)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
    
    /// Dictonary save in current path.
    ///
    /// file_loc.save(dictionary: str)
    ///
    /// dir_loc["file"].save(dictionary: str)
    public func save(dictionary: [String: Any])throws {
        let res = NSDictionary(dictionary: dictionary).write(to: self.url, atomically: true)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
}

//MARK: Read & Write Array
extension Location {
    /// Returns item array.
    ///
    /// dir_loc["file"].array()
    ///
    /// file_loc.array()
    public func array() -> [Any]? {
        return NSArray(contentsOf: url) as? [Any]
    }
    
    /// Array write in item.
    ///
    /// dir_loc.write(array: array, inFile: "file")
    public func write(array: [Any], inFile name: String)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        let url = self[name].url
        let res = NSArray(array: array).write(to: url, atomically: true)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
    
    /// Array save in current path.
    ///
    /// file_loc.save(string: str)
    ///
    /// dir_loc["file"].save(string: str)
    public func save(array: [Any])throws {
        let res = NSArray(array: array).write(to: self.url, atomically: true)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
}

//MARK: Read & Write Object
extension Location {
    /// Returns item object.
    ///
    /// dir_loc["file"].unarchived()
    ///
    /// file_loc.unarchived()
    public func unarchived() -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path)
    }
    
    
    /// Object archived and save in item.
    ///
    /// dir_loc.archive(object: object, inFile: "file")
    public func archive(object: Any, inFile name: String)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        let path = self[name].path
        let res = NSKeyedArchiver.archiveRootObject(object, toFile: path)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
    
    
    /// Object archived and save in current path.
    ///
    /// file_loc.archived(object: object)
    ///
    /// dir_loc["file"].archived(object: object)
    public func archived(object: Any)throws {
        let res = NSKeyedArchiver.archiveRootObject(object, toFile: self.path)
        if !res {
            throw LocationError.CreateFileFail(message: nil)
        }
    }
}


#endif
