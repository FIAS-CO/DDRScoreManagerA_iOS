//
//  PlaceholderTextView.swift
//  dsma
//
//  Created by apple on 2024/04/27.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import Foundation
import UIKit

//https://qiita.com/REON/items/a5b2122785792f83f851
final class PlaceholderTextView: UITextView {
    
    var placeHolder: String = "" {
        willSet {
            self.placeHolderLabel.text = newValue
            self.placeHolderLabel.sizeToFit()
        }
    }
    
    override var text: String! {
        didSet {
            textDidChanged()  // プログラムによる変更でもプレースホルダーの表示を更新
        }
    }
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = self.font
        label.textColor = .gray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChanged),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6)
        ])
    }
    
    @objc private func textDidChanged() {
        let shouldHidden = self.placeHolder.isEmpty || !self.text.isEmpty
        self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
    }
}
