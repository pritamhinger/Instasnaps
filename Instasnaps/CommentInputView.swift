//
//  CommentInputView.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 03/02/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

class CommentInputView: UITextView {
    
    fileprivate let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment here..!!"
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeHolderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCommentTextChanged), name: .UITextViewTextDidChange, object: nil)
        
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 8, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) is not implemented")
    }
    
    @objc func handleCommentTextChanged() {
        placeHolderLabel.isHidden = !self.text.isEmpty
    }
    
    func showPlaceHolderLabel(){
        placeHolderLabel.isHidden = false
    }
}
