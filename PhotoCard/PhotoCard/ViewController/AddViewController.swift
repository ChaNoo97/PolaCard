//
//  AddViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
	let designHelper = UIExtension()
	static let identifier = "AddViewController"
	
	let localRealm = try! Realm()
	var tasks: Results<PolaroidCardData>!
	
	let ciFilters = ciFilterNames()
	let picker = UIImagePickerController()
	var value: UIImage? {
		didSet {
			filterCollectionView.isHidden = false
			if picker.sourceType == .camera {
				let nowDate = Date()
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy.MM.dd"
				dateFormatter.locale = Locale(identifier: "ko_KR")
				let stringDate = dateFormatter.string(from: nowDate)
				imageDateLabel.text = stringDate
			} else {
				imageDateLabel.text = "라이브러리 시간 가져옴"
			}
		}
	}
	var imageURL: URL?
	var savedImage: UIImage?
	
	@IBOutlet weak var newAddedImage: UIImageView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var libraryButton: UIButton!
	@IBOutlet weak var cameraButton: UIButton!
	@IBOutlet weak var wordingTextField: UITextField!
	@IBOutlet weak var imageDateLabel: UILabel!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var filterCollectionView: UICollectionView!
	@IBOutlet weak var polaroidcardView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("realm", localRealm.configuration.fileURL!)
		
		designHelper.buttonDesgin(btn: backButton, tintColor: .black, title: "뒤로가기", systemImageName: "chevron.backward")
		designHelper.buttonDesgin(btn: libraryButton, tintColor: .black, title: nil, systemImageName: "person.2.crop.square.stack")
		designHelper.buttonLayerDesign(btn: libraryButton, borderWidthValue: 1, cornerRadiusValue: 5, borderColor: .black, backgroundColor: .systemGray5)
		designHelper.buttonDesgin(btn: cameraButton, tintColor: .black, title: nil, systemImageName: "camera")
		designHelper.buttonLayerDesign(btn: cameraButton, borderWidthValue: 1, cornerRadiusValue: 5, borderColor: .black, backgroundColor: .systemGray5)
		designHelper.addViewSaveButton(btn: saveButton)
		
		polaroidcardView.layer.cornerRadius = 3
		polaroidcardView.layer.shadowOffset = CGSize(width: 10, height: 2)
		polaroidcardView.layer.shadowOpacity = 0.1
		polaroidcardView.layer.shadowRadius = 15
		
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		wordingTextField.delegate = self
		wordingTextField.placeholder = "사진의 경험을 적어보세요"
		wordingTextField.font = designHelper.handWritingFont20
		imageDateLabel.text = ""
		imageDateLabel.font = designHelper.handWritingFont20
		
		filterCollectionView.delegate = self
		filterCollectionView.dataSource = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		filterCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		
		picker.delegate = self
		picker.allowsEditing = false
        
		//삭제할 코드
		newAddedImage.image = UIImage(systemName: "star")
		
		let layout = UICollectionViewFlowLayout()
		
		let spacing: CGFloat = 10
		let cellHeight = filterCollectionView.bounds.height
		layout.itemSize = CGSize(width: cellHeight, height: cellHeight)
		let sideEdgeInset:CGFloat = cellHeight*CGFloat((ciFilters.filter.count+1))-cellHeight/2
		layout.sectionInset = UIEdgeInsets(top: 1, left: sideEdgeInset, bottom: 1, right: sideEdgeInset)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		filterCollectionView.collectionViewLayout = layout
		
		filterCollectionView.layer.cornerRadius = 5
		filterCollectionView.backgroundColor = .systemGray5
		
		filterCollectionView.isHidden = true
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		wordingTextField.resignFirstResponder()
		return true
	}
	
	@objc func keyboardWillShow(_ sender: Notification) {
		self.view.frame.origin.y = -250 // Move view 150 points upward
	}

	@objc func keyboardWillHide(_ sender: Notification) {
		self.view.frame.origin.y = 0 // Move view to original position
	}
	
	@IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
		view.endEditing(true)
	}

	@IBAction func backButtonClicked(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func libraryButtonclicked(_ sender: UIButton) {
		picker.sourceType = .photoLibrary
		present(picker, animated: true, completion: nil)
	}
	
	@IBAction func caremaButtonClicked(_ sender: UIButton) {
		picker.sourceType = .camera
		present(picker, animated: true, completion: nil)
	}
	
	@IBAction func saveButtonClicked(_ sender: UIButton) {
		print(#function)
		guard let image = newAddedImage.image else { return print("이미지 없음 얼럿")}
		
		let task = PolaroidCardData(wordingText: wordingTextField.text, imageDate: imageDateLabel.text!)
		
		try! localRealm.write {
			localRealm.add(task)
		}
		
		saveImageToDocumentDirectory(imageName: "\(task._id).png", image: image)
		
	}
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let originalImage = info[.originalImage] as? UIImage else { return }
		if picker.sourceType == .photoLibrary {
			guard let selectPhotoImageURL = info[.imageURL] as? URL else { return }
			imageURL = selectPhotoImageURL
			print(imageURL!)
		}
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


