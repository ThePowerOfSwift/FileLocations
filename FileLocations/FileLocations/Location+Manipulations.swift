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

#if os(iOS) || os(tvOS)
import Foundation


//MARK: Locations` Manipulations.
extension Location {
    //Make Directory without intermediates.
    //Allowed:
    //   dir_loc.mkdir(name: "dir", attributes: attr)
    //etc.
    @discardableResult
    public func mkdir(name: String, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        guard !name.isEmpty else { return false }
        do {
            let path = self[name].path
            try manager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: attributes)
            return true
        } catch { return false }
    }
    
    
    //Make Directory without intermediates in Self`s Path.
    //Allowed:
    //   dir_loc["dir"].mkdir(attributes: attr)
    //   dir_loc.mkdir()
    //etc.
    @discardableResult
    public func mkdir(attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        do {
            try manager.createDirectory(atPath: self.path, withIntermediateDirectories: false, attributes: attributes)
            return true
        } catch { return false }
    }
    
    
    //Make Directory with intermediates directories.
    //Allowed:
    //Allowed:
    //   dir_loc.mkpath(name: "dir", attributes: attr)
    //etc.
    @discardableResult
    public func mkpath(name: String, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        do {
            let path = self[name].path
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attributes)
            return true
        } catch { return false }
    }
    
    
    //Make Directory with intermediates directories in Self`s Path.
    //Allowed:
    //   dir_loc["dir"].mkpath(attributes: attr)
    //   dir_loc.mkpath()
    //etc.
    @discardableResult
    public func mkpath(attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        do {
            try manager.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: attributes)
            return true
        } catch { return false }
    }
    
    
    //Remove Location.
    @discardableResult
    public func removed() -> Bool {
        do {
            try manager.removeItem(at: url)
            return true
        } catch { return false }
    }
    
    
    //Move Location to Trash.
    @discardableResult
    @available(iOS 11.0, *)
    public func trashed() -> Location? {
        do {
            var trashedURL: NSURL? = nil
            try manager.trashItem(at: self.url, resultingItemURL: &trashedURL)
            if let trashedURL = trashedURL {
                return Location(url: trashedURL as URL)
            } else {
                return nil
            }
        } catch { return nil }
    }
    
    
    //Clear All Children.
    @discardableResult
    public func clear() -> Bool {
        var res = true
        for each in self.children() {
            res = res && each.removed()
        }
        return res
    }
    
    
    //Copy Location under other Directory. renamed is Setted when you need to rename the copied item. Return new copied location or nil.
    //Allowed:
    //   loc.copy(toDir: dir_loc)
    //   loc.copy(toDir: dir_loc, renamed: "loc2")
    //etc.
    @discardableResult
    public func copy(toDir loc: Location, renamed name: String? = nil) -> Location? {
        guard loc.isDir else { return nil }
        do {
            let name = (name == nil) ? lastComponent : name!
            try manager.copyItem(at: url, to: loc[name].url)
            return loc[name]
        } catch { return nil }
    }
    
    
    //Move Location under other Directory. renamed is Setted when you need to rename the moved item. Return new moved location or nil.
    //Allowed:
    //   loc.move(toDir: dir_loc)
    //   loc.move(toDir: dir_loc, renamed: "loc2")
    //etc.
    @discardableResult
    public func move(toDir loc: Location, renamed name: String? = nil) -> Location? {
        guard loc.isDir else { return nil }
        do {
            let name = (name == nil) ? lastComponent : name!
            try manager.moveItem(at: url, to: loc[name].url)
            return loc[name]
        } catch { return nil }
    }
    
    
    //Rename Location. Return new renamed location or nil.
    @discardableResult
    public func renamed(_ name: String) -> Location? {
        guard let parent = self.parent() else { return nil }
        do {
            try manager.moveItem(at: url, to: parent[name].url)
            return parent[name]
        } catch { return nil }
    }
    
    
    //Link Location under other Directory. renamed is Setted when you need to rename the linked item. Return new linked location or nil.
    //Allowed:
    //   loc.link(toDir: dir_loc, renamed: "loc2")
    //   loc.link(toDir: dir_loc)
    //etc.
    @discardableResult
    public func link(toDir loc: Location, renamed name: String? = nil) -> Location? {
        guard loc.isDir else { return nil }
        do {
            let name = (name == nil) ? lastComponent : name!
            try manager.linkItem(at: url, to: loc[name].url)
            return loc[name]
        } catch { return nil }
    }
    
    //Symbolic Link Location under other Directory. renamed is Setted when you need to rename the linked item. Return new symbolic linked location or nil.
    //Allowed:
    //
//    @discardableResult
//    public func symbLink(toDir loc: Location, renamed name: String? = nil) -> Location? {
//        guard loc.isDir else { return nil }
//        do {
//            let name = (name == nil) ? lastComponent : name!
//            try manager.createSymbolicLink(at: url, withDestinationURL: loc[name].url)
//            return loc[name]
//        } catch { return nil }
//    }
    
    
    //TODO: Need to be better.
    //Savely Replace Location to other Location.
//    @discardableResult
//    public func replace(with loc: Location, backupName: String? = nil, options: FileManager.ItemReplacementOptions = .usingNewMetadataOnly) -> Bool {
//        do {
//            try manager.replaceItem(at: url, withItemAt: loc.url, backupItemName: backupName, options: options, resultingItemURL: nil)
//            return true
//        } catch { return false }
//    }
}


#endif
