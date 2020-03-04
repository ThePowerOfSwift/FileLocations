//
//  Location+UTI.swift
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

#if canImport(MobileCoreServices)
#if canImport(Foundation)
import MobileCoreServices
import Foundation



extension Location {
    /// Request the UTI via the file extension
    public func uti() -> String? {
        guard !self.extension.isEmpty else { return nil }
        let ext = NSString(string: self.extension) as CFString
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil) else { return nil }
        return String(uti.takeUnretainedValue())
    }
    
    /// Request the Mime via the file extension
    public func mime() -> String? {
        guard let uti = self.uti() else { return nil }
        let utiStr = NSString(string: uti) as CFString
        guard let res = UTTypeCopyPreferredTagWithClass(utiStr, kUTTagClassMIMEType) else { return nil }
        return String(res.takeUnretainedValue() as NSString)
    }
}


#endif

#endif
