//
//  ModelImageCollectionCellCollectionViewCell.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/3/20.
//

import UIKit

class ModelImageCell: UICollectionViewCell {
    var modelView: ModelImageView!
}

extension ModelImageCell: ModelImageViewDelegate {
    func didTapModelImageView(_ modelImageView: ModelImageView) {
        print("Should show model details/edit view")
    }
}
