//
//  TieTableViewCell.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

class TieTableViewCell: UITableViewCell {

    // ID
    internal var id: Int!
    // 名称
    @IBOutlet weak var name: UILabel!
    // イメージ
    @IBOutlet weak var img: UIImageView!

}
