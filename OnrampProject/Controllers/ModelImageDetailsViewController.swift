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
    @IBOutlet weak var editButton: UIButton!
    
    var modelImageView: ModelImageView!
    var delegate: ModelImageDetailsViewControllerDelegate?
    var modelImageViewModel = ModelImageViewModel()
    
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
        self.saveButton.isHidden = true
        
        // after save show checkmark before hidding save button
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.saveButton.isHidden = false
            self.saveButton.setImage(UIImage(named: "checkmark"), for: .normal)
        }
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.saveButton.isHidden = true
        }
        
        delegate?.didUpdateCategory(self, image: previewImageView.image!, for: modelImageView.typeOfWeather!)
    }
    
    func updateUI() {
        let editImage = UIImage(named: "edit")
        let editTintedImage = editImage?.withRenderingMode(.alwaysTemplate)
        
        editButton.setImage(editTintedImage, for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.tintColor = #colorLiteral(red: 1, green: 0.4051257875, blue: 0.3453042228, alpha: 1)
        
        saveButton.isHidden = true
        
        previewImageView.image = modelImageView.image
        categoryLabel.text = modelImageViewModel.getCategory(for: modelImageView.typeOfWeather!)
        
        let categoryImage = UIImage(named: modelImageViewModel.getIconName(for: modelImageView.typeOfWeather!))
        let categoryTintedImage = categoryImage?.withRenderingMode(.alwaysTemplate)
        
        categoryImageView.image = categoryTintedImage
        categoryImageView.tintColor = .darkGray
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
