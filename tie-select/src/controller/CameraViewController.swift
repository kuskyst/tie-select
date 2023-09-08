//
//  CameraViewController.swift
//  tie-select
//
//  Created by kohsaka on 2023/02/19.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, VideoCaptureDelegate {
    var registerViewController: RegisterViewController? = nil
    var updateViewController: UpdateViewController? = nil
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var buttonArea: UIView!
    @IBOutlet weak var colorButton1: UIView!
    @IBOutlet weak var colorButton2: UIView!
    @IBOutlet weak var colorButton3: UIView!
    @IBOutlet weak var imageView: UIImageView!
    private var selector: [UIView]?
    private var selectRow: Int = 0
    private let videoCapture = VideoCapture()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCapture.delegate = self
        self.buttonArea.layer.borderWidth = 3.0
        self.buttonArea.layer.borderColor = ColorConstants.textBorderColor.cgColor
        self.buttonArea.layer.cornerRadius = 8.0
        self.colorButton1.layer.cornerRadius = 16.0
        self.colorButton2.layer.cornerRadius = 16.0
        self.colorButton3.layer.cornerRadius = 16.0
        self.selector = [self.colorButton1, self.colorButton2, self.colorButton3]
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        // カメラ権限確認
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                DispatchQueue.main.async { self.videoCapture.startCapturing() }
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    if !granted {
                        DispatchQueue.main.async { self.dismiss(animated: true) }
                    }
                })
            default:
                DispatchQueue.main.async { self.dismiss(animated: true) }
                break
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCapture.stopCapturing()
    }

    // previewLayerがセットされた時に呼ばれる
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer) {
        self.preview.layer.addSublayer(previewLayer)
        previewLayer.frame = self.preview.frame
    }

    // フレームがキャプチャされる度に呼ばれる
    func didCaptureFrame(from imageBuffer: CVImageBuffer) {
        let image = CIImage(cvImageBuffer: imageBuffer).toUIImage(orientation: .right)
        DispatchQueue.main.async { self.imageView.image = image }
    }

    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        var point = CGPoint(
            x: self.imageView.image!.size.width /
                self.imageView.frame.width * sender.location(in: self.imageView).x,
            y: self.imageView.image!.size.height /
                self.imageView.frame.height * sender.location(in: self.imageView).y)

        let data: UnsafePointer = CFDataGetBytePtr(self.imageView.image!.cgImage!.dataProvider!.data)
        //タップした位置の座標にあたるアドレスを算出
        let pixelAd: Int = ((Int(self.imageView.image!.size.width) * Int(point.y)) + Int(point.x)) * 4
        self.selector![self.selectRow].backgroundColor = UIColor(
            red: CGFloat(Int(CGFloat(data[pixelAd]) / CGFloat(255.0) * 100)) / 100,
            green: CGFloat(Int(CGFloat(data[pixelAd + 1]) / CGFloat(255.0) * 100)) / 100,
            blue: CGFloat(Int(CGFloat(data[pixelAd + 2]) / CGFloat(255.0) * 100)) / 100,
            alpha: CGFloat(Int(CGFloat(data[pixelAd + 3]) / CGFloat(255.0) * 100)) / 100)
        self.selectRow = self.selectRow >= 2 ? 0 : self.selectRow + 1
    }
    @IBAction private func color1() {
        self.inputColor(color: self.colorButton1.backgroundColor!)
    }
    @IBAction private func color2() {
        self.inputColor(color: self.colorButton2.backgroundColor!)
    }
    @IBAction private func color3() {
        self.inputColor(color: self.colorButton3.backgroundColor!)
    }
    private func inputColor(color: UIColor) {
        if let register = self.registerViewController {
            register.tieImg.tintColor = color
            register.inputMainColorImage.backgroundColor = color
            register.inputMainColor.selectedColor = color
        }
        if let update = self.updateViewController {
            update.tieImg.tintColor = color
            update.inputMainColorImage.backgroundColor = color
            update.inputMainColor.selectedColor = color
        }
        dismiss(animated: true)
    }
}
