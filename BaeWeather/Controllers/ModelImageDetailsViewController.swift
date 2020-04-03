//
//  ModelImageDetailsViewController.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/4/20.
//

import UIKit

protocol ModelImageDetailsViewControllerDelegate {
    func didUpdateCategory(_ modelImageDetailsViewController: ModelImageDetailsViewController, image: UIImage, for typeOfWeather: WeatherCategory)
}

class ModelImageDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            let editImage = UIImage(named: "edit")
            let editTintedImage = editImage?.withRenderingMode(.alwaysTemplate)
            
            editButton.setImage(editTintedImage, for: .normal)
            editButton.imageView?.contentMode = .scaleAspectFit
            editButton.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    var modelImageView: ModelImageView!
    var weathercasterImage: WeathercasterImage!
    var delegate: ModelImageDetailsViewControllerDelegate?
    var modelImageViewModel = ModelImageViewModel()
    var isUserInteractionEnabled: Bool!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    @IBAction func didTapEdit(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        
        // TODO: editing button should be disabled while save is in progress
        
        let imageData = previewImageView.image!.pngData()!
        
        modelImageViewModel.saveModelImage(data: imageData, for: weathercasterImage.typeOfWeather) { (success, imageUrl) in
            if success {
                DispatchQueue.main.async {
                    print("successfully saved custom imaged!!!!")
                    self.saveButton.setImage(UIImage(named: "checkmark"), for: .normal)
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                        self.saveButton.isHidden = true
                    }
                    
                    self.delegate?.didUpdateCategory(self, image: self.previewImageView.image!, for: self.weathercasterImage.typeOfWeather)
                }
            } else {
                DispatchQueue.main.async {
                    print("failed to save custom image")
                    self.saveButton.tintColor = UIColor.red
                    // TODO: update UI to reflect failure to save image
                }
            }
        }
    }
    
    func updateUI() {
        saveButton.isHidden = true
        
        if let image = UIImage(contentsOfFile: weathercasterImage.name) {
            previewImageView.image = image
        } else {
            previewImageView.image = UIImage(named: weathercasterImage.name)
        }
        
        categoryLabel.text = modelImageViewModel.getCategory(for: weathercasterImage.typeOfWeather)
        
        let categoryImage = UIImage(named: modelImageViewModel.getIconName(for: weathercasterImage.typeOfWeather))
        let categoryTintedImage = categoryImage?.withRenderingMode(.alwaysTemplate)
        
        categoryImageView.image = categoryTintedImage
        categoryImageView.tintColor = #colorLiteral(red: 0.693295134, green: 0.7857344852, blue: 0.7857344852, alpha: 1)
        
        // allow/disables editing
        editButton.isEnabled = isUserInteractionEnabled
    }
}

// MARK: - Extensions

extension ModelImageDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("user selected photo: \(info)")
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true, completion: nil)
        previewImageView.image = image
        saveButton.isHidden = false
    }
}
