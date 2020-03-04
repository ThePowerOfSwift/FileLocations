//
//  Location+Attributes.swift
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


//MARK: Locations` File Attributes.
extension Location {
    /// Set Location`s attributes.
    public func setAttributes(_ attributes: [FileAttributeKey: Any])throws {
        do {
            try manager.setAttributes(attributes, ofItemAtPath: path)
        } catch let error {
            throw LocationError.SetAttributesFail(message: error.localizedDescription)
        }
    }
    
    /// Set Location`s given attribute.
    public func setAttribute(_ key: FileAttributeKey, value: Any)throws {
        try self.setAttributes([key: value])
    }
    
    /// Returns file attributes.
    public var attributes: [FileAttributeKey : Any] {
        return (try? manager.attributesOfItem(atPath: path)) ?? [:]
    }
    
    /// Returns file’s type.
    public var type: FileAttributeType? {
        return attributes[.type] as? FileAttributeType
    }
    
    /// Returns file’s size in bytes.
    public var byteSize: UInt64? {
        return attributes[.size] as? UInt64
    }
    
    /// Returns file's creation date.
    public var creationDate: Date? {
        return attributes[.creationDate] as? Date
    }
    
    /// Sets file's creation date.
    public func setCreationDate(_ date: Date)throws {
        try setAttribute(.creationDate, value: date)
    }
    
    /// Returns file’s last modified date.
    public var modificationDate: Date? {
        return attributes[.modificationDate] as? Date
    }
    
    /// Sets file's creation date.
    public func setModificationDate(_ date: Date)throws {
        try setAttribute(.modificationDate, value: date)
    }
    
    /// Retuturns file’s reference count.
    public var referenceCount: Int? {
        return attributes[.referenceCount] as? Int
    }
    
    /// Returns identifier for the device on which currents file resides.
    public var deviceIdentifier: Int64? {
        return attributes[.deviceIdentifier] as? Int64
    }
    
    /// Returns the name of file owner.
    public var ownerName: String? {
        return attributes[.ownerAccountName] as? String
    }
    
    /// Setss the name of file owner.
    public func setOwnerName(_ name: String)throws {
        try setAttribute(.ownerAccountName, value: name)
    }
    
    /// Returns file owner's account ID.
    public var ownerID: Int64? {
        return attributes[.ownerAccountID] as? Int64
    }
    
    /// Sets file owner's account ID.
    public func setOwnerID(_ id: Int64)throws {
        try setAttribute(.ownerAccountID, value: id)
    }
    
    /// Returns the group name of file owner.
    public var groupOwnerName: String? {
        return attributes[.groupOwnerAccountName] as? String
    }
    
    /// Sets file owner's account ID.
    public func setGroupOwnerName(_ name: String)throws {
        try setAttribute(.groupOwnerAccountName, value: name)
    }
    
    /// Returns the file’s group ID.
    public var groupOwnerID: Int64? {
        return attributes[.groupOwnerAccountID] as? Int64
    }
    
    /// Sets file owner's account ID.
    public func setGroupOwnerID(_ id: Int64)throws {
        try setAttribute(.groupOwnerAccountID, value: id)
    }
    
    /// Returns file’s Posix permissions.
    public var posixPermissions: Int? {
        return attributes[.posixPermissions] as? Int
    }
    
    /// Sets file’s Posix permissions.
    public func setPosixPermissions(_ permissions: Int)throws {
        try setAttribute(.posixPermissions, value: permissions)
    }
    
    //Get&Set whether the file’s extension is hidden.
    public var isExtensionHidden: Bool? {
        return attributes[.extensionHidden] as? Bool
    }
    
    /// Sets file’s Posix permissions.
    public func setExtensionHidden(_ hidden: Bool)throws {
        try setAttribute(.extensionHidden, value: hidden)
    }
    
    /// Returns file’s HFS creator code.
    public var HFSCreatorCode: Int64? {
        return attributes[.hfsCreatorCode] as? Int64
    }
    
    /// Sets file’s HFS creator code.
    public func setHFSCreatorCode(_ code: Int64)throws {
        try setAttribute(.hfsCreatorCode, value: code)
    }
    
    /// Returns file’s HFS type code.
    public var HFSTypeCode: Int64? {
        return attributes[.hfsTypeCode] as? Int64
    }
    
    /// Sets file’s HFS type code.
    public func setHFSTypeCode(_ code: Int64)throws {
        try setAttribute(.hfsTypeCode, value: code)
    }
    
    /// Returns whether file is immutable.
    public var isImmutable: Bool? {
        return attributes[.immutable] as? Bool
    }
    
    /// Sets whether file is immutable.
    public func setImmutable(_ immutable: Bool)throws {
        try setAttribute(.immutable, value: immutable)
    }
    
    /// Returns whether file is read-only.
    public var isAppendOnly: Bool? {
        return attributes[.appendOnly] as? Bool
    }
    
    /// Sets whether file is read-only.
    public func setAppendOnly(_ appendOnly: Bool)throws {
        try setAttribute(.appendOnly, value: appendOnly)
    }
    
    /// Returns whether file is busy.
    public var isBusy: Bool? {
        return attributes[.busy] as? Bool
    }
    
    /// Sets whether file is busy.
    public func setBusy(_ busy: Bool)throws {
        try setAttribute(.busy, value: busy)
    }
    
    /// Returns the protection level of file.
    public var protectionKey: FileProtectionType? {
        return attributes[.protectionKey] as? FileProtectionType
    }
    
    /// Sets the protection level of file.
    public func setProtectionKey(_ key: FileProtectionType)throws {
        try setAttribute(.protectionKey, value: key)
    }
    
    /// Returns file`s file number in FilesSystem. The corresponding value is an NSNumber object containing an unsigned long. The value corresponds to the value of st_ino, as returned by stat(2).
    public var systemFileNumber: Int64? {
        return attributes[.systemFileNumber] as? Int64
    }
}

//MARK: Locations` FileSystem Attributes.
extension Location {
    /// Returns attributes of FilesSystem.
    public static var attributesOfFilsSystem: [FileAttributeKey : Any] {
        return (try? manager.attributesOfFileSystem(forPath: Location.home.path)) ?? [:]
    }
    
    
    /// Returns size of FilesSystem.
    public static var systemBytesSize: UInt64? {
        return attributesOfFilsSystem[.systemSize] as? UInt64
    }
    
    
    /// Returns Free Size of FilesSystem.
    public static var systemFreeBytesSize: UInt64? {
        return attributesOfFilsSystem[.systemFreeSize] as? UInt64
    }
    
    
    /// Returns number of Nodes in FilesSystem.
    public static var systemNodes: UInt64? {
        return attributesOfFilsSystem[.systemNodes] as? UInt64
    }
    
    /// Returns number of free nodes in FilesSystem.
    public static var systemFreeNodes: UInt64? {
        return attributesOfFilsSystem[.systemFreeNodes] as? UInt64
    }
    
    /// Returns the filesystem number of File System. The value corresponds to the value of st_dev, as returned by stat(2).
    public static var systemNumber: UInt64? {
        return attributesOfFilsSystem[.systemNumber] as? UInt64
    }
}


#endif
