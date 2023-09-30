//
//  ListViewController.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // 登録無
    @IBOutlet private weak var noText: UILabel!
    // テーブルビュー
    @IBOutlet private weak var tableView: UITableView!

    // 更新対象
    private var updateTarget: TieModel!

    // 登録されているネクタイリスト
    private var result: Results<TieModel>! {
        didSet {
            if (result.isEmpty) {
                self.noText.isHidden = false
            } else {
                self.noText.isHidden = true
                self.tableView!.reloadData()
            }
        }
    }
    // ステータスバーの色をホワイト指定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.result = TieService.shared.selectAll()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let res = self.result {
            return res.count
        } else {
            self.noText.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tieCell", for: indexPath) as? TieTableViewCell else {
            fatalError("Dequeue failed: TieTableViewCell.")
        }

        cell.id = result[indexPath.row].id
        cell.name.text = result[indexPath.row].name
        cell.img.tintColor = UIColor(hex: result[indexPath.row].mainColor)

        return cell
    }

    // セルをスワイプした時に表示するアクションの定義
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 編集処理
        let editAction = UIContextualAction(style: .normal, title: "編集") {
                (action, view, completionHandler) in
            self.updateTarget = TieService.shared.selectById(id: self.result[indexPath.row].id)
            self.performSegue(withIdentifier: "toUpdate", sender: nil)

            completionHandler(true)
        }

        // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {
                (action, view, completionHandler) in
            TieService.shared.deleteById(id: self.result[indexPath.row].id)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.result = TieService.shared.selectAll()
            completionHandler(true)
        }
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toUpdate") {
            let nextVC = segue.destination as! UpdateViewController
            nextVC.tieModel = self.updateTarget
        }
    }

}
