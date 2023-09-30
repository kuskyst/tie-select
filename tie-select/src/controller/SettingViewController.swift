//
//  SettingViewController.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // 休日周期選択肢
    private let pickList = ["土日祝", "土日のみ"]

    // 休日周期
    @IBOutlet private weak var intervalPicker: UIPickerView!
    // 通知時間帯
    @IBOutlet private weak var timePicker: UIDatePicker!

    // ステータスバーの色をホワイト指定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.intervalPicker.dataSource = self
        self.intervalPicker.selectRow(
            UserDefaults.standard.integer(forKey: "pushInterval"),
            inComponent: 0, animated: false)
        self.intervalPicker.delegate = self

        self.timePicker.date = PushTimeUtil.shared.getDate()
    }

    // 列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickList.count
    }

    // 選択肢
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickList[row]
    }

    // 選択された時、UserDefault更新
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "pushInterval")
        NotificationUtil.shared.setTimerRequest()
    }

    // Xボタン押下時、閉じる
    @IBAction private func close() {
        dismiss(animated: true)
    }

    // 通知時間帯変更時、保存
    @IBAction private func didValueChangedDatePicker(_ sender: UIDatePicker) {
        PushTimeUtil.shared.set(date: sender.date)
        NotificationUtil.shared.setTimerRequest()
    }

}
