//
//  PhotoDataExtension.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/25.
//

import Foundation
import UIKit

extension UIViewController {
	
	func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
			
		let filePath = documentDirectory.appendingPathComponent("Image")
		if !FileManager.default.fileExists(atPath: filePath.path) {
			do {
				try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
			}
			catch {
				print(error.localizedDescription)
			}
		}
			
		let imageURL = filePath.appendingPathComponent(imageName)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
		
		if FileManager.default.fileExists(atPath: imageURL.path) {
			do {
			try FileManager.default.removeItem(at: imageURL)
			}
			catch {
				print("이미지 삭제하지 못했습니다.")
			}
		}
			
		do {
			try data.write(to: imageURL)
		}
		catch {
			print("이미지 저장 실패")
		}
	}
	
	func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
		let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
		
		if let directoryPath = path.first {
			let imageURL = URL(fileURLWithPath:  directoryPath).appendingPathComponent("Image").appendingPathComponent(imageName)
			return UIImage(contentsOfFile: imageURL.path)
		}
		return nil
	}
	
	func deleteImageToDocumentDirectory(imageName: String) {
		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		let filePath = documentDirectory.appendingPathComponent("Image")
		if !FileManager.default.fileExists(atPath: filePath.path) {
			do {
				try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error.localizedDescription)
			}
		}
		
		let imageURL = filePath.appendingPathComponent(imageName)
		
		if FileManager.default.fileExists(atPath: imageURL.path) {
			do {
				try FileManager.default.removeItem(at: imageURL)
			} catch {
				print("이미지 삭제 못함")
			}
		}
	}
    
    
    func filter(_ input: CIImage, filterName: String) -> CIImage? {
        let filter = CIFilter(name: filterName)
        filter?.setValue(input, forKey: kCIInputImageKey)
        return filter?.outputImage
    }
    
    func makeFilterImage(userSelectImage: UIImage, filterName: String) -> UIImage? {
        let originalCIImage = CIImage(image: userSelectImage)
        let filterImage = self.filter(originalCIImage!, filterName: filterName)!
		let image2 = UIImage(ciImage: filterImage, scale: userSelectImage.scale, orientation: userSelectImage.imageOrientation)
        return image2
    }
    
//    func imageDownSize(imageURL: URL, pointSize: CGSize, scale: CGFloat) -> UIImage {
//        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
//        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
//        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
//                                kCGImageSourceShouldCacheImmediately: true,
//                                kCGImageSourceCreateThumbnailWithTransform: true,
//                                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
//        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
//        return UIImage(cgImage: downsampledImage)
//    }
	
}


