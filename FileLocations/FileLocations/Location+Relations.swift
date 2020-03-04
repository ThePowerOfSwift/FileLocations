//
//  Location+Relation.swift
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


//MARK: Locations` Relation
extension Location: Equatable {
    /// Check Contents is Equal.
    ///
    /// Situation When Any location is not existent will return false.
    public func contentsEqual(to loc: Location) -> Bool {
        return manager.contentsEqual(atPath: path, andPath: loc.path)
    }
    
    
    /// Check Locations` Relation.
    ///
    /// Situation When Any location is not existent will return nil.
    public func relation(with loc: Location) -> FileManager.URLRelationship? {
        do {
            var rel = FileManager.URLRelationship.other
            try manager.getRelationship(&rel, ofDirectoryAt: url, toItemAt: loc.url)
            return rel
        } catch { return nil }
    }
    
    
    /// Fetch Child locations.
    public func children() -> [Location] {
        let contentsOfDirectory = (try? manager.contentsOfDirectory(atPath: path)) ?? []
        return contentsOfDirectory.map { self[$0] }
    }
    
    
    /// Fetch Descendant locations.
    public func descendants() -> [Location] {
        return manager.subpaths(atPath: path)?.map { self[$0] } ?? []
    }
    
    
    /// Fetch Sub Files with recursive option.
    public func subFiles(recursive: Bool = false) -> [Location] {
        return (recursive ? self.descendants() : self.children()).filter { $0.isFile }
    }
    
    
    /// Fetch Sub Directories with recursive option.
    public func subDirs(recursive: Bool = false) -> [Location] {
        return (recursive ? self.descendants() : self.children()).filter { $0.isDir }
    }
    
    
    /// Location`s Parent.
    ///
    /// Allowed Whether Current Location is Existent.
    public func parent() -> Location? {
        guard url.path != String.pathSep  else { return nil }
        return Location(url: url.deletingLastPathComponent() )
    }
    
    
    /// Fetch Location`s Siblings.
    ///
    /// Need Current Location Exists.
    public func siblings() -> [Location] {
        guard self.isExist else { return [] }
        return self.parent()?.children().filter { $0 != self } ?? []
    }
    
    
    /// Check whether Location is Final.
    public var isFinal: Bool {
        return self.isFile || (self.children().count == 0)
    }
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.url == rhs.url
    }
    
    public static func !=(lhs: Location, rhs: Location) -> Bool {
        return !(lhs == rhs)
    }
    
}



#endif
