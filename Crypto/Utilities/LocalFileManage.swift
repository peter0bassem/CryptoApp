//
//  LocalFileManage.swift
//  Crypto
//
//  Created by iCommunity app on 13/08/2024.
//

import Foundation
import SwiftUI

class LocalFileManage {
    static let instance = LocalFileManage()
    
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // Create folder
        createFolderIfNeeded(with: folderName)
        
        // Get path for image
        guard let imageData = image.pngData(),
        let url = getURLForImage(for: imageName, in: folderName) else { return }
        
        // Save image to path
        do {
            try imageData.write(to: url)
        } catch {
            print("Failed to save image \(imageName): \(error)")
        }
    }
    
    func getImage(for imageName: String, in folderName: String) -> UIImage? {
        guard let url = getURLForImage(for: imageName, in: folderName),
        FileManager.default.fileExists(atPath: url.path()) else { return nil }
        
        return UIImage(contentsOfFile: url.path())
    }
    
    private func createFolderIfNeeded(with folderName: String) {
        guard let url = getURLForFolder(withFolderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch  {
                print("Failed to create folder \(folderName): \(error)")
            }
        }
    }
    
    private func getURLForFolder(withFolderName name: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appending(path: name)
    }
    
    private func getURLForImage(for imageName: String, in folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(withFolderName: folderName) else { return nil }
        return folderURL.appending(path: imageName + ".png")
    }
}
