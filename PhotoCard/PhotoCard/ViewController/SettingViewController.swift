//
//  SettingViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit
import Zip
import RealmSwift
import MobileCoreServices

class SettingViewController: UIViewController {
	let designHelper = UIExtension()
	@IBOutlet weak var settingTableView: UITableView!
	
	let settingKor: [String] = ["백업하기","복구하기"]
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Setting"
		settingTableView.delegate = self
		settingTableView.dataSource = self
		self.view.backgroundColor = designHelper.color1
		settingTableView.backgroundColor = designHelper.color1
		self.navigationController?.navigationBar.barTintColor = designHelper.color1
    }
	
	func documentDirectoryPath() -> String? {
		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
		let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
		
		if let directoryPath = path.first {
			return directoryPath
		}
		return nil
	}
    
	func presentActivityViewController() {
		let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("PolaCard.zip")
		let fileURL = URL(fileURLWithPath: fileName)
		let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
		self.present(vc, animated: true, completion: nil)
	}

    

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "백업/복구"
		} else {
			return "정보"
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
		} else {
			return 3
		}
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else {return UITableViewCell()}
		cell.backgroundColor = designHelper.color1Light
		
		if indexPath.section == 0 {
			cell.nameLabel.text = settingKor[indexPath.row]
			cell.nameLabel.font = designHelper.handWritingFont20
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				var urlPath = [URL]()
				
				if let path = documentDirectoryPath() {
					let realm = (path as NSString).appendingPathComponent("default.realm")
					if FileManager.default.fileExists(atPath: realm) {
						urlPath.append(URL(string: realm)!)
					} else {
						print("Realm 존재하지 않습니다.")
					}
					let imageFile = (path as NSString).appendingPathComponent("Image")
					if FileManager.default.fileExists(atPath: imageFile) {
						urlPath.append(URL(string:  imageFile)!)
					} else {
						print("백업할 이미지 파일 존재 x")
					}
				}
				
				do {
					let zipFilePath = try Zip.quickZipFiles(urlPath, fileName: "PolaCard")
					print("압축경로",zipFilePath)
					presentActivityViewController()
				}
				catch {
					print("zip 압축 오류")
				}
				
			} else {
				let alert = UIAlertController(title: "복구", message: "복구할 파일이 선택되면 앱이 자동으로 종료됩니다.", preferredStyle: .alert)
				let cancle = UIAlertAction(title: "cancle", style: .cancel) { action in
					let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
					documentPicker.delegate = self
					documentPicker.allowsMultipleSelection = false
					self.present(documentPicker, animated: true, completion: nil)
				}
				alert.addAction(cancle)
				present(alert, animated: true, completion: nil)

			}
		}
	}
}

extension SettingViewController: UIDocumentPickerDelegate {
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		print(#function)
	}
	
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		print(#function)
		
		guard let selectedFileURL = urls.first else { return }
		
		let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent)
		
		if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
			do {
				let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
				let fileURL = documentDirectory.appendingPathComponent("PolaCard.zip")
				try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: nil, fileOutputHandler: nil)
				UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
			}
			catch {
				print(#function,"error")
			}
		} else {
			do {
				try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
				let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
				let fileURL = documentDirectory.appendingPathComponent("PolaCard.zip")
				try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: nil, fileOutputHandler: nil)
				UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
			}
			catch {
				print(#function,"error")
			}
		}
	}
}


