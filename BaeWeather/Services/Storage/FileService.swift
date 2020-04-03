//
//  FileService.swift
//  BaeWeather
//
//  Created by Chris Hurley on 3/31/20.
//

import Foundation
import UIKit

class FileService {
    
    // MARK: - Properties
    
    private let webcasterImagesDirectory = Constants.imagesDirectory
    private let fileManager = FileManager.default
    
    static  let sharedInstance = FileService()
    
    // MARK: - Methods
    
    private init() { }
    
    func getWebcasterImagePath(for imageName: String, completion: (URL?) -> Void) {
        //        let relativePath = "\(webcasterImagesDirectory)/\(imageName)"
        
        if let imageURL = getFilePath(for: imageName) {
            completion(imageURL)
        } else {
            completion(nil)
        }
    }
    
    func getWeathercasterImagePaths(for imageNames: [String], completion: ([URL?]) -> Void) {
        var imageUrls: [URL?] = []
        
        for imageName in imageNames {
            getWebcasterImagePath(for: imageName) { (url) in
                imageUrls.append(url)
            }
        }
        
        completion(imageUrls)
    }
    
    func storeWebcasterImage(data: Data, name: String, completion: (Bool, URL?) -> Void) {
        let (dataSuccessfullyStored, imageUrl) = store(data: data, name: name)
        
        if dataSuccessfullyStored {
            completion(true, imageUrl!)
        } else {
            completion(false, nil)
        }
    }
    
    /**
     Returns the path to an item if found in the documents directory of the users home directory
     - Parameter item: what to search for in the documents directory
     such as a file name or absolute path
     - Returns: path to the specified item if located else nil
     */
    private func getFilePath(for item: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error getting user's document directory")
            return nil
        }
        
        let filePath = documentsDirectory.appendingPathComponent(item)
        return filePath
    }
    
    private func store(data: Data, name: String) -> (Bool, URL?) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error getting user's document directory")
            return (false, nil)
        }
        
        let itemUrl = documentsDirectory.appendingPathComponent(name)
        
        do {
            try data.write(to: itemUrl)
            return (true, itemUrl)
        } catch let e {
            print("Error saving item to documents directory: \(e)")
            return (false, nil)
        }
    }
}
