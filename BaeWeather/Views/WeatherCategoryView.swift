//
//  WeatheryCategoryView.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/5/20.
//

import UIKit

class WeatherCategoryView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    var category: String {
        get { return categoryLabel.text! }
        set { categoryLabel.text = newValue }
    }
    
    var image: UIImage {
        get { return imageView.image! }
        set { imageView.image = newValue }
    }
    
    // MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    func initSubViews() {
        initNib()
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func initNib() {
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
    }
}
