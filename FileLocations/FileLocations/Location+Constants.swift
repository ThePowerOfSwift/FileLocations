//
//  Location+Constants.swift
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


//MARK: Constant Locations.
public extension Location {
    static let root =
        Location(filePath: .pathSep)
    
    static let userDocument =
        Location(directory: .documentDirectory, domain: .userDomainMask)
    
    static let userCache =
        Location(directory: .cachesDirectory, domain: .userDomainMask)
    
    static let userLibrary =
        Location(directory: .libraryDirectory, domain: .userDomainMask)
    
    static let applicationSupport =
        Location(directory: .applicationSupportDirectory, domain: .userDomainMask)
    
    static let bundle =
        Location(filePath: Bundle.main.bundlePath)
    
    static let home =
        Location(filePath: NSHomeDirectory())
    
    static let temporary =
        Location(filePath: NSTemporaryDirectory())
    
}


#endif