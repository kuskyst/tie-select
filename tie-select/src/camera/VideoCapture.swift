//
//  VideoCapture.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/02.
//

import AVFoundation

protocol VideoCaptureDelegate: AnyObject {
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer)
    func didCaptureFrame(from imageBuffer: CVImageBuffer)
}

class VideoCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    weak var delegate: VideoCaptureDelegate?
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "object-detection-queue")

    func startCapturing() {
        // capture deviceのメディアタイプを決めて、何からインプットするかを決める
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else { return }
        // captureSessionにdeviceInputを入力値として入れる
        captureSession.addInput(deviceInput)
        // キャプチャセッションの開始
        captureSession.startRunning()
        // ビデオフレームの更新ごとに呼ばれるデリゲートをセット
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        // captureSessionから出力を取得するためにdataOutputをセット
        captureSession.addOutput(videoOutput)
        // captureSessionをUIに描画するためにPreviewLayerにsessionを追加
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        delegate?.didSet(previewLayer)
    }

    func stopCapturing() {
        captureSession.stopRunning()
    }

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        // フレームからImageBufferに変換
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }
        delegate?.didCaptureFrame(from: imageBuffer)
    }

}
