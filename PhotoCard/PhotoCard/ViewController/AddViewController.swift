//
//  AddViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.


import UIKit
import RealmSwift
import Photos

//MARK: AddviewController 
class AddViewController: UIViewController, UITextFieldDelegate {
	let designHelper = UIExtension()
	static let identifier = "AddViewController"
	
	let localRealm = try! Realm()
	var tasks: Results<PolaroidCardData>!
	
	let ciFilters = ciFilterNames()
	let picker = UIImagePickerController()
	var value: UIImage? {
		didSet {
			let nowDate = Date()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy.MM.dd"
			dateFormatter.locale = Locale(identifier: "ko_KR")
			let stringDate = dateFormatter.string(from: nowDate)
			imageDateLabel.text = stringDate
			placeholderLabel.text = ""
			filterCollectionView.isHidden = false
		}
	}
	var imageURL: URL?
    var userFilterNum: Int = 0
    var imageWidth: CGFloat = 0
	
	@IBOutlet weak var newAddedImage: UIImageView!
	@IBOutlet weak var libraryButton: UIButton!
	@IBOutlet weak var cameraButton: UIButton!
	@IBOutlet weak var wordingTextField: UITextField!
	@IBOutlet weak var imageDateLabel: UILabel!
	@IBOutlet weak var filterCollectionView: UICollectionView!
	@IBOutlet weak var polaroidcardView: UIView!
	@IBOutlet weak var placeholderLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarController?.tabBar.isHidden = true
		self.tabBarController?.tabBar.isTranslucent = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(saveBtnTapped))
		
		self.view.backgroundColor = designHelper.viewBackgroundColor
		polaroidcardView.backgroundColor = designHelper.cardBackgroundColor
		wordingTextField.backgroundColor = designHelper.cardBackgroundColor
		imageDateLabel.backgroundColor = designHelper.cardBackgroundColor
		
		placeholderLabel.font = designHelper.handWritingFont20
		placeholderLabel.text = "아래 카메라/앨범 버튼을 이용하여 사진을 추가해주세요"
		placeholderLabel.numberOfLines = 0
		placeholderLabel.textAlignment = .center
		placeholderLabel.textColor = UIColor.placeholderText
		
		print("realm", localRealm.configuration.fileURL!)
		
		designHelper.buttonDesgin(btn: libraryButton, tintColor: designHelper.buttonTintColor, title: nil)
		designHelper.buttonLayerDesign(btn: libraryButton, borderWidthValue: 2, cornerRadiusValue: designHelper.cornerRadius, borderColor: designHelper.buttonTintColor, backgroundColor: nil)
		libraryButton.setImage(UIImage(named: "LibrarySymbol"), for: .normal)
		
		designHelper.buttonDesgin(btn: cameraButton, tintColor: designHelper.buttonTintColor, title: nil)
		cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
		designHelper.buttonLayerDesign(btn: cameraButton, borderWidthValue: 2, cornerRadiusValue: designHelper.cornerRadius, borderColor: designHelper.buttonTintColor, backgroundColor: nil)
		
		polaroidcardView.layer.cornerRadius = designHelper.cornerRadius
		polaroidcardView.layer.shadowOffset = CGSize(width: 10, height: 2)
		polaroidcardView.layer.shadowOpacity = 0.1
		polaroidcardView.layer.shadowRadius = designHelper.shadowRadius
		
		wordingTextField.delegate = self
		wordingTextField.placeholder = "사진의 경험을 적어보세요(25자 이내)"
		wordingTextField.font = designHelper.handWritingFont20
		imageDateLabel.text = ""
		imageDateLabel.font = designHelper.handWritingFont20
		
		filterCollectionView.delegate = self
		filterCollectionView.dataSource = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		filterCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		
		picker.delegate = self
		picker.allowsEditing = false
		
//		PHPhotoLibrary.requestAuthorization { (state) in
//			print(state)
//		}
		AVCaptureDevice.requestAccess(for: .video) { (result) in
			print(result)
		}
		
		
        imageWidth = newAddedImage.bounds.width
       
		let layout = UICollectionViewFlowLayout()
		
		let spacing: CGFloat = 10
		let cellWidth: CGFloat = 70
		layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
		layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		filterCollectionView.collectionViewLayout = layout
		
		filterCollectionView.layer.cornerRadius = designHelper.cornerRadius
		filterCollectionView.backgroundColor = designHelper.viewBackgroundColor
		
		filterCollectionView.isHidden = true
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		wordingTextField.resignFirstResponder()
		return true
	}
	
	func textFieldDidChangeSelection(_ textField: UITextField) {
		designHelper.checkMaxLenght(textField: wordingTextField, maxLenght: 25)
	}

	
	func settingAlert(AuthString: String) {
		if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
			let alert = UIAlertController(title: "설정", message: "\(appName)가 \(AuthString) 접근이 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?", preferredStyle: .alert)
			let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
			let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
				UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
			}
			
			alert.addAction(cancleAction)
			alert.addAction(confirmAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
		view.endEditing(true)
	}
	
	@IBAction func libraryButtonclicked(_ sender: UIButton) {
//		if photoCheckAuthorization() {
			self.picker.sourceType = .photoLibrary
			self.present(self.picker, animated: true, completion: nil)
//		} else {
//			settingAlert(AuthString: "앨범")
//		}
	}
	
	@IBAction func caremaButtonClicked(_ sender: UIButton) {
		if cameraAuthorization() {
			self.picker.sourceType = .camera
			self.present(picker, animated: true, completion: nil)
		} else {
			settingAlert(AuthString: "카메라")
		}
		
	}
	
	@objc func saveBtnTapped(_ sender: UIBarButtonItem) {
		guard let image = value else {
			return dismiss(animated: true, completion: nil)
		}

		let task = PolaroidCardData(wordingText: wordingTextField.text, imageDate: imageDateLabel.text!, filterNum: userFilterNum)

		try! localRealm.write {
			localRealm.add(task)
		}

		saveImageToDocumentDirectory(imageName: "\(task._id).png", image: image)

		navigationController?.popViewController(animated: true)
	}

}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let originalImage = info[.originalImage] as? UIImage else { return }
        //오리지날 이미지 -> 다운 이미지
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
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
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

	func cameraAuthorization() -> Bool {
		return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
	}
	
    
}

//MARK: AddViewFilterCollectionView
extension AddViewController: UICollectionViewDataSource, UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return ciFilters.filter.count+1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.cornerRadius = designHelper.cornerRadius
		cell.layer.borderWidth = 2
		cell.layer.borderColor = designHelper.buttonTintColor.cgColor
		
		filterCollectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: .init())
	
		if indexPath.row == 0 {
			cell.filteredImage.image = value
			cell.filterName.text = "원본"
			cell.filterName.font = designHelper.handWritingFont15
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
		} else {
			cell.filteredImage.image = value
			cell.filteredImage.image = makeFilterImage(userSelectImage: (value ?? UIImage(named: "LunchImage"))!, filterName: ciFilters.filter[indexPath.row-1])
			cell.filterName.text = ciFilters.filterKor[indexPath.row-1]
			cell.filterName.font = designHelper.handWritingFont15
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
			
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
		newAddedImage.image = cell.filteredImage.image
		userFilterNum = indexPath.row
	}
	
}
