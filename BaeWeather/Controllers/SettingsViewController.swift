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
    @IBOutlet weak var editNameStackView: UIStackView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelNameViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var modelNameViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var editImagesStackView: UIStackView!
    
    // TODO: edit button custom UI button
    @IBOutlet weak var editNameButton: UIButton! {
        didSet {
            let editImage = UIImage(named: "edit-filled")
            let editTintedImage = editImage?.withRenderingMode(.alwaysTemplate)
            
            editNameButton.setImage(editTintedImage, for: .normal)
            editNameButton.imageView?.contentMode = .scaleAspectFit
            editNameButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    @IBOutlet weak var editImagesButton: UIButton! {
        didSet {
            let editImage = UIImage(named: "edit-filled")
            let editTintedImage = editImage?.withRenderingMode(.alwaysTemplate)
            
            editImagesButton.setImage(editTintedImage, for: .normal)
            editImagesButton.imageView?.contentMode = .scaleAspectFit
            editImagesButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.rounded()
        }
    }
    
    private var collections: [[WeathercasterImage?]] = [[]] {
        didSet {
            createThumbnails()
        }
    }
    
    var modelImageViewModel = ModelImageViewModel()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImages()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        nameTextField.delegate = self
        modelImageViewModel.delegate = self
        
        updateUI()
        
        // temporary - sets default images
        modelSetImageViews.first?.select()
        modelImageViewModel.selectedThumbnailIndex = 0
        
        // hides model name editing
        editNameStackView.isHidden = true
    }
    
    @IBAction func didChangeUseDefaultNameSwitch(_ sender: UISwitch) {
        modelImageViewModel.setDefaultName(on: sender.isOn)
        
        if sender.isOn {
            nameTextField.isEnabled = false
            nameTextField.text = ""
        } else {
            nameTextField.isEnabled = true
        }
    }
    
    @IBAction func didChangeUseDefaultPicsSwitch(_ sender: UISwitch) {
        
        print("did change default pic switch")
        modelImageViewModel.setDefaultImages(on: sender.isOn)
        
        if sender.isOn {
            getImages()
        }
    }
    
    @IBAction func didTapEditName(_ sender: UIButton) {
        
        if  sender.tag == 1 {
            let hideEditFields = !self.editNameStackView.isHidden
            editNameButton.isSelected = !hideEditFields
            nameTextField.text = ""
            
            animateEditingSectionTriggered(by: editNameButton)
        }
        
        if sender.tag == 2 {
            editImagesButton.isSelected = editImagesStackView.isHidden
            
            animateEditingSectionTriggered(by: editImagesButton)
        }
    }
    
    @IBAction func didTapOutsideTextfields(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            // TODO: move certain ui changes to funcs for reuse
            
            // enable/disable editing name field
            if self.modelImageViewModel.isUsingDefaultName() {
                self.nameTextField.isEnabled = false
                self.nameTextField.text = ""
                self.defaultNameSwitch.isOn = true
            } else {
                self.nameTextField.isEnabled = true
                self.defaultNameSwitch.isOn = false
            }
            
            if self.modelImageViewModel.isUsingDefaultImages() {
                self.defaultPicsSwitch.isOn = true
            }
            
            // show/hide edit name view
            self.editNameButton.isSelected = !self.editNameStackView.isHidden
            
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
    
    private func createImageSet(using image: UIImage?) -> ModelImageView {
        
        // TODO: the height includes a hardcoded number which is
        // the autolayout constraints of model view superviews.
        // This should not be hardcoded.
        
        let imageSetView = ModelImageView(frame: CGRect(x: 0, y: 0,
                                                        width: collectionView.frame.width,
                                                        height: collectionView.frame.height + 36))
        
        imageSetView.clipsToBounds = true
        imageSetView.contentMode = .scaleAspectFill
        
        if let image = image {
            imageSetView.image = image
        }
        
        return imageSetView
    }
    
    private func createThumbnails() {
        for (index, modelView) in modelSetImageViews.enumerated() {
            let typeOfWeather = WeatherCategory(rawValue: index)
            modelView.delegate = self
            modelView.typeOfWeather = typeOfWeather
            modelView.hideWeatherCategory(true)
            
            let weathercasterImage = collections[0][index]
            modelView.image = UIImage(contentsOfFile: weathercasterImage!.name)
            
            // circular thumbnails
            modelView.layer.cornerRadius = (modelView.frame.size.height / 2)
            modelView.clipsToBounds = true
        }
    }
    
    private func getImages() {
        modelImageViewModel.getImages { (weathercasterImages) in
            DispatchQueue.main.async {
                self.collections[0] = weathercasterImages
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Extensions

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
        let modelImageDetails = collections[0][indexPath.row]
        let modelView = createImageSet(using: UIImage(contentsOfFile: modelImageDetails!.name))
        
        modelView.typeOfWeather = modelImageDetails?.typeOfWeather
        modelView.delegate = self
        modelView.weatherCategoryView.category = modelImageViewModel.getCategory(for: typeOfWeather)
        modelView.weatherCategoryView.image = UIImage(named: modelImageViewModel.getIconName(for: typeOfWeather))!.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        modelView.weatherCategoryView.tintColor = #colorLiteral(red: 1, green: 0.9265189341, blue: 0.6531018429, alpha: 1)
        
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
            
            let weathercasterImage = collections[0][modelImageView.typeOfWeather!.rawValue]
            modelImageDetailsVC.weathercasterImage = weathercasterImage
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        modelImageViewModel.setModel(name: textField.text!)
        modelNameLabel.text = ModelImageViewModel.getModelName()
        textField.resignFirstResponder()
        didTapEditName(editNameButton)
        
        return true
    }
}

extension SettingsViewController: ModelImageDetailsViewControllerDelegate {
    func didUpdateCategory(_ modelImageDetailsViewController: ModelImageDetailsViewController, image: UIImage, for typeOfWeather: WeatherCategory, usingDefaultImage: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: typeOfWeather.rawValue, section: 0)
            self.collections[0][indexPath.row] = modelImageDetailsViewController.weathercasterImage
            
            let cell = self.collectionView.cellForItem(at: indexPath) as! ModelImageCell
            cell.modelView.image = image
            
            self.defaultPicsSwitch.isOn = self.modelImageViewModel.isUsingDefaultImages()
        }
    }
}

extension SettingsViewController: ModelImageViewModelDelegate {
    func modelName(_ modelImageViewModel: ModelImageViewModel, willChange: Bool, name: String) {
        if willChange {
            DispatchQueue.main.async {
                self.modelNameLabel.text = name
            }
        }
    }
}

extension UITextField {
    func rounded() {
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        layer.borderWidth = 1.7
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
        
        // indents/pads text
        let padding = UIView(frame:CGRect(x: 0, y: 0, width: 15, height: 10))
        leftViewMode = UITextField.ViewMode.always
        leftView = padding
    }
}

extension SettingsViewController {
    func animateEditingSectionTriggered(by button: UIButton) {
        
        // edit name
        if button.tag == 1 {
            let hideEditFields = !self.editNameStackView.isHidden
            
            UIView.animate(withDuration: 0.5, animations: {
                self.nameTextField.isHidden = hideEditFields
                self.defaultNameSwitch.isOn = self.modelImageViewModel.isUsingDefaultName()
                self.nameTextField.isEnabled = !self.modelImageViewModel.isUsingDefaultName()
                self.editNameStackView.isHidden = hideEditFields
                
                let modelNameHeight = self.modelNameViewHeightConstraint.constant
                let modelNameBottom = self.modelNameViewBottomContraint.constant
                
                // decreases edit view size if not editing otherwise increases it
                self.modelNameViewHeightConstraint.constant = hideEditFields ? modelNameHeight - 80 : modelNameHeight + 80
                self.modelNameViewBottomContraint.constant = hideEditFields ? modelNameBottom + 10 : modelNameBottom - 10
            }) { (success) in
                UIView.animate(withDuration: 0.5) {
                    if self.nameTextField.isEnabled && !self.nameTextField.isHidden  {
                        self.nameTextField.becomeFirstResponder()
                    } else {
                        self.nameTextField.resignFirstResponder()
                    }
                    
                    // allows animation of view constraint changes
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        // edit images
        if button.tag == 2 {
            //            UIView.animate(withDuration: 0.5) {
            self.editImagesStackView.isHidden = !self.editImagesStackView.isHidden
            self.defaultPicsSwitch.isOn = self.modelImageViewModel.isUsingDefaultImages()
            //            }
        }
    }
}
