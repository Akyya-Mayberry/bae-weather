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
    
    private var collections: [[BaeImage]] = []
    var modelImageViewModel = ModelImageViewModel()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collections.append(modelImageViewModel.getImages())
        collectionView.dataSource = self
        collectionView.delegate = self
        nameTextField.delegate = self
        
        createThumbnails()
        
        updateUI()
        
        // temporary - sets default images
        modelSetImageViews.first?.select()
        modelImageViewModel.selectedThumbnailIndex = 0
    }
    
    private func createImageSet(using image: UIImage?) -> ModelImageView {
        let imageSetView = ModelImageView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width,
                                                        height: collectionView.frame.height))
        
        imageSetView.clipsToBounds = true
        imageSetView.contentMode = .scaleAspectFill
        
        if let image = image {
            imageSetView.image = image
        }
        
        return imageSetView
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            if self.modelImageViewModel.isUsingDefaultName() {
                self.nameTextField.isEnabled = false
                self.defaultNameSwitch.isOn = true
            } else {
                self.nameTextField.isEnabled = true
                self.defaultNameSwitch.isOn = false
            }
            
            self.nameTextField.placeholder = ""
            self.nameTextField.placeholder = ModelImageViewModel.getModelName()
            self.modelNameLabel.text = ModelImageViewModel.getModelName()
            
            // sets selected thumbnail
            for (index, modelView) in self.modelSetImageViews.enumerated() {
                if index != self.modelImageViewModel.selectedThumbnailIndex {
                    modelView.deselect()
                } else {
                    modelView.select()
                }
            }
        }
    }
    
    @IBAction func didChangeUseDefaultNameSwitch(_ sender: UISwitch) {
        nameTextField.isEnabled = !sender.isOn
        modelImageViewModel.useDefaultName(to: sender.isOn)
        updateUI()
    }
    
    @IBAction func didChangeUseDefaultImagesSwitch(_ sender: Any) {
        print("Did change default images switch")
    }
    
    private func createThumbnails() {
        for (index, modelView) in modelSetImageViews.enumerated() {
            let typeOfWeather = WeatherCategory(rawValue: index)
            modelView.delegate = self
            modelView.typeOfWeather = typeOfWeather
            modelView.hideWeatherCategory(true)
            
            let modelImageDetails = modelImageViewModel.getImagefor(typeOfWeather: typeOfWeather!)
            modelView.image = UIImage(named: modelImageDetails.imageName)
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
        
        let modelView = createImageSet(using: UIImage(named: modelImageDetails.imageName))
        
        modelView.typeOfWeather = modelImageDetails.typeOfWeather
        modelView.delegate = self
        modelView.weatherCategoryView.category = modelImageViewModel.getCategory(for: typeOfWeather)
        modelView.weatherCategoryView.image = UIImage(named: modelImageViewModel.getIconName(for: typeOfWeather))!.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        modelView.weatherCategoryView.tintColor = UIColor.white
        cell.modelView = modelView
        
        cell.addSubview(modelView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height:collectionView.bounds.height)
    }
}

extension SettingsViewController: ModelImageViewDelegate {
    func didTapModelImageView(_ modelImageView: ModelImageView) {
        
        if (modelImageView.superview?.isKind(of: UICollectionViewCell.self))! {
            
            let modelImageDetailsVC = storyboard?.instantiateViewController(identifier: String(describing: ModelImageDetailsViewController.self)) as! ModelImageDetailsViewController
            modelImageDetailsVC.modelImageView = modelImageView
            modelImageDetailsVC.delegate = self
            
            show(modelImageDetailsVC, sender: self)
        } else {
            DispatchQueue.main.async {
                self.updateUI()
                modelImageView.select()
                self.modelImageViewModel.selectedThumbnailIndex = modelImageView.typeOfWeather!.rawValue
                
                let indexPath = IndexPath(row: modelImageView.typeOfWeather!.rawValue, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
            }
        }
        
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    /**
     Updates the selected thumbnail to the current previewed model image
     
     Description: User is able to swipe left and right to cylce through model preview images.
     This ensures that when user swipes to view a different model image, the selected thumbnail updates to match it
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            let offsetFromOriginOfScrollView = self.collectionView.contentOffset
            let frameSize = self.collectionView.bounds.size
            let currentCellFrame = CGRect(origin: offsetFromOriginOfScrollView, size: frameSize)
            
            let centerOfFrame = CGPoint(x: currentCellFrame.midX, y: currentCellFrame.midY)
            let indexPath = self.collectionView.indexPathForItem(at: centerOfFrame)
            
            self.modelSetImageViews[indexPath!.row].select()
            self.modelImageViewModel.selectedThumbnailIndex = indexPath!.row
            
            self.updateUI()
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !defaultNameSwitch.isOn
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            if let text = textField.text, let rangeOfChangedText = Range(range, in: text) {
                
                let updatedText = text.replacingCharacters(in: rangeOfChangedText, with: string)
                
                self.modelNameLabel.text = !updatedText.isEmpty ? updatedText : Constants.defaults.settings.placeholderText
                self.nameTextField.placeholder = !updatedText.isEmpty ? updatedText : Constants.defaults.settings.placeholderText
                
            } else {
                self.nameTextField.text = Constants.defaults.settings.placeholderText
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        modelImageViewModel.setModel(name: textField.text!)
        textField.resignFirstResponder()
        
        return true
    }
}

extension SettingsViewController: ModelImageDetailsViewControllerDelegate {
    func didUpdateCategory(_ modelImageDetailsViewController: ModelImageDetailsViewController, image: UIImage, for typeOfWeather: WeatherCategory) {
        DispatchQueue.main.async {
            let cell = self.collectionView.cellForItem(at: IndexPath(row: typeOfWeather.rawValue, section: 0)) as! ModelImageCell
            cell.modelView.image = image
        }
    }
}
