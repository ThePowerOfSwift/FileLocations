//
//  Location.swift
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

internal let manager = FileManager.default

/// Location: Class to using FilaManager.
public class Location {
    /// Init with file url.
    public convenience init(fileURL url: URL) {
        self.init(url: url)
    }
    
    /// Init with file path.
    public convenience init(filePath: String) {
        let standard = NSString(string: filePath).standardizingPath
        let url = URL(fileURLWithPath: standard)
        self.init(fileURL: url)
    }
    
    /// Init with searchPath directory and searchPath domain mask.
    public convenience init(directory: FileManager.SearchPathDirectory, domain: FileManager.SearchPathDomainMask) {
        let path = NSSearchPathForDirectoriesInDomains(directory, domain, true).first ?? ""
        self.init(filePath: path)
    }
    
    /// Init with filePath components.
    public convenience init(filePathComponents comps: [String]) {
        let path = comps.filter { $0 != .pathSep }.joined(separator: .pathSep)
        self.init(filePath: path)
    }
    
    /// Init with general url.
    public init(url: URL) {
        self._url = url
    }
    
    /// Init with iCloud container.
    public init?(iCloudContainer container: String?) {
        if let u = manager.url(forUbiquityContainerIdentifier: container) {
            self._url = u
        } else { return nil }
    }
    
    /// Subscript path component.
    ///
    /// "/X/X", "X/X", "X"
    public subscript(_ component: String) -> Location {
        return Location(url: url.appendingPathComponent(component))
    }
    
    /// Returns path string.
    public var path: String {
        return url.path
    }
    
    /// Returns url.
    public var url: URL {
        return _url
    }
    
    /// Returns whether is in iCloudContainer.
    public var iCloudContained: Bool {
        return manager.isUbiquitousItem(at: self.url)
    }
    
    /// Internal url.
    private let _url: URL
}

//MARK: Locations` Common Properties.
extension Location {
    /// Check whether Location is Existent.
    public var isExist: Bool {
        return manager.fileExists(atPath: path)
    }
    
    /// Check whether Location is Directory and Existent.
    public var isDir: Bool {
        var isDir = ObjCBool(booleanLiteral: false)
        let isExist = manager.fileExists(atPath: path, isDirectory: &isDir)
        return isExist && isDir.boolValue
    }
    
    /// Check whether Location is File and Existent.
    public var isFile: Bool {
        var isDir = ObjCBool(booleanLiteral: false)
        let isExist = manager.fileExists(atPath: path, isDirectory: &isDir)
        return isExist && !isDir.boolValue
    }
    
    /// Check whether Location is Readable.
    public var isReadable: Bool {
        return manager.isReadableFile(atPath: path)
    }
    
    /// Check whether Location is Writable.
    public var isWritable: Bool {
        return manager.isWritableFile(atPath: path)
    }
    
    /// Check whether Location is Deletable.
    public var isDeletable: Bool {
        return manager.isDeletableFile(atPath: path)
    }
    
    /// Check whether Location is Executable.
    public var isExecutable: Bool {
        return manager.isExecutableFile(atPath: path)
    }
    
    /// Check whether Location is Symbolic Link.
    public var isSymbLink: Bool {
        return self.symbLinkDestination != nil
    }
    
    /// Location`s Symbolic Destination.
    public var symbLinkDestination: Location? {
        do {
            let dest = try manager.destinationOfSymbolicLink(atPath: path)
            return Location(filePath: dest)
        } catch { return nil }
    }
    
    /// URL`s Scheme.
    public var scheme: String? {
        return url.scheme
    }
    
    /// URL`s path Components.
    public var components: [String] {
        return url.pathComponents
    }
    
    /// Location`s Components to Display.
    public var componentsToDisplay: [String] {
        return manager.componentsToDisplay(forPath: path) ?? []
    }
    
    /// Location`s Display Name.
    public var displayName: String {
        return manager.displayName(atPath: path)
    }
    
    /// Location`s Path Extension.
    public var `extension`: String {
        return url.pathExtension
    }
    
    /// Location`s Last Path Component.
    public var lastComponent: String {
        return url.lastPathComponent
    }
    
    /// Location`s First N Path Components.
    public func firstComponents(number n: Int) -> [String] {
        guard n >= 0 else { return [] }
        var comps = self.components
        guard n < comps.count else { return comps }
        var res: [String] = []
        var number = n
        while number > 0 {
            let first = comps.removeFirst()
            res.append(first)
            number -= 1
        }
        return res
    }
    
    /// Location`s Last N Path Components.
    public func lastComponents(number n: Int) -> [String] {
        guard n >= 0 else { return [] }
        let comps = self.components
        guard n < comps.count else { return comps }
        var number = n
        var u = self.url
        var res: [String] = []
        while number > 0 {
            res.append(u.lastPathComponent)
            u.deleteLastPathComponent()
            number -= 1
        }
        return res.reversed()
    }
    
    /// Location`s Last Path Component without Extension.
    public var lastComponentWithoutExtension: String {
        return url.deletingPathExtension().lastPathComponent
    }
    
    /// Location`s Depth.
    public var depth: Int {
        return components.count
    }
    
    /// Longest Existent Location.
    public var maxValid: Location? {
        var current: Location? = self
        while let cur = current, !cur.isExist {
            current = cur.parent()
        }
        return current
    }
    
    /// local short path exclude preffix of home path.
    public func shortPath() -> String {
        let p = self.path
        let h = Location.home.path
        return p.hasPrefix(h) ? "\(p.dropFirst(h.count))" : p
    }
}


//MARK: Hashable
extension Location: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.url.absoluteString)
    }
}

//MARK: CustomStringConvertible
extension Location: CustomStringConvertible {
    public var description: String {
        return url.description
    }
}


extension String {
    internal static var pathSep: String { return "/" }
}


#endif



