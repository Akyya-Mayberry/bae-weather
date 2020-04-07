//
//  ModelImageDetailsViewController.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import UIKit

protocol ModelImageDetailsViewControllerDelegate {
    func didUpdateCategory(_ modelImageDetailsViewController: ModelImageDetailsViewController, image: UIImage, for typeOfWeather: WeatherCategory, usingDefaultImage: Bool)
}

class ModelImageDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var editButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var useDefaultImageSwitch: UISwitch!
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            let editImage = UIImage(named: "edit")
            let editTintedImage = editImage?.withRenderingMode(.alwaysTemplate)
            
            editButton.setImage(editTintedImage, for: .normal)
            editButton.imageView?.contentMode = .scaleAspectFit
            editButton.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            let saveButtonImage = UIImage(named: "save")
            let saveButtonTintedImage = saveButtonImage?.withRenderingMode(.alwaysTemplate)
            
            saveButton.setImage(saveButtonTintedImage, for: .normal)
            saveButton.imageView?.contentMode = .scaleAspectFit
            saveButton.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    var modelImageView: ModelImageView!
    var weathercasterImage: WeathercasterImage!
    var delegate: ModelImageDetailsViewControllerDelegate?
    var modelImageViewModel = ModelImageViewModel()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isUsingADefault = modelImageViewModel.isUsingDefaultImages() ||
            modelImageViewModel.isUsingDefaultImage(for: weathercasterImage.typeOfWeather)
        
        editButton.isEnabled = !isUsingADefault
        useDefaultImageSwitch.isOn = isUsingADefault
        
        updateUI()
    }
    
    @IBAction func didTapEdit(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        
        // prevent editing or dismissing modal during save
        editButton.isEnabled = false
        isModalInPresentation = true
        
        let imageData = previewImageView.image!.pngData()!
        
        modelImageViewModel.saveModelImage(data: imageData, for: weathercasterImage.typeOfWeather, asDefault: self.useDefaultImageSwitch.isOn) { (success, imageUrl) in
            if success {
                DispatchQueue.main.async {
                    print("successfully saved custom imaged!!!!")
                    self.saveButton.setImage(UIImage(named: "checkmark"), for: .normal)
                    
                    // redundant
                    if !self.useDefaultImageSwitch.isOn {
                        self.modelImageViewModel.setDefaultImage(on: false, for: self.weathercasterImage.typeOfWeather)
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                        self.animateSaveOption(in: false)
                        self.editButton.isEnabled = !self.useDefaultImageSwitch.isOn
                        self.isModalInPresentation = false
                    }
                    
                    self.delegate?.didUpdateCategory(self, image: self.previewImageView.image!, for: self.weathercasterImage.typeOfWeather, usingDefaultImage: self.useDefaultImageSwitch.isOn)
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: update UI to reflect failure to save image
                    print("failed to save custom image")
                }
            }
        }
    }
    
    @IBAction func didChangeUseDefaultImageSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            self.editButton.isEnabled = false
            
            modelImageViewModel.getImage(for: weathercasterImage.typeOfWeather, asDefault: true) { (weathercasterImage) in
                DispatchQueue.main.async {
                    if weathercasterImage != nil {
                        let image = UIImage(named: weathercasterImage!.name)
                        self.previewImageView.image = image
                        
                        let currentImageData = UIImage(contentsOfFile: self.weathercasterImage!.name)?.pngData()
                        let previewImageData = self.previewImageView.image!.pngData()
                        if currentImageData == previewImageData {
                            if !self.saveButton.isHidden {
                                self.animateSaveOption(in: false)
                            }
                        } else {
                            self.animateSaveOption(in: true)
                        }
                    }
                }
            }
        } else {
            editButton.isEnabled = true
            previewImageView.image = UIImage(contentsOfFile: weathercasterImage.name)
        }
    }
    
    private func updateUI() {
        saveButton.isHidden = true
        
        let image = UIImage(contentsOfFile: weathercasterImage.name)
        previewImageView.image = image
        
        categoryLabel.text = modelImageViewModel.getCategory(for: weathercasterImage.typeOfWeather)
        
        let categoryImage = UIImage(named: modelImageViewModel.getIconName(for: weathercasterImage.typeOfWeather))
        let categoryTintedImage = categoryImage?.withRenderingMode(.alwaysTemplate)
        
        categoryImageView.image = categoryTintedImage
        categoryImageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        
    }
    
    /**
     animates in the option to save a custom weathercaster image
     
     - description: if the save button is not yet displayed (user has not selected a photo), then the edit button is
     slid over so the save button is faded in in its place. Otherwise, the save button is faded out and
     the edit button is slid back in its original place.
     
     - Parameter in: whether or not the save button should be animated into view
     */
    private func animateSaveOption(in animateIn: Bool) {
        // slides edit image button over and fades in save image button
        
        if animateIn {
            if saveButton.isHidden {
                self.saveButton.layer.opacity = 0
                self.saveButton.setImage(UIImage(named: "save"), for: .normal)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.editButtonTrailingConstraint.constant += 60
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.animate(withDuration: 0.2) {
                        self.saveButton.isHidden = false
                        self.saveButton.layer.opacity = 1
                        self.view.layoutIfNeeded()
                    }
                }
            }
        } else {
            self.saveButton.layer.opacity = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.editButtonTrailingConstraint.constant -= 60
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2) {
                    self.saveButton.isHidden = true
                    self.saveButton.layer.opacity = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - Extensions

extension ModelImageDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("user selected photo: \(info)")
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true){
            self.previewImageView.image = image
            self.animateSaveOption(in: true)
        }
    }
}
