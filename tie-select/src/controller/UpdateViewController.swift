//
//  UpdateViewController.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/13.
//

import UIKit

class UpdateViewController: UIViewController {
    // 更新対象
    internal var tieModel: TieModel!

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

        self.inputName.text = self.tieModel.name
        self.inputMainColor.selectedColor = UIColor(hex: self.tieModel.mainColor)
        self.tieImg.tintColor = UIColor(hex: self.tieModel.mainColor)
        self.inputMainColorImage.backgroundColor = UIColor(hex: self.tieModel.mainColor)

        self.inputMainColor.addTarget(self, action: #selector(colorWellChanged(_:)), for: .valueChanged)
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

    // 保存ボタン押下時、更新
    @IBAction private func update() {
        let tie = TieModel()
        tie.id = tieModel.id
        tie.name = inputName.text!
        tie.mainColor = inputMainColor.selectedColor!.toHexString()
        let _ = TieService.shared.updateById(tie: tie)
        dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCamera") {
            let nextVC = segue.destination as! CameraViewController
            nextVC.updateViewController = self
        }
    }
}
