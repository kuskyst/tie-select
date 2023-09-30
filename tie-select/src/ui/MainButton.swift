//
//  MainButton.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class MainButton: UIButton {

    // 初期描画処理
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorConstants.mainColor
        self.setTitleColor(.white, for: .normal)
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
