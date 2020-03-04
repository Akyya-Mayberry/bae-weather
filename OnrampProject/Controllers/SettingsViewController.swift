//
//  SettingsViewController.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/2/20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let modelImages = [
        UIImage(named: "sample-freezing")!,
        UIImage(named: "sample-cold")!,
        UIImage(named: "sample-warm")!,
        UIImage(named: "sample-hot")!
    ]
    
    private var collections: [[UIImage]] = []
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collections.append(modelImages)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func createImageSet() -> ModelImageView {
        let imageSetView = ModelImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: collectionView.frame.height))
        imageSetView.clipsToBounds = true
        imageSetView.contentMode = .scaleAspectFill
        
        return imageSetView
    }
}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ModelImageCell.self), for: indexPath) as! ModelImageCell
        
        let imageSet = collections[0]
        let modelView = createImageSet()
        
        modelView.image = imageSet[indexPath.row]
        
        cell.addSubview(modelView)
        cell.modelView = modelView
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}

