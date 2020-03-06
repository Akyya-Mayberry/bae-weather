//
//  ModelImageSetView.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/3/20.
//

import UIKit

protocol ModelImageViewDelegate {
    func didTapModelImageView(_ modelImageView: ModelImageView)
}
class ModelImageView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var modelImageView: UIImageView!
    @IBOutlet weak var weatherCategoryView: WeatherCategoryView!
    
    private(set) var isSelected = false
    var delegate: ModelImageViewDelegate?
    var typeOfWeather: WeatherCategory?
    
    var image: UIImage? {
        get { return modelImageView.image }
        set { modelImageView.image = newValue }
    }
    
    // MARK: - Properties
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    func initNib() {
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
    }
    
    func initSubviews() {
        initNib()
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func didTapModelImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTapModelImageView(self)
    }
    
    func select() {
        modelImageView.layer.borderColor = UIColor.systemPink.cgColor
        modelImageView.layer.borderWidth = 3
        isSelected = true
    }
    
    func deselect() {
        modelImageView.layer.borderColor = nil
        modelImageView.layer.borderWidth = 0
        isSelected = false
    }
    
    func hideWeatherCategory(_ hide: Bool) {
        weatherCategoryView.isHidden = hide
    }
}
