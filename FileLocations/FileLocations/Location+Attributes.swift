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

#if os(iOS) || os(tvOS)
import Foundation


//MARK: Locations` File Attributes.
extension Location {
    //Set Location`s Attributes.
    @discardableResult
    public func setAttributes(_ attributes: [FileAttributeKey: Any]) -> Bool {
        do {
            try manager.setAttributes(attributes, ofItemAtPath: path)
            return true
        } catch { return false }
    }
    
    
    //Set Location`s One Attribute.
    @discardableResult
    public func setAttribute(_ key: FileAttributeKey, value: Any) -> Bool {
        let res = self.setAttributes([key: value])
        if !res { NSLog("setAttribute \(key) fail!") }
        return res
    }
    
    
    //Attributes Read.
    public var attributes: [FileAttributeKey : Any] {
        return (try? manager.attributesOfItem(atPath: path)) ?? [:]
    }
    
    
    //Get the file’s type.
    public var type: FileAttributeType? {
        return attributes[.type] as? FileAttributeType
    }
    
    
    //Get the file’s size in bytes.
    public var byteSize: UInt64? {
        return attributes[.size] as? UInt64
    }
    
    
    //Get&Set the file's creation date.
    public var creationDate: Date? {
        get { return attributes[.creationDate] as? Date }
        set {
            if let v = newValue { setAttribute(.creationDate, value: v) }
        }
    }
    
    
    //Get&Set the file’s last modified date.
    public var modificationDate: Date? {
        get { return attributes[.modificationDate] as? Date }
        set {
            if let v = newValue { setAttribute(.modificationDate, value: v) }
        }
    }
    
    
    //Get the file’s reference count.
    public var referenceCount: Int? {
        return attributes[.referenceCount] as? Int
    }
    
    
    //Get the identifier for the device on which the file resides.
    public var deviceIdentifier: Int64? {
        return attributes[.deviceIdentifier] as? Int64
    }
    
    //Get&Set the name of the file’s owner.
    public var ownerAccountName: String? {
        get { return attributes[.ownerAccountName] as? String }
        set {
            if let v = newValue { setAttribute(.ownerAccountName, value: v) }
        }
    }
    
    
    //Get&Set the file’s owner's account ID.
    public var ownerAccountID: Int64? {
        get { return attributes[.ownerAccountID] as? Int64 }
        set {
            if let v = newValue { setAttribute(.ownerAccountID, value: v) }
        }
    }
    
    
    //Get&Set the group name of the file’s owner.
    public var groupOwnerAccountName: String? {
        get { return attributes[.groupOwnerAccountName] as? String }
        set {
            if let v = newValue { setAttribute(.groupOwnerAccountName, value: v) }
        }
    }
    
    
    //Get&Set the file’s group ID.
    public var groupOwnerAccountID: Int64? {
        get { return attributes[.groupOwnerAccountID] as? Int64 }
        set {
            if let v = newValue { setAttribute(.groupOwnerAccountID, value: v) }
        }
    }
    
    
    //Get&Set the file’s Posix permissions.
    public var posixPermissions: Int? {
        get { return attributes[.posixPermissions] as? Int }
        set {
            if let v = newValue { setAttribute(.posixPermissions, value: v) }
        }
    }
    
    
    //Get&Set whether the file’s extension is hidden.
    public var isExtensionHidden: Bool? {
        get { return attributes[.extensionHidden] as? Bool }
        set {
            if let v = newValue { setAttribute(.extensionHidden, value: v) }
        }
    }
    
    
    //Get&Set the file’s HFS creator code.
    public var hfsCreatorCode: Int64? {
        get { return attributes[.hfsCreatorCode] as? Int64 }
        set {
            if let v = newValue { setAttribute(.hfsCreatorCode, value: v) }
        }
    }
    
    
    //Get&Set the file’s HFS type code.
    public var hfsTypeCode: Int64? {
        get { return attributes[.hfsTypeCode] as? Int64 }
        set {
            if let v = newValue { setAttribute(.hfsTypeCode, value: v) }
        }
    }
    
    
    //Get&Set Is Immutable Attribute.
    public var isImmutable: Bool? {
        get { return attributes[.immutable] as? Bool }
        set {
            if let v = newValue { setAttribute(.immutable, value: v) }
        }
    }
    
    
    //Get whether the file is read-only.
    public var isAppendOnly: Bool? {
        get { return attributes[.appendOnly] as? Bool }
        set { setAttribute(.appendOnly, value: newValue ?? false) }
    }
    
    
    //Get whether the file is busy.
    public var isBusy: Bool? {
        get { return attributes[.busy] as? Bool }
        set { setAttribute(.busy, value: newValue ?? false) }
    }
    
    
    //Get the protection level for this file.
    public var protectionKey: FileProtectionType? {
        get { return attributes[.protectionKey] as? FileProtectionType }
        set { setAttribute(.protectionKey, value: newValue ?? FileProtectionType.completeUntilFirstUserAuthentication)}
    }
    
    
    //Get the file`s filesystem file number of File System. The corresponding value is an NSNumber object containing an unsigned long. The value corresponds to the value of st_ino, as returned by stat(2).
    public var systemFileNumber: Int64? {
        return attributes[.systemFileNumber] as? Int64
    }
}

//MARK: Locations` FileSystem Attributes.
extension Location {
    //Attributes Read.
    public static var attributesOfFilsSystem: [FileAttributeKey : Any] {
        let loc = Location.home
        return (try? manager.attributesOfFileSystem(forPath: loc.path)) ?? [:]
    }
    
    
    //Get Size of File System.
    public static var systemBytesSize: UInt64? {
        return attributesOfFilsSystem[.systemSize] as? UInt64
    }
    
    
    //Get Free Size of File System.
    public static var systemFreeBytesSize: UInt64? {
        return attributesOfFilsSystem[.systemFreeSize] as? UInt64
    }
    
    
    //Get the Number of Nodes in File System.
    public static var systemNodes: UInt64? {
        return attributesOfFilsSystem[.systemNodes] as? UInt64
    }
    
    
    //Get the Number of Free Nodes in File System.
    public static var systemFreeNodes: UInt64? {
        return attributesOfFilsSystem[.systemFreeNodes] as? UInt64
    }
    
    
    //Get the filesystem number of File System. The value corresponds to the value of st_dev, as returned by stat(2).
    public static var systemNumber: UInt64? {
        return attributesOfFilsSystem[.systemNumber] as? UInt64
    }
}


#endif
