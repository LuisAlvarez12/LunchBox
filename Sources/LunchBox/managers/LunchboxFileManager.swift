//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 2/10/24.
//

import SwiftUI

public actor LunchboxFileManager {
    public static let shared = LunchboxFileManager()
    public let fileManager = FileManager()
    
    // Public Functions
    
}

public extension LunchboxFileManager {
    
    /**
     Creates multiple directories with the specified names.

     - Parameters:
       - folderNames: An array of strings representing the names of the folders to be created.

     - Returns: An `AsyncResponse` indicating the success or failure of the directory creation operation.
     */
    func createBaseFoldersHook(folderNames: [String]) async -> AsyncResponse {
        for folder in folderNames {
            _ = await createDirectory(subDirectoryName: folder)
        }
        return AsyncSuccess()
    }
    
    /**
     Creates a directory with the specified subdirectory name within the given URL path.

     - Parameters:
       - subDirectoryName: The name of the subdirectory to be created.
       - urlPath: The base URL path where the subdirectory should be created. Defaults to the documents directory.

     - Returns: An `AsyncResponse` indicating the success or failure of the directory creation operation.
     */
    func createDirectory(subDirectoryName: String, urlPath: URL =  URL.documentsDirectory) async -> AsyncResponse {
        var dirPath = urlPath.appendingPathComponent(subDirectoryName)

        if !fileManager.fileExists(atPath: dirPath.path) {
            do {
                try fileManager.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
                return AsyncSuccess()
            } catch {
                return AsyncFailure()
            }
        } else {
            return AsyncSuccess()
        }
    }
}


//public extension FileManager {
//    var formattedDocuments: URL {
//#if targetEnvironment(simulator)
//        return URL.documentsDirectory
//#else
//    return fileManager.getDocumentsDirectory().absoluteString.replacingOccurrences(
//        of: "file:///", with: "file:///private/"
//    )
//#endif
//    }
//}


// Delete Files/Folders
public extension LunchboxFileManager {
    
    /**
     Deletes multiple files specified by an array of URLs.

     - Parameters:
       - files: An array of URLs representing the files to be deleted.

     - Returns: An `AsyncResponse` indicating the success or failure of the file deletion operation.
     */
    func deleteAll(files: [URL], _ onDeletedTask: (URL) async -> ()) async -> AsyncResponse {
        guard files.isNotEmpty else {
            return AsyncFailure()
        }

        await files.asyncForEach {
            _ = await deleteFile(file: $0, onDeletedTask)
        }

//        await CountManager.shared.refreshFileCount()
        await MainActor.run {
            NotificationsManager.shared.showMessage("Deleted \(files.count) Files")
        }
        return AsyncSuccess()
    }
    
    /**
     Deletes a file at the specified URL.

     - Parameters:
       - file: The URL of the file to be deleted.

     - Returns: An `AsyncResponse` indicating the success or failure of the file deletion operation.
     */
    private func deleteFile(file: URL, _ onDeletedTask: (URL) async -> ()) async -> AsyncResponse {
        if fileManager.fileExists(atPath: file.path) {
            do {
                try fileManager.removeItem(atPath: file.path)
                _ = await onDeletedTask(file)
                return AsyncSuccess()
            } catch {
                return AsyncFailure()
            }
        } else {
            return AsyncFailure()
        }
    }
}

// URL Formations
public extension LunchboxFileManager {
    
    func addBasePathForURL(fileURLpath: String?) -> URL? {
        guard let path = fileURLpath else {
            return nil
        }

        //        let stringPath = "\(fileManager.getDocumentsDirectory())\(path)"
        return URL(string: getPrivateFilePath())!.appendingPathComponent(path)
    }
    
    func getPrivateFilePath() -> String {
        #if targetEnvironment(simulator)
        return URL.documentsDirectory.absoluteString
        #else
            return URL.documentsDirectory.absoluteString.replacingOccurrences(
                of: "file:///", with: "file:///private/"
            )
        #endif
    }
    
}

public extension LunchboxFileManager {
    
    func fetchFiles(for url: URL, include skipDirectories: Bool = true) async -> [URL] {
        do {
            var directoryContents =  try fileManager.contentsOfDirectory(
                at: url, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
            )
            
            if skipDirectories {
                directoryContents = directoryContents.filter { !$0.hasDirectoryPath }
            }
            
            guard !directoryContents.isEmpty else {
                return []
            }
            
            return directoryContents.map { url in
                (
                    url,
                    (try? url.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate
                        ?? Date.distantPast
                )
            }
            .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
            .map { $0.0 }
            
        } catch  {
            return []
        }
    }
}


// copy and importing data
public extension LunchboxFileManager {
    
    func copyData(destination: URL, files: [URL]) async -> AsyncResponse {
        // TODO: check if can add files
        
        for currentUrl in files {
            if currentUrl.startAccessingSecurityScopedResource() {
                let fileurl = currentUrl
                
                do {
                    let fileName = fileurl.lastPathComponent
                    let destinationURL: URL = destination
                        .appendingPathComponent(fileName)
                    let destination = createDestinationFileURL(contentsURL: destinationURL, directoryURL: destination)
                    try fileManager.copyItem(at: fileurl, to: destination)
                    
                    currentUrl.stopAccessingSecurityScopedResource()
                } catch {
                    currentUrl.stopAccessingSecurityScopedResource()
                }
            }
        }
        return AsyncSuccess()
    }
        
        
        /**
         This function is used to ensure a directory with the same name doesn't exist, and if it does, it will just change the name of the folder by
         appending a count until the name is fully unique
         */
        func createDestinationDirectoryURL(contentsURL: URL, directoryURL: URL) -> URL {
            let directoryName = contentsURL.deletingPathExtension().lastPathComponent
            var destination = directoryURL.appendingPathComponent(directoryName)
            
            var fileRepeatCount = 0
            
            while fileManager.fileExists(atPath: destination.path) {
                fileRepeatCount += 1
                destination = directoryURL.appendingPathComponent("\(directoryName)-\(fileRepeatCount)")
            }
            return destination
        }
        
        /**
         This function is used to ensure a file with the same name doesn't exist, and if it does, it will just change the name of the file by
         appending a count until the name is fully unique
         */
        func createDestinationFileURL(contentsURL: URL, directoryURL: URL) -> URL {
            let fileExtension = contentsURL.pathExtension
            let fileName = contentsURL.deletingPathExtension().lastPathComponent
            var destination = directoryURL.appendingPathComponent("\(fileName).\(fileExtension)")
            
            var fileRepeatCount = 0
            
            while fileManager.fileExists(atPath: destination.path) {
                fileRepeatCount += 1
                destination = directoryURL.appendingPathComponent("\(fileName)-\(fileRepeatCount).\(fileExtension)")
            }
            return destination
        }
    }

public extension LunchboxFileManager {
    
    /**
     Searches through the documents directory in order to match files and folders to the given query
     */
    func searchFiles(at directoryPath: URL, query: String) async throws -> [URL] {
        let enumerator = fileManager.enumerator(atPath: directoryPath.path)
        let filePaths = enumerator?.allObjects as! [NSString]
        let txtFilePaths = filePaths.filter { $0.lastPathComponent.lowercased().contains(query.lowercased()) }
        //        for txtFilePath in txtFilePaths{
        //            //Here you get each text file path present in folder
        //            //Perform any operation you want by using its path
        //            txtFilePath
        //        }

        return txtFilePaths.map {
            addBasePathForURL(fileURLpath: String($0))!
        }
    }
}



