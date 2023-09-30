//
//  CalendarViewController.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // カレンダー
    @IBOutlet private weak var calendar: FSCalendar!
    // 選択された日付のイメージ
    @IBOutlet private weak var selectImage: UIView!
    // ネクタイ名称
    @IBOutlet private weak var tieName: UILabel!
    // ネクタイイメージ
    @IBOutlet private weak var tieImg: UIImageView!

    // ステータスバーの色をホワイト指定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendar.delegate = self
        self.calendar.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.calendar.reloadData()
    }

    // 表示時に土日祝判定
    func calendar(_ calendar: FSCalendar, appearance appearrance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        // 祝日or日曜日なら日付を赤色
        if (date.isJpHoliday() || date.isSunday()) {
            return UIColor.red
        // 土曜日なら日付を青色
        } else if (date.isSaturDay()) {
            return UIColor.blue
        }

        return nil
    }
    // 履歴からその日にイメージ付与
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        if (!(date.isSunday() || date.isSaturDay()) && date <= Date()) {
            if let his = HistoryService.shared.selectByDate(date: date) {
                return UIImage(named: "tie")!
                        .tinted(with: UIColor(hex: his.tieMainColor)!)
                        .resize(size: CGSize.init(width: 18, height: 30))!
                        .overlay(image: UIImage(named: "suit")!, width: 22, height: 22)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    // 日付選択時、その日の履歴を取得
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if (!(date.isSunday() || date.isSaturDay()) && date <= Date()) {
            if let his = HistoryService.shared.selectByDate(date: date) {
                self.selectImage.isHidden = false
                self.tieName.text = his.tieName
                self.tieImg.tintColor = UIColor(hex: his.tieMainColor)
            } else {
                self.selectImage.isHidden = true
            }
        } else {
            self.selectImage.isHidden = true
        }
    }

}

