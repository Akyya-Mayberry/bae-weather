//
//  ModelImageCollectionCellCollectionViewCell.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/3/20.
//

import UIKit

protocol ModelImageCellDelegate {
    func didTapModelImageCell(_ modelImageCell: ModelImageCell)
}

class ModelImageCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    var delegate: ModelImageCellDelegate?
    var modelView: ModelView!
}
