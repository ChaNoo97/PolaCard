//
//  SettingViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit

class SettingViewController: UIViewController {
	let designHelper = UIExtension()
	@IBOutlet weak var settingTableView: UITableView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Setting"
		settingTableView.delegate = self
		settingTableView.dataSource = self
		self.view.backgroundColor = designHelper.color1
		settingTableView.backgroundColor = designHelper.color1
		self.navigationController?.navigationBar.barTintColor = designHelper.color1
    }
    

    

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else {return UITableViewCell()}
		cell.backgroundColor = designHelper.color1
		
		return cell
	}
	
	
}



