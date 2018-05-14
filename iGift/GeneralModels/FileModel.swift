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
        
//        Directory exists with that name but not a file
        if isDir.boolValue {
            return false
        }
//            File exist with the given name
        else {
            return true
        }
    }
//        No file neither directory exists with the given name
    else {
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

func readFileInPath(relativeFilePath:String) -> String {
    print((#file as NSString).lastPathComponent, "-", #function, "-", #line)
    
    let absoluteFilePath = "\(documentsDirectoryPath())/\(relativeFilePath)"
    
    var fileContent: String
    
    do {
        fileContent = try String(contentsOfFile: absoluteFilePath, encoding: String.Encoding.utf8)
    } catch {
        return "Error reading file"
    }
    
    return fileContent
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
