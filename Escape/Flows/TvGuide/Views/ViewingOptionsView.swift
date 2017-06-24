//
//  ViewingOptionsView.swift
//  Mizzle
//
//  Created by Rahul Meena on 16/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol ViewingOptionsProtocol: class {
    func didTapOnStreamingOption(streamingOption: StreamingOption)
}

class ViewingOptionsView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var streamingDelegate: ViewingOptionsProtocol?
    var streamingOptions: [StreamingOption] = []
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateStreamingData(streamingOptions: [StreamingOption]) {
        self.streamingOptions.append(contentsOf: streamingOptions)
        self.collectionView.reloadData()
    }

}

extension ViewingOptionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "streamingOptionsCell", for: indexPath) as! StreamingOptionCell
        
        let item = streamingOptions[indexPath.row]
        
        cell.imageView.downloadImageWithUrl(item.image, placeHolder: nil)
        cell.descriptionText.text = item.desc
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streamingOptions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

extension ViewingOptionsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let streamingDelegate = self.streamingDelegate {
            let item = streamingOptions[indexPath.row]
            streamingDelegate.didTapOnStreamingOption(streamingOption: item)
        }
    }
}
