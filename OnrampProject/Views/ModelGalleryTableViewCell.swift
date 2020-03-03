//
//  ModelGalleryTableViewCell.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/2/20.
//

import UIKit
@IBDesignable

class ModelGalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var modelView: ModelView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        modelView.backgroundColor = .green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
