//
//  AddViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit

class AddViewController: UIViewController {
	
	static let identifier = "AddViewController"
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var libraryButton: UIButton!
	@IBOutlet weak var cameraButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        
    }
    

	@IBAction func backButtonClicked(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func libaryButtonClicked(_ sender: UIButton) {
		print(#function)
	}
	@IBAction func caremaButtonClicked(_ sender: UIButton) {
		print(#function)
	}
	
	
}


