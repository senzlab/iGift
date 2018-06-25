//
//  FileModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/14/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation

private func documentsDirectoryPath() -> String {
    
    let directoryPathsArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    let documentsDirectory = directoryPathsArray[0]
    
    return documentsDirectory
}

func checkFileInPath(relativeFilePath:String) -> Bool {
    
    let absoluteFilePath = "\(documentsDirectoryPath())/\(relativeFilePath)"
    
    let fileManager = FileManager.default
    var isDir: ObjCBool = false
    
    if fileManager.fileExists(atPath: absoluteFilePath, isDirectory: &isDir) {
        if isDir.boolValue {
            // Directory exists with that name but not a file
            return false
        } else {
            // File exist with the given name
            return true
        }
    } else {
        // No file neither directory exists with the given name
        return false
    }
}

func createFileInPath(relativeFilePath:String, fileName:String, imageData:Data) -> Bool {
    
    let creatingDirPath = "\(documentsDirectoryPath())/\(relativeFilePath)"
    let fileManager = FileManager.default
    
    do {
        try fileManager.createDirectory(atPath: creatingDirPath, withIntermediateDirectories: true, attributes: nil)
    } catch {
        return false
    }
    
    let absFilePath = "\(creatingDirPath)/\(fileName)"
    
    do {
        try imageData.write(to: URL(fileURLWithPath: absFilePath))
    } catch  {
        return false
    }
    
    return true
}

func readFileInPath(relativeFilePath:String, fileName: String) -> String {
    print((#file as NSString).lastPathComponent, "-", #function, "-", #line)
    
    let absoluteFilePath = "\(documentsDirectoryPath())/\(relativeFilePath)/\(fileName)"
    
    return absoluteFilePath
}

func deleteFileInPath(relativeFilePath:String) -> Bool {
    print((#file as NSString).lastPathComponent, "-", #function, "-", #line)
    
    let absoluteFilePath = "\(documentsDirectoryPath())/\(relativeFilePath)"
    let fileManager = FileManager.default
    
    do {
        try fileManager.removeItem(atPath: absoluteFilePath)
    } catch  {
        return false
    }
    
    return true
}
