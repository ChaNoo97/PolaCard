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
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var libraryButton: UIButton!
	@IBOutlet weak var cameraButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		picker.delegate = self
        
    }
    

	@IBAction func backButtonClicked(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func libaryButtonClicked(_ sender: UIButton) {
		print(#function)
		picker.sourceType = .photoLibrary
		present(picker, animated: true, completion: nil)
	}
	@IBAction func caremaButtonClicked(_ sender: UIButton) {
		print(#function)
		picker.sourceType = .camera
		present(picker, animated: true, completion: nil)
	}
	
	
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		<#code#>
	}
	
}

