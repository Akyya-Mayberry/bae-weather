//
//  ModelView.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/2/20.
//

import UIKit

@IBDesignable
class ModelView: UIView {
    @IBOutlet weak var typeOfWeatherLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var contentView: UIView!
    
    var weather: String {
        get {return typeOfWeatherLabel.text!}
        set {typeOfWeatherLabel.text = newValue}
    }

    
      /*
       // Only override draw() if you perform custom drawing.
       // An empty implementation adversely affects performance during animation.
       override func draw(_ rect: CGRect) {
       // Drawing code
       }
       */
      
      override init(frame: CGRect) {
        //    let view = UIView(frame: .zero)
        //    view.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        //    view.frame = bounds
        //    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //    addSubview(view)
        
        
        
        
        
        
        // next: append the container to our view
        //    self.addSubview(self.cardView)
        //    self.cardView.translatesAutoresizingMaskIntoConstraints = false
        //    NSLayoutConstraint.activate([
        //      self.cardView.topAnchor.constraint(equalTo: self.topAnchor),
        //      self.cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        //      self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        //      self.cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        //      ])
        
        initSubviews()
      }
      
      //  required init?(coder aDecoder: NSCoder) {
      //    fatalError("init(coder:) has not been implemented")
      //  }
      
      func initSubviews() {
        // first: load the view hierarchy to get proper outlets
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
                addSubview(contentView)
        contentView.frame = bounds
        addSubview(typeOfWeatherLabel)

      }
      
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
      
      //  override func layoutSubviews() {
      //    super.layoutSubviews()
      //    self.frame = actionView.frame
      //  }
      
    }


