//
//  UIImage.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/14.
//

import UIKit

extension UIImage {

    func createLocalUrl(forImageNamed name: String) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")

        guard fileManager.fileExists(atPath: url.path) else {
            guard let data = self.pngData() else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }
        return url
    }

    func tinted(with color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }

    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

    func getColor(pos: CGPoint) -> UIColor {
        let imageData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer = CFDataGetBytePtr(imageData)
        let scale = UIScreen.main.scale
        let address: Int = ((Int(self.size.width) * Int(pos.y * scale)) + Int(pos.x * scale)) * 4
        let r = CGFloat(data[address])
        let g = CGFloat(data[address+1])
        let b = CGFloat(data[address+2])
        let a = CGFloat(data[address+3])
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    public func overlay(image: UIImage, width: CGFloat = 100, height: CGFloat = 100) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let rect = CGRect(
            x: (size.width - width) / 2,
            y: (size.height - height) / 2,
            width: width,
            height: height
        )
        image.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

