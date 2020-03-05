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
    @IBOutlet var modelSetImageViews: [ModelImageView]!
    @IBOutlet weak var defaultNameSwitch: UISwitch!
    @IBOutlet weak var defaultPicsSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var modelNameLabel: UILabel!
    
    private let modelImages = [
        BaeImage("sample-freezing", for: .freezing),
        BaeImage("sample-cold", for: .freezing),
        BaeImage("sample-warm", for: .freezing),
        BaeImage("sample-hot", for: .freezing)
    ]
    
    private var collections: [[BaeImage]] = []
    var modelImageViewModel = ModelImageViewModel()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collections.append(modelImages)
        collectionView.dataSource = self
        collectionView.delegate = self
        nameTextField.delegate = self
        
        for (index, modelView) in modelSetImageViews.enumerated() {
            let typeOfWeather = WeatherCategory(rawValue: index)
            modelView.delegate = self
            modelView.typeOfWeatherLimited = typeOfWeather
            
            let modelImageDetails = modelImageViewModel.getImagefor(typeOfWeather: typeOfWeather!)
            modelView.image = UIImage(named: modelImageDetails.image)
        }
        
        updateUI()
        modelSetImageViews.first?.select()
        defaultNameSwitch.isOn = true
        nameTextField.text = Constants.defaults.modelName
        nameTextField.placeholder = Constants.defaults.modelName
        
    }
    
    private func createImageSet(using image: UIImage?) -> ModelImageView {
        let imageSetView = ModelImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: collectionView.frame.height))
        imageSetView.clipsToBounds = true
        imageSetView.contentMode = .scaleAspectFill
        
        if let image = image {
            imageSetView.image = image
        }
        
        return imageSetView
    }
    
    func updateUI() {
        nameTextField.isEnabled = !defaultNameSwitch.isOn
        
        // deselects thumbnails
        for (_, modelView) in modelSetImageViews.enumerated() {
            modelView.deselect()
        }
    }
    
    @IBAction func didSwitchDefaultName(_ sender: UISwitch) {
        nameTextField.isEnabled = !sender.isOn
        
        if sender.isOn {
            nameTextField.text = Constants.defaults.modelName
            modelNameLabel.text = Constants.defaults.modelName
        }
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
        
        let typeOfWeather = WeatherCategory(rawValue: indexPath.row)!
        let modelImageDetails = modelImageViewModel.getImagefor(typeOfWeather: typeOfWeather)
        
        let modelView = createImageSet(using: UIImage(named: modelImageDetails.image))
        
        modelView.typeOfWeatherLimited = modelImageDetails.typeOfWeather
        modelView.delegate = self
        
        cell.addSubview(modelView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}

extension SettingsViewController: ModelImageViewDelegate {
    func didTapModelImageView(_ modelImageView: ModelImageView) {
        
        if (modelImageView.superview?.isKind(of: UICollectionViewCell.self))! {
            performSegue(withIdentifier: "ModelImageDetailsSegue", sender: self)
        } else {
            DispatchQueue.main.async {
                self.updateUI()
                modelImageView.select()
                
                let indexPath = IndexPath(row: modelImageView.typeOfWeatherLimited!.rawValue, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
            }
        }
        
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            let offsetFromOriginOfScrollView = self.collectionView.contentOffset
            let frameSize = self.collectionView.bounds.size
            let currentCellFrame = CGRect(origin: offsetFromOriginOfScrollView, size: frameSize)
            
            let centerOfFrame = CGPoint(x: currentCellFrame.midX, y: currentCellFrame.midY)
            let indexPath = self.collectionView.indexPathForItem(at: centerOfFrame)
            
            self.updateUI()
            
            self.modelSetImageViews[indexPath!.row].select()
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !defaultNameSwitch.isOn
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextField.placeholder = modelNameLabel.text!.isEmpty ? Constants.defaults.modelName : modelNameLabel.text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.async {
            if let text = textField.text, let rangeOfChangedText = Range(range, in: text) {
                
                let updatedText = text.replacingCharacters(in: rangeOfChangedText, with: string)
                
                self.modelNameLabel.text = !updatedText.isEmpty ? updatedText : "enter name"
                self.nameTextField.placeholder = !updatedText.isEmpty ? updatedText : "enter name"
                
            } else {
                self.nameTextField.text = "enter name"
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if modelNameLabel.text!.isEmpty {
            modelNameLabel.text = Constants.defaults.modelName
            textField.placeholder = Constants.defaults.modelName
        }
        
        textField.resignFirstResponder()
        return true
    }
}
