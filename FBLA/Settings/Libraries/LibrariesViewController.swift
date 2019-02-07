//
//  LibrariesViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/4/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

private let itemHeight: CGFloat = 84
private let lineSpacing: CGFloat = 20
private let xInset: CGFloat = 20
private let topInset: CGFloat = 10

class LibrariesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var libraries: [Library] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //populate the view with all libraries/dependencies used in this app
        libraries = [
            Library(name: "Firebase", creator: "Google", openSource: "GitHub", viewUsed: "Account/Database"),
            Library(name: "TransitionButton", creator: "AladinWay", openSource: "GitHub", viewUsed: "Account"),
            Library(name: "NVActivityIndicatorView", creator: "ninjaprox", openSource: "GitHub", viewUsed: "Loading alerts"),
            Library(name: "FoldingCell", creator: "Ramotion", openSource: "GitHub", viewUsed: "Books"),
            Library(name: "fluid-slider", creator: "Ramotion", openSource: "GitHub", viewUsed: "Books"),
            Library(name: "VegaScrollFlowLayout", creator: "ApplikeySolutions", openSource: "GitHub", viewUsed: "Libraries"),
            Library(name: "BulletinBoard", creator: "alexaubry", openSource: "GitHub", viewUsed: "Bottom alert"),
            Library(name: "TextFieldEffects", creator: "raulriera", openSource: "GitHub", viewUsed: "Account"),
            Library(name: "PMAlertController", creator: "pmusolino", openSource: "GitHub", viewUsed: "Alert"),
            Library(name: "paper-onboarding", creator: "Ramotion", openSource: "GitHub", viewUsed: "Onboarding View"),
            Library(name: "Nunito", creator: "Vernon Adams", openSource: "Google Fonts", viewUsed: "Text font"),
            Library(name: "Open Sans", creator: "Steve Matteson", openSource: "Google Fonts", viewUsed: "Text font"),
            Library(name: "Himalayas", creator: "Wallpaper Maiden", openSource: "Wallpaper Maiden", viewUsed: "Image (account)"),
            Library(name: "Background", creator: "Ramotion", openSource: "GitHub", viewUsed: "Books"),
            Library(name: "Icons (not app icon)", creator: "Icons8", openSource: "Icons8", viewUsed: "Icons")
        ]
        
        //Setup the view cell here.
        collectionView.register(UINib(nibName: "LibraryCell", bundle: nil), forCellWithReuseIdentifier: "LibraryCell")
        collectionView.contentInset.bottom = itemHeight
        configureCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureCollectionViewLayout() {
        //Configure the layout to use the VegaScrollLayout.
        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCell", for: indexPath) as! LibraryCell
        let library = libraries[indexPath.row]
        cell.setData(library: library)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraries.count
    }

}
