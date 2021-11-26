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
		print("filePath==> ",filePath)
		if !FileManager.default.fileExists(atPath: filePath.path) {
			do {
				try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
			}
			catch {
				print(error.localizedDescription)
			}
		}
			
		let imageURL = filePath.appendingPathComponent(imageName)
		
		guard let data = image.jpegData(compressionQuality: 1) else { return }
		
		if FileManager.default.fileExists(atPath: imageURL.path) {
			do {
			try FileManager.default.removeItem(at: imageURL)
				print("이미지 삭제 완료")
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
	
}
	

