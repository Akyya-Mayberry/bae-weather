//
//  SettingsViewController.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/2/20.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    
    var modelImages = [UIImage]()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modelImages.append(UIImage(named: "sample-freezing")!)
        modelImages.append(UIImage(named: "sample-cold")!)
        modelImages.append(UIImage(named: "sample-warm")!)
        modelImages.append(UIImage(named: "sample-hot")!)
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}

