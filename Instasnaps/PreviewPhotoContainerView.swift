//
//  PreviewPhotoContainerView.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 20/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImaegeView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancelSave), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleImageSaveInPhotoLibrary), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(previewImaegeView)
        addSubview(cancelButton)
        addSubview(saveButton)
        
        previewImaegeView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 50, height: 50)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topPadding: 0, leftPadding: 24, bottomPadding: 24, rightPadding: 0, width: 50, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) is not impletmented")
    }
    
    @objc fileprivate func handleCancelSave(){
        self.removeFromSuperview()
    }
    
    @objc fileprivate func handleImageSaveInPhotoLibrary(){
        
        guard let previewImage = self.previewImaegeView.image else { return }
        
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({    
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (completed, error) in
            if let error = error{
                print("Error occured while saving a photo: ", error)
                return
            }
            
            DispatchQueue.main.async {
                self.showSuccessMessageLabel()
            }
        }
    }
    
    fileprivate func showSuccessMessageLabel() {
        let successLabel = UILabel()
        successLabel.text = "Image Saved Successfully"
        successLabel.numberOfLines = 0
        successLabel.font = UIFont.boldSystemFont(ofSize: 18)
        successLabel.textColor = .white
        successLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
        successLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        successLabel.center = self.center
        successLabel.textAlignment = .center
        successLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        self.addSubview(successLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            
            successLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        }) { (completed) in
            UIView.animate(withDuration: 0.5, delay: 0.75, options: .curveEaseOut, animations: {
                successLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                successLabel.alpha = 0
            }, completion: { (_) in
                successLabel.removeFromSuperview()
            })
        }
    }
}
