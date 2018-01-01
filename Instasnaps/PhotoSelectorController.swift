//
//  PhotoSelectorController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 01/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var images = [UIImage]()
    var imageAssets = [PHAsset]()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.allowsSelection = true
        setupNavigationBarItems()
        
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setupNavigationBarItems() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    @objc fileprivate func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleNext(){
        print(123)
    }
    
    fileprivate func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOption())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let size = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image{
                        self.images.append(image)
                        self.imageAssets.append(asset)
                    }
                    
                    if count == allPhotos.count - 1{
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    fileprivate func getAssetFetchOption() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
}

extension PhotoSelectorController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = (view.frame.width - 3)/4
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoHeaderCell
        headerCell.photoImageView.image = selectedImage
        
        if let image = selectedImage{
            if let index = images.index(of: image) {
                let selectedImageAsset = imageAssets[index]
                let imageManager = PHImageManager.default()
                let size = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedImageAsset, targetSize: size, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    headerCell.photoImageView.image = image
                })
            }
        }
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sideLength = view.frame.width
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
    }
}
