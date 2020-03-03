//
//  SettingsViewController.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/2/20.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var modelImages = [UIImage]()

    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modelImages.append(UIImage(named: "sample-freezing")!)
        modelImages.append(UIImage(named: "sample-cold")!)
        modelImages.append(UIImage(named: "sample-warm")!)
        modelImages.append(UIImage(named: "sample-hot")!)
        
        tableView.dataSource = self
        tableView.delegate = self

    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModelGalleryCell", for: indexPath) as! ModelGalleryTableViewCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
        
    }

    
}

