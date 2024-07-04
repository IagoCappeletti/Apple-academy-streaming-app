//
//  SerieListViewController.swift
//  Movies
//
//  Created by ios-noite-6 on 04/07/24.
//

import UIKit

class SerieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    @IBOutlet weak var serieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    private func setupCollectionView() {
        serieCollectionView.delegate = self
        serieCollectionView.dataSource = self
        serieCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "serieCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "serieCollectionViewCell", for: indexPath)
        let colors = [UIColor.red, UIColor.green, UIColor.blue ]
        collectionViewCell.backgroundColor = colors.randomElement()
        return collectionViewCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSerieDetailVC", sender: nil)
    }
    
}
