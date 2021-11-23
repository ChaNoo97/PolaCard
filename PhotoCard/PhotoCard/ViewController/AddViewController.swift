//
//  AddViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit

class AddViewController: UIViewController {
	
	static let identifier = "AddViewController"
	
	let ciFilters = ciFilterNames()
	let picker = UIImagePickerController()
	var value: UIImage?
	var cifilterNames: Array<String> = [
		"CIPhotoEffectChrome",
		"CIColorClamp"
	]
	@IBOutlet weak var newAddedImage: UIImageView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var libraryButton: UIButton!
	@IBOutlet weak var cameraButton: UIButton!

	@IBOutlet weak var filterCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		filterCollectionView.delegate = self
		filterCollectionView.dataSource = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		filterCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		
		picker.delegate = self
		picker.allowsEditing = false
        
		//삭제할 코드
		newAddedImage.image = UIImage(systemName: "star")
		newAddedImage.layer.borderWidth = 1
		
		let layout = UICollectionViewFlowLayout()
		
		let spacing: CGFloat = 10
		let height = filterCollectionView.bounds.height
		layout.itemSize = CGSize(width: height, height: height)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		filterCollectionView.collectionViewLayout = layout
    }
    

	@IBAction func backButtonClicked(_ sender: UIButton) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func libaryButtonClicked(_ sender: UIButton) -> Void {
		print(#function)
		picker.sourceType = .photoLibrary
		present(picker, animated: true, completion: nil)
	}
	
	@IBAction func caremaButtonClicked(_ sender: UIButton) -> Void {
		print(#function)
		picker.sourceType = .camera
		present(picker, animated: true, completion: nil)
	}
	
	
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		value = originalImage
//		let context = CIContext()
//		let filterImage = self.filter(originalCIImage, filterName: "CIPhotoEffectTransfer")!
//		let cgImage = context.createCGImage(filterImage, from: filterImage.extent)!
//		let image = UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
//		value = image
		
		picker.dismiss(animated: true) {
			self.newAddedImage.image = originalImage
			self.filterCollectionView.reloadData()
		}
	}
	
	func filter(_ input: CIImage, filterName: String) -> CIImage? {
		let filter = CIFilter(name: filterName)
		filter?.setValue(input, forKey: kCIInputImageKey)
		return filter?.outputImage
	}
	
	func makeFilteredImage(filterName: String) -> UIImage? {
		if let rawImage = value {
		let originalCIImage = CIImage(image: rawImage)
		let context = CIContext(options: nil)
		let filterImage = self.filter(originalCIImage!, filterName: filterName)!
		let cgImage = context.createCGImage(filterImage, from: filterImage.extent)!
		let image = UIImage(cgImage: cgImage, scale: value!.scale, orientation: value!.imageOrientation)
		return image
		}
		return UIImage(systemName: "star")
	}

}


