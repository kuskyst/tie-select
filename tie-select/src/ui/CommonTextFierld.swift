//
//  CommonTextFierld.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class CommonTextField: UITextField, UITextFieldDelegate {

    // 最大入力桁数
    private var maxLengths = [UITextField: Int]()
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else { return Int.max }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(self.limitLength), for: .editingChanged)
        }
    }
    @objc func limitLength(textfield: UITextField) {
        guard let prospectivetext = textfield.text, prospectivetext.count > maxLength else { return }
        let selection = selectedTextRange
        let maxCharIndex = prospectivetext.index(prospectivetext.startIndex, offsetBy: maxLength)
        text = String(prospectivetext[..<maxCharIndex])
        selectedTextRange = selection
    }

    // エラー
    internal var isError: Bool = false {
        didSet {
            if (self.isError) {
                self.layer.borderColor = UIColor.red.cgColor
                self.textColor = UIColor.red
                self.backgroundColor = .white
            } else {
                self.layer.borderColor = ColorConstants.textBorderColor.cgColor
                self.textColor = ColorConstants.textColor
            }
        }
    }

    // 初期描画処理
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.layer.borderWidth = 1.0
        self.layer.borderColor = ColorConstants.textBorderColor.cgColor
        self.backgroundColor = ColorConstants.textBackgroundColor
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 8.0
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.rightViewMode = .always
        self.leftView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.becomeFirstResponder)))
        self.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.becomeFirstResponder)))
    }

    // 左padding
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 20
        return rect
    }

    // テキスト変更時の制御
    override var text: String? {
        didSet {
            if (self.text!.isEmpty) {
                self.backgroundColor = ColorConstants.textBackgroundColor
            } else {
                self .backgroundColor = .white
            }
        }
    }

    // 次の入力欄
    internal var nextField: CommonTextField?
    
    // 入力開始
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = ColorConstants.mainColor.cgColor
        self.backgroundColor = .white
    }

    // 入力終了
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderWidth = 1.0
        if (self.isError) {
            self.layer.borderColor = UIColor.red.cgColor
            self.backgroundColor = .white
        } else {
            self.layer.borderColor = ColorConstants.textBorderColor.cgColor
            if (self.text!.isEmpty) {
                self.backgroundColor = ColorConstants.textBackgroundColor
            } else {
                self.backgroundColor = .white
            }
        }
    }

    // キーボードでのreturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let next = self.nextField {
            // 次の入力欄にフォーカス
            next.becomeFirstResponder()
        } else {
            // 未設定の場合はキーボードを閉じる
            self.becomeFirstResponder()
        }
        return true
    }
}
