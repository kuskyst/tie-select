//
//  HomeMenuViewController.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class HomeMenuViewController: UIViewController {
    // 登録無
    @IBOutlet private weak var noText: UILabel!
    // 選択用レイアウト
    @IBOutlet private weak var selectLayout: UIView!
    // ネクタイ名称
    @IBOutlet weak var tieName: UILabel!
    // ネクタイイメージ
    @IBOutlet weak var tieImg: UIImageView!

    // ステータスバーの色をホワイト指定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let his = HistoryService.shared.selectByDate(date: Date()) {
            self.tieName.text = his.tieName
            self.tieImg.tintColor = UIColor(hex: his.tieMainColor)
            self.noText.isHidden = true
            self.selectLayout.isHidden = false
        } else {
            if let tie = TieService.shared.selectRandom() {
                self.tieName.text = tie.name
                self.tieImg.tintColor = UIColor(hex: tie.mainColor)

                let _ = HistoryService.shared.register(tie: tie, date: Date())
                self.noText.isHidden = true
                self.selectLayout.isHidden = false
            } else {
                self.noText.isHidden = false
                self.selectLayout.isHidden = true
            }
        }
        // 翌日分の履歴も作成しておく
        NotificationUtil.shared.setTimerRequest()
    }

    @IBAction func retry() {
        if let tie = TieService.shared.selectRandom() {
            self.tieName.text = tie.name
            self.tieImg.tintColor = UIColor(hex: tie.mainColor)

            let _ = HistoryService.shared.register(tie: tie, date: Date())
            self.noText.isHidden = true
            self.selectLayout.isHidden = false
        } else {
            self.noText.isHidden = false
            self.selectLayout.isHidden = true
        }
    }

}

