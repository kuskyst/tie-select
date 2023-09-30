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

    @IBOutlet private weak var check1: UIButton!
    @IBOutlet private weak var check2: UIButton!
    @IBOutlet private weak var check3: UIButton!
    @IBOutlet private weak var check4: UIButton!

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

        switch UserDefaults.standard.integer(forKey: "icon") {
            case 1:
                check2.setImage(UIImage(named: "radio-on"), for: .normal)
                break
            case 2:
                check3.setImage(UIImage(named: "radio-on"), for: .normal)
                break
            case 3:
                check4.setImage(UIImage(named: "radio-on"), for: .normal)
                break
            default:
                check1.setImage(UIImage(named: "radio-on"), for: .normal)
                break
            
        }
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

    @IBAction private func icon1() {
        check1.setImage(UIImage(named: "radio-on"), for: .normal)
        check2.setImage(UIImage(named: "radio-off"), for: .normal)
        check3.setImage(UIImage(named: "radio-off"), for: .normal)
        check4.setImage(UIImage(named: "radio-off"), for: .normal)
        UserDefaults.standard.set(0, forKey: "icon")
        UIApplication.shared.setAlternateIconName(nil, completionHandler: { error in print(error ?? "") })
    }

    @IBAction private func icon2() {
        check1.setImage(UIImage(named: "radio-off"), for: .normal)
        check2.setImage(UIImage(named: "radio-on"), for: .normal)
        check3.setImage(UIImage(named: "radio-off"), for: .normal)
        check4.setImage(UIImage(named: "radio-off"), for: .normal)
        UserDefaults.standard.set(1, forKey: "icon")
        UIApplication.shared.setAlternateIconName("AppIcon2", completionHandler: { error in print(error ?? "") })
    }

    @IBAction private func icon3() {
        check1.setImage(UIImage(named: "radio-off"), for: .normal)
        check2.setImage(UIImage(named: "radio-off"), for: .normal)
        check3.setImage(UIImage(named: "radio-on"), for: .normal)
        check4.setImage(UIImage(named: "radio-off"), for: .normal)
        UserDefaults.standard.set(2, forKey: "icon")
        UIApplication.shared.setAlternateIconName("AppIcon3", completionHandler: { error in print(error ?? "") })
    }

    @IBAction private func icon4() {
        check1.setImage(UIImage(named: "radio-off"), for: .normal)
        check2.setImage(UIImage(named: "radio-off"), for: .normal)
        check3.setImage(UIImage(named: "radio-off"), for: .normal)
        check4.setImage(UIImage(named: "radio-on"), for: .normal)
        UserDefaults.standard.set(3, forKey: "icon")
        UIApplication.shared.setAlternateIconName("AppIcon4", completionHandler: { error in print(error ?? "") })
    }
}
