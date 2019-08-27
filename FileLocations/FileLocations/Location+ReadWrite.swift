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

#if os(iOS) || os(tvOS)
import Foundation

//MARK: Read & Write Data
extension Location {
    //Data read.
    public func data() -> Data? {
        return manager.contents(atPath: path)
    }
    
    
    //Data write in one file.
    //Allowed:
    //  dir_loc.write(data: data, inFile: "file", attributes: attr)
    //etc.
    @discardableResult
    public func write(data: Data, inFile name: String, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        return manager.createFile(atPath: self[name].path, contents: data, attributes: attributes)
    }
    
    
    //Data save in current path.
    //Allowed:
    //  dir_loc["file"].save(data: data, attributes: attr)
    //  file_loc.save(data: data)
    //etc.
    @discardableResult
    public func save(data: Data, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        return manager.createFile(atPath: self.path, contents: data, attributes: attributes)
    }
}

//MARK: Read & Write String
extension Location {
    //String read.
    //Allowed:
    //   dir_loc["file"].string(encoding)
    //   file_loc.string()
    //etc.
    public func string(_ encoding: String.Encoding = .utf8) -> String? {
        return try? String(contentsOf: url, encoding: encoding)
    }
    
    
    //String write in one file.
    //Allowed:
    //   dir_loc.write(string: str, inFile: "file", encoding: encoding)
    //etc.
    @discardableResult
    public func write(string str: String, inFile name: String, encoding: String.Encoding = .utf8) -> Bool {
        do {
            let url = self[name].url
            try str.write(to: url, atomically: true, encoding: encoding)
            return true
        } catch { return false }
    }
    
    
    //String save in current path.
    //Allowed:
    //   file_loc.save(string: str)
    //   dir_loc["file"].save(string: str)
    //etc.
    @discardableResult
    public func save(string str: String, encoding: String.Encoding = .utf8) -> Bool {
        do {
            try str.write(to: self.url, atomically: true, encoding: encoding)
            return true
        } catch { return false }
    }
}

//MARK: Read & Write Dictionary
extension Location {
    //Dictionary read.
    //Allowed:
    //   dir_loc["file"].dictionary()
    //   file_loc.dictionary()
    //etc.
    public func dictionary() -> [AnyHashable: Any]? {
        return NSDictionary(contentsOf: url) as? [AnyHashable: Any]
    }
    
    
    //Dictionary write in one file.
    //Allowed:
    //   dir_loc.write(dictionary: dict, inFile: "file")
    //etc.
    @discardableResult
    public func write(dictionary dict: [AnyHashable: Any], inFile name: String) -> Bool {
        let url = self[name].url
        return NSDictionary(dictionary: dict).write(to: url, atomically: true)
    }
    
    
    //Dictonary save in current path.
    //Allowed:
    //   file_loc.save(string: str)
    //   dir_loc["file"].save(string: str)
    //etc.
    @discardableResult
    public func save(dictionary dict: [AnyHashable: Any]) -> Bool {
        return NSDictionary(dictionary: dict).write(to: self.url, atomically: true)
    }
}

//MARK: Read & Write Object
extension Location {
    //Object read.
    //Allowed:
    //   dir_loc["file"].unarchived()
    //   file_loc.unarchived()
    public func unarchived() -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path)
    }
    
    
    //Object archived and save in one file.
    //Allowed:
    //   dir_loc.archive(object: object, inFile: "file")
    @discardableResult
    public func archive(object: Any, inFile name: String) -> Bool {
        let path = self[name].path
        return NSKeyedArchiver.archiveRootObject(object, toFile: path)
    }
    
    
    //Object archived and save in current path.
    //Allowed:
    //   file_loc.archived(object: object)
    //   dir_loc["file"].archived(object: object)
    @discardableResult
    public func archived(object: Any) -> Bool {
        return NSKeyedArchiver.archiveRootObject(object, toFile: self.path)
    }
}


#endif
