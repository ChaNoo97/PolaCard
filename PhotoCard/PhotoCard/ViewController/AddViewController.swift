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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("realm", localRealm.configuration.fileURL!)
		
		designHelper.buttonDesginHaveImage(btn: backButton, tintColor: .black, title: "뒤로가기", systemImageName: "chevron.backward")
		designHelper.buttonDesginHaveImage(btn: libraryButton, tintColor: .black, title: nil, systemImageName: "person.2.crop.square.stack")
		designHelper.buttonLayerDesign(btn: libraryButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: .black, backgroundColor: .systemGray5)
		designHelper.buttonDesginHaveImage(btn: cameraButton, tintColor: .black, title: nil, systemImageName: "camera")
		designHelper.buttonLayerDesign(btn: cameraButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: .black, backgroundColor: .systemGray5)
		designHelper.addViewSaveButton(btn: saveButton)
		
		polaroidcardView.layer.cornerRadius = designHelper.cornerRadius
		polaroidcardView.layer.shadowOffset = CGSize(width: 10, height: 2)
		polaroidcardView.layer.shadowOpacity = 0.1
		polaroidcardView.layer.shadowRadius = designHelper.shadowRadius
		
		
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
        imageWidth = newAddedImage.bounds.width
       
		let layout = UICollectionViewFlowLayout()
		
		let spacing: CGFloat = 10
		let cellHeight = filterCollectionView.bounds.height
		layout.itemSize = CGSize(width: cellHeight, height: cellHeight)
		let sideEdgeInset:CGFloat = cellHeight*CGFloat((ciFilters.filter.count+1))-cellHeight/2
		layout.sectionInset = UIEdgeInsets(top: 1, left: sideEdgeInset, bottom: 1, right: sideEdgeInset)
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
		guard let image = value else { return print("이미지 없음 얼럿")}
		
		let task = PolaroidCardData(wordingText: wordingTextField.text, imageDate: imageDateLabel.text!, filterNum: userFilterNum)
		
		try! localRealm.write {
			localRealm.add(task)
		}
		
        saveImageToDocumentDirectory(imageName: "\(task._id).png", image: image)
		
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
			self.newAddedImage.image = downImage
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


