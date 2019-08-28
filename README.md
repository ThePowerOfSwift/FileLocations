# FileLocations
A framework to manage iOS files better.

## Example
You can visit one file location begin with a Constant then append subscript component.

```swift
Location.userDocument["DirA"]["FileA"].removed()
Location.userDocument["DirB/FileB"].renamed("FileC")
```

## Installation
- Drag the **FileLocations.xcodeproj** file to your project, and embed the FileLocations.framework.

## Location Constants
```swift
Location.root
Location.userDocument
Location.userCache
Location.userLibrary
Location.applicationSupport
Location.bundle
Location.home
Location.temporary
```

## Location init
```swift
Location.init(fileURL:)
Location.init(filePath:)
Location.init(directory:domain:)
Location.init(filePathComponents:)
Location.init(url:)
Location.init?(iCloudContainer:)
```

## Basic Properties
```swift
oneLocation.path
oneLocation.url
oneLocation.iCloud
oneLocation.isExist
oneLocation.isDir
oneLocation.isFile
oneLocation.isReadable
oneLocation.isWritable
oneLocation.isDeletable
oneLocation.isExecutable
oneLocation.isSymbLink
oneLocation.symbLinkDestination
oneLocation.displayName
oneLocation.extension
oneLocation.lastComponent
```


## Location with Read & Write
```swift
let data = Location.userDocument["DataFile"].data()
Location.userDocument["DataFile2"].save(data: data)
Location.userDocument["Dir"].write(data: data, inFile: "DataFile3")

let stirng = Location.userDocument["TextFile"].string(.utf8)
Location.userDocument["TextFile2"].save(string: string)
Location.userDocument["Dir"].write(string: string, inFile: "TextFile3")

let dict = Location.userDocument["DictFile"].dictionary()
Location.userDocument["DictFile2"].save(dictionary: dictionary)
Location.userDocument["Dir"].write(dictionary: dictionary, inFile: "DictFile3")

let obj = Location.userDocument["ObjectFile"].unarchived()
Location.userDocument["ObjectFile2"].archived(object: obj)
Location.userDocument["Dir"].archive(object: obj, inFile: "ObjectFile3")
```

## Locations` Manipulations
```swift
oneLocation.mkdir()
oneLocation.mkpath()
oneLocation.removed()
oneLocation.trashed()
oneLocation.clear()
oneLocation.renamed(:)
oneLocation.copy(toDir:renamed:)
oneLocation.move(toDir:renamed:)
oneLocation.link(toDir:renamed:)
```

## More Attributes and Methods are shown in the project.

## Language
Swift 5.0
  
## Available
iOS 8.0+





