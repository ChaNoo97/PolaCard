//
//  AddViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit

class AddViewController: UIViewController {
	
	static let identifier = "AddViewController"
	
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

	@IBOutlet weak var filterView: UICollectionView!
	@IBOutlet weak var filterCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		filterCollectionView.dataSource = self
		filterCollectionView.delegate = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		filterCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		filterCollectionView.isPagingEnabled = true
		
		picker.delegate = self
		picker.allowsEditing = false
        
		newAddedImage.image = UIImage(systemName: "star")
		newAddedImage.layer.borderWidth = 1
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		let width = filterView.bounds.size.width - (2*spacing)
		let height = filterView.bounds.size.height
		layout.itemSize = CGSize(width: width, height: height)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		filterCollectionView.collectionViewLayout = layout
		
		print(type(of: (filterView.bounds.size.width)))
		print(filterView.bounds.size.height)
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
		guard let imageURL = info[.imageURL] as? URL, let originalCIImage = CIImage(contentsOf: imageURL) else { return }
		let context = CIContext()
		
		let sepiaCIImage = self.sepiaFilter(originalCIImage, intensity: 0.8)!
		
		let cgImage = context.createCGImage(sepiaCIImage, from: sepiaCIImage.extent)!
		
		let image = UIImage(cgImage: cgImage)
		value = image
		picker.dismiss(animated: true) {
			self.newAddedImage.image = image
			self.filterCollectionView.reloadData()
		}
	}
	
	func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage? {
		let sepiaFilter = CIFilter(name: "CISepiaTone")
		sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
		sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
		return sepiaFilter?.outputImage
	}
}

extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.backgroundColor = .orange
		cell.filteredImage.image = value
	
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
		
		newAddedImage.image = cell.filteredImage.image
		
	}
	
}

