//
//  SubButton.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class SubButton: UIButton {

    // 初期描画処理
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.layer.borderColor = ColorConstants.mainColor.cgColor
        self.layer.borderWidth = 1.0
        self.setTitleColor(ColorConstants.mainColor, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }

    // 活性or非活性の制御
    override var isEnabled: Bool {
        didSet {
            if (self.isEnabled) {
                self.alpha = 1.0
            } else {
                self.alpha = 0.5
            }
        }
    }
}
