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
			let nowDate = Date()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy.MM.dd"
			dateFormatter.locale = Locale(identifier: "ko_KR")
			let stringDate = dateFormatter.string(from: nowDate)
			imageDateLabel.text = stringDate
		}
	}
	var imageURL: URL?
    var userFilterNum: Int = 0
    var imageWidth: CGFloat = 0
	
	@IBOutlet weak var newAddedImage: UIImageView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var libraryButton: UIButton!
	@IBOutlet weak var cameraButton: UIButton!
	@IBOutlet weak var wordingTextField: UITextField!
	@IBOutlet weak var imageDateLabel: UILabel!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var filterCollectionView: UICollectionView!
	@IBOutlet weak var polaroidcardView: UIView!
	@IBOutlet weak var topView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = designHelper.color1
		topView.backgroundColor = designHelper.color1
		polaroidcardView.backgroundColor = designHelper.color1Light
		wordingTextField.backgroundColor = designHelper.color1Light
		imageDateLabel.backgroundColor = designHelper.color1Light
		newAddedImage.backgroundColor = designHelper.color1Light
		filterCollectionView.backgroundColor = designHelper.color3
		
		print("realm", localRealm.configuration.fileURL!)
		
		designHelper.buttonDesgin(btn: backButton, tintColor: designHelper.color3, title: "뒤로가기")
		backButton.titleLabel?.font = designHelper.handWritingFont15
		designHelper.buttonLayerDesign(btn: backButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: designHelper.color3, backgroundColor: nil)
		
		designHelper.buttonDesgin(btn: libraryButton, tintColor: designHelper.color3, title: nil)
		designHelper.buttonLayerDesign(btn: libraryButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: designHelper.color3, backgroundColor: nil)
		libraryButton.setImage(UIImage(named: "LibrarySymbol"), for: .normal)
		
		designHelper.buttonDesgin(btn: cameraButton, tintColor: designHelper.color3, title: nil)
		cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
		designHelper.buttonLayerDesign(btn: cameraButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: designHelper.color3, backgroundColor: nil)
		
		designHelper.addViewSaveButton(btn: saveButton)
		designHelper.buttonLayerDesign(btn: saveButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: designHelper.color3, backgroundColor: nil)
		
		polaroidcardView.layer.cornerRadius = designHelper.cornerRadius
		polaroidcardView.layer.shadowOffset = CGSize(width: 10, height: 2)
		polaroidcardView.layer.shadowOpacity = 0.1
		polaroidcardView.layer.shadowRadius = designHelper.shadowRadius
		
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
        imageWidth = newAddedImage.bounds.width
       
		let layout = UICollectionViewFlowLayout()
		
		let spacing: CGFloat = 10
		let cellWidth: CGFloat = 50
		layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
		let sideEdgeInset:CGFloat = cellWidth*CGFloat((ciFilters.filter.count+1))-cellWidth/2
		layout.sectionInset = UIEdgeInsets(top: 5, left: sideEdgeInset, bottom: 5, right: sideEdgeInset)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		filterCollectionView.collectionViewLayout = layout
		
		filterCollectionView.layer.cornerRadius = designHelper.cornerRadius
		filterCollectionView.backgroundColor = .systemGray5
		
		filterCollectionView.isHidden = true
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		wordingTextField.resignFirstResponder()
		return true
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
		guard let image = value else {
			return
		}
		
		let task = PolaroidCardData(wordingText: wordingTextField.text, imageDate: imageDateLabel.text!, filterNum: userFilterNum)
		
		try! localRealm.write {
			localRealm.add(task)
		}
		
        saveImageToDocumentDirectory(imageName: "\(task._id).png", image: image)
		
		dismiss(animated: true, completion: nil)
	}
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let originalImage = info[.originalImage] as? UIImage else { return }
        //오리지날 이미지 -> 다운 이미지
        print("오리지널 스케일",originalImage.size.width)
        let downImage = resizeImage(image: originalImage, newWidth: originalImage.size.width, newHeight: originalImage.size.height)
        //벨류 = 다운이미지
		value = downImage
		picker.dismiss(animated: true) {
			DispatchQueue.main.async {
				self.newAddedImage.image = downImage
			}
			self.filterCollectionView.reloadData()
		}
	}
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let newWidth = newWidth/2
        let newHeight = newHeight/2
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}


