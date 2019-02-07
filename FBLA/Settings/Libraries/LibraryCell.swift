//
//  LibraryCell.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/4/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class LibraryCell: UICollectionViewCell {

    @IBOutlet weak var libraryName: UILabel!
    @IBOutlet weak var libraryCreator: UILabel!
    @IBOutlet weak var librarySource: UILabel!
    @IBOutlet weak var libraryView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Do some UI setup for the cell.
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    func setData(library: Library) {
        libraryName.text = library.name
        libraryCreator.text = library.creator
        librarySource.text = library.openSource
        libraryView.text = library.viewUsed
    }

}
