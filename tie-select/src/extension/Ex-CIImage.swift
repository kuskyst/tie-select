//
//  Ex-CIImage.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/02.
//

import UIKit

extension CIImage {
    func toCGImage() -> CGImage? {
        let context = { CIContext(options: nil) }()
        return context.createCGImage(self, from: self.extent)
    }

    func toUIImage(orientation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = self.toCGImage() else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
    }
}
