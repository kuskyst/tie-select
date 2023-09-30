//
//  String.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

extension String {
    // 左から文字埋めする
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
