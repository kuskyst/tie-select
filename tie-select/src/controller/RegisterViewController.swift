//
//  RegisterViewController.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class RegisterViewController: UIViewController {
    // 名称入力
    @IBOutlet private weak var inputName: CommonTextField!
    // メインカラー入力
    @IBOutlet weak var inputMainColor: UIColorWell!
    // 色プレイメージ
    @IBOutlet weak var inputMainColorImage: UIView!
    // イメージ
    @IBOutlet weak var tieImg: UIImageView!
    
    // ステータスバーの色をホワイト指定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputMainColor.addTarget(self, action: #selector(colorWellChanged(_:)), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
    }

    // 色が指定された時イメージを染色
    @objc private func colorWellChanged(_ sender: Any) {
        self.tieImg.tintColor = self.inputMainColor.selectedColor
        self.inputMainColorImage.backgroundColor = self.inputMainColor.selectedColor
    }

    // 背景タップ時、キーボードを閉じる
    @IBAction private func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // Xボタン押下時、閉じる
    @IBAction private func close() {
        dismiss(animated: true)
    }

    // 登録ボタン押下時、登録
    @IBAction private func register() {
        let tie = TieModel()
        tie.name = inputName.text ?? ""
        tie.mainColor = inputMainColor.selectedColor!.toHexString()
        let _ = TieService.shared.register(tie: tie)
        dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCamera") {
            let nextVC = segue.destination as! CameraViewController
            nextVC.registerViewController = self
        }
    }
}
