//
//  Location+Manipulations.swift
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


//MARK: Locations` Manipulations.
extension Location {
    /// Make Directory without intermediates.
    ///
    /// dir_loc.mkdir(name: "dir", attributes: attr)
    public func mkdir(name: String, attributes: [FileAttributeKey : Any]? = nil)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        do {
            let path = self[name].path
            try manager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: attributes)
        } catch let error {
            throw LocationError.CreateDirectoryFail(message: error.localizedDescription)
        }
    }
    
    
    /// Make Directory without intermediates in current Path.
    ///
    /// dir_loc["dir"].mkdir(attributes: attr)
    ///
    /// dir_loc.mkdir()
    public func mkdir(attributes: [FileAttributeKey : Any]? = nil)throws {
        do {
            try manager.createDirectory(atPath: self.path, withIntermediateDirectories: false, attributes: attributes)
        } catch let error {
            throw LocationError.CreateDirectoryFail(message: error.localizedDescription)
        }
    }
    
    
    /// Make Directory with intermediates directories.
    ///
    /// dir_loc.mkpath(name: "dir", attributes: attr)
    public func mkpath(name: String, attributes: [FileAttributeKey : Any]? = nil)throws {
        guard !name.isEmpty else {
            throw LocationError.NameEmptyError
        }
        do {
            let path = self[name].path
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attributes)
        } catch let error {
            throw LocationError.CreateDirectoryFail(message: error.localizedDescription)
        }
    }
    
    
    /// Make Directory with intermediates directories in current Path.
    ///
    /// dir_loc["dir"].mkpath(attributes: attr)
    ///
    /// dir_loc.mkpath()
    public func mkpath(attributes: [FileAttributeKey : Any]? = nil)throws {
        do {
            try manager.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: attributes)
        } catch let error {
            throw LocationError.CreateDirectoryFail(message: error.localizedDescription)
        }
    }
    
    
    /// Remove Location.
    public func removed()throws {
        do {
            try manager.removeItem(at: url)
        } catch let error {
            throw LocationError.RemoveItemFail(message: error.localizedDescription)
        }
    }
    
    /// Move Location to Trash.
    @available(iOS 11.0, *)
    public func trashed()throws -> Location {
        do {
            var trashedURL: NSURL? = nil
            try manager.trashItem(at: self.url, resultingItemURL: &trashedURL)
            if let trashedURL = trashedURL {
                return Location(url: trashedURL as URL)
            } else {
                throw LocationError.TrashItemFail(message: nil)
            }
        } catch let error {
            throw LocationError.TrashItemFail(message: error.localizedDescription)
        }
    }
    
    /// Remove All Children.
    public func clear()throws {
        try self.children().forEach {
            try $0.removed()
        }
    }
    
    
    /// Copy Location to argument Directory. renamed is Setted when you need to rename the copied item. Return new copied location or nil.
    ///
    /// loc.copy(toDir: dir_loc)
    ///
    /// loc.copy(toDir: dir_loc, renamed: "loc2")
    @discardableResult
    public func copy(toDir loc: Location, renamed name: String? = nil)throws -> Location {
        guard loc.isDir else {
            throw LocationError.NeedDirectoryItem
        }
        do {
            let name = (name == nil || name!.isEmpty) ? lastComponent : name!
            try manager.copyItem(at: url, to: loc[name].url)
            return loc[name]
        } catch let error {
            throw LocationError.CopyItemFail(message: error.localizedDescription)
        }
    }
    
    
    /// Move Location to argument Directory. renamed is Setted when you need to rename the moved item. Return new moved location or nil.
    ///
    /// loc.move(toDir: dir_loc)
    ///
    /// loc.move(toDir: dir_loc, renamed: "loc2")
    @discardableResult
    public func move(toDir loc: Location, renamed name: String? = nil)throws -> Location {
        guard loc.isDir else {
            throw LocationError.NeedDirectoryItem
        }
        do {
            let name = (name == nil || name!.isEmpty) ? lastComponent : name!
            try manager.moveItem(at: url, to: loc[name].url)
            return loc[name]
        } catch {
            throw LocationError.MoveItemFail(message: error.localizedDescription)
        }
    }
    
    
    /// Rename Location. Return new renamed location or nil.
    public func renamed(_ name: String)throws -> Location {
        guard let parent = self.parent() else {
            throw LocationError.NeedParentItem
        }
        do {
            try manager.moveItem(at: url, to: parent[name].url)
            return parent[name]
        } catch let error {
            throw LocationError.RenameItemFail(message: error.localizedDescription)
        }
    }
    
    
    /// Link Location under other Directory. renamed is Setted when you need to rename the linked item. Return new linked location or nil.
    ///
    /// loc.link(toDir: dir_loc, renamed: "loc2")
    ///
    /// loc.link(toDir: dir_loc)
    @discardableResult
    public func link(toDir loc: Location, renamed name: String? = nil)throws -> Location {
        guard loc.isDir else {
            throw LocationError.NeedDirectoryItem
        }
        do {
            let name = (name == nil) ? lastComponent : name!
            try manager.linkItem(at: url, to: loc[name].url)
            return loc[name]
        } catch let error {
            throw LocationError.LinkItemFail(message: error.localizedDescription)
        }
    }
    
    /// Symbolic Link Location under other Directory. renamed is Setted when you need to rename the linked item. Return new symbolic linked location or nil.
    @discardableResult
    public func symbLink(toDir loc: Location, renamed name: String? = nil)throws -> Location {
        guard loc.isDir else {
            throw LocationError.NeedDirectoryItem
        }
        do {
            let name = (name == nil) ? lastComponent : name!
            try manager.createSymbolicLink(at: url, withDestinationURL: loc[name].url)
            return loc[name]
        } catch let error {
            throw LocationError.SymbolicLinkItemFail(message: error.localizedDescription)
        }
    }
    
    
    /// Savely Replace Location to other Location.
    public func replace(with loc: Location, backupName: String? = nil, options: FileManager.ItemReplacementOptions = .usingNewMetadataOnly)throws {
        do {
            try manager.replaceItem(at: url, withItemAt: loc.url, backupItemName: backupName, options: options, resultingItemURL: nil)
        } catch let error {
            throw LocationError.ReplaceItemFail(message: error.localizedDescription)
        }
    }
}


#endif
