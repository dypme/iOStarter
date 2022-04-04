//
//  CameraController.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 12/06/19.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreMotion

extension AVCaptureDevice.Position {
    fileprivate var captureDevice: AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self)
    }
}

private class FocusView {
    private var borderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = nil
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 2.5
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var fillView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    func startAnimate(at point: CGPoint, in view: UIView) {
        borderView.center = point
        fillView.center = point
        
        borderView.transform = CGAffineTransform(scaleX: 1, y: 1)
        fillView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        borderView.alpha = 0
        fillView.alpha = 0
        
        borderView.layer.removeAllAnimations()
        fillView.layer.removeAllAnimations()
        
        view.addSubview(borderView)
        view.addSubview(fillView)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.borderView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.fillView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.borderView.alpha = 1
            self.fillView.alpha = 1
        }) { (isFinished) in
            if isFinished {
                UIView.animate(withDuration: 0.5, animations: {
                    self.fillView.alpha = 0
                }) { (finished) in
                    if finished {
                        self.fillView.removeFromSuperview()
                    }
                }
                
                UIView.animate(withDuration: 0.4, delay: 0.55, options: .curveLinear, animations: {
                    self.borderView.alpha = 0
                }) { (finished) in
                    if finished {
                        self.borderView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

@objc protocol CameraControllerDelegate: AnyObject {
    func didCapture(_ picker: CameraController, image: UIImage)
}

class CameraController: UIViewController {
    
    weak var delegate: CameraControllerDelegate?
    
    // MARK: Property
    private(set) var closeBtn: UIButton = {
        let statusFrame = UIApplication.shared.statusBarFrame
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 15, y: statusFrame.height, width: 30, height: 30)
        button.setImage(Asset.icCameraClose.image, for: UIControl.State())
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    private(set) var takeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(Asset.icCameraTakeWhite.image, for: UIControl.State())
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    private(set) var photoPreviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) var flashBtn: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(Asset.icCameraFlashOn.image, for: UIControl.State())
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    private var switchCameraBtn: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(Asset.icCameraFlipWhite.image, for: UIControl.State())
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let zoomSlider: ZoomSlider = {
        let slider = ZoomSlider()
        slider.minimumValue = 1
        slider.maximumValue = 4
        slider.value = 1
        slider.alpha = 0.0
        slider.isHidden = true
        return slider
    }()
    
    private var focusView = FocusView()
    
    // MARK: Settings Property
    private var isAllowSwitchCamera: Bool              = true
    private var isAllowFlashlight: Bool                = true
    private var cameraDevice: AVCaptureDevice.Position = .back
    private var isFullscreenCamera: Bool       = false
    
    private var isTakingPhoto: Bool = false
    
    // MARK: Flash property
    private var currentBrightness: CGFloat = 0.0
    private var isFlashOn: Bool            = false {
        didSet {
            if isFlashOn {
                flashBtn.setImage(Asset.icCameraFlashOn.image, for: UIControl.State())
            } else {
                flashBtn.setImage(Asset.icCameraFlashOff.image, for: UIControl.State())
            }
        }
    }
    
    // MARK: Supporting property
    private(set) var currentOrientation = UIDevice.current.orientation
    private var currentScale: Float = 0
    
    fileprivate var radian: CGFloat {
        if currentOrientation == .landscapeLeft || UIDevice.current.orientation == .landscapeLeft {
            return CGFloat.pi / 2
        } else if currentOrientation == .landscapeRight || UIDevice.current.orientation == .landscapeRight {
            return -(CGFloat.pi / 2)
        } else {
            return 0
        }
    }
    
    private let motionManager = CMMotionManager()
    
    // MARK: Camera property
    private let imageOutput: AVCaptureOutput = {
        return AVCapturePhotoOutput()
    }()
    private(set) var session: AVCaptureSession?
    
    lazy private(set) var previewLayer: AVCaptureVideoPreviewLayer? = {
        if let session = self.session {
            var previewLay          = AVCaptureVideoPreviewLayer(session: session)
            previewLay.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            return previewLay
        }
        return nil
    }()
    
    // MARK: Action
    private var takeAction: ((UIImage) -> Void)?
    
    // MARK: Setup view
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    init(camera: AVCaptureDevice.Position, isFullscreenCamera: Bool, isAllowSwitchCamera: Bool, isAllowFlashlight: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        
        self.cameraDevice = camera
        self.isFullscreenCamera = isFullscreenCamera
        self.isAllowSwitchCamera = isAllowSwitchCamera
        self.isAllowFlashlight = isAllowFlashlight
        
        setPropertyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentBrightness = UIScreen.main.brightness
        
        setupMethod()
        setupView()
        
        sessionPrepare()
        
        view.isMultipleTouchEnabled = true
    }
    
    private func setPropertyConstraints() {
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        takeBtn.translatesAutoresizingMaskIntoConstraints = false
        photoPreviewImageView.translatesAutoresizingMaskIntoConstraints = false
        flashBtn.translatesAutoresizingMaskIntoConstraints = false
        switchCameraBtn.translatesAutoresizingMaskIntoConstraints = false
        zoomSlider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoPreviewImageView)
        view.addSubview(closeBtn)
        view.addSubview(takeBtn)
        view.addSubview(flashBtn)
        view.addSubview(switchCameraBtn)
        view.addSubview(zoomSlider)
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarFrame.height).isActive = true
        closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        takeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        takeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takeBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        takeBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if isFullscreenCamera {
            photoPreviewImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            photoPreviewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            photoPreviewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            photoPreviewImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            photoPreviewImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            photoPreviewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            photoPreviewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            photoPreviewImageView.heightAnchor.constraint(equalTo: photoPreviewImageView.widthAnchor).isActive = true
        }

        flashBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        flashBtn.centerYAnchor.constraint(equalTo: takeBtn.centerYAnchor).isActive = true
        flashBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        flashBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        switchCameraBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        switchCameraBtn.centerYAnchor.constraint(equalTo: takeBtn.centerYAnchor).isActive = true
        switchCameraBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switchCameraBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        zoomSlider.bottomAnchor.constraint(equalTo: takeBtn.topAnchor, constant: -20).isActive = true
        zoomSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        zoomSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer?.frame = photoPreviewImageView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setCameraRunning(false)
        orientationDidChange()
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let previewLayer = previewLayer else { return }
        
        photoPreviewImageView.layoutIfNeeded()
        previewLayer.frame = photoPreviewImageView.bounds
        
        setCameraRunning(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cameraGone), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cameraShowing), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setupMethod() {
        takeBtn.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        switchCameraBtn.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        flashBtn.addTarget(self, action: #selector(toggleFlashlight), for: .touchUpInside)
        zoomSlider.addTarget(self, action: #selector(zoomCameraPreview(_:)), for: .valueChanged)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomPinch(_:)))
        photoPreviewImageView.addGestureRecognizer(pinchGesture)
        
        configMotionManager()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setDefaultFocusAndExposure), name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .black
        
        switchCameraBtn.isHidden = !isAllowSwitchCamera
        
        guard let device = cameraDevice.captureDevice else { return }
        flashBtn.isHidden = !(isAllowFlashlight && device.hasFlash)
    }
    
    private func sessionPrepare() {
        session = AVCaptureSession()
        
        guard let session = session, let captureDevice = cameraDevice.captureDevice else { return }
        
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            session.beginConfiguration()
            
            if session.canAddOutput(imageOutput) {
                session.addOutput(imageOutput)
            }
            
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            output.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
            if let prevLayer = previewLayer {
                photoPreviewImageView.layer.addSublayer(prevLayer)
            }
            
            session.startRunning()
            
        } catch {
            print("error with creating AVCaptureDeviceInput")
        }
    }
    
    private func reconfigSession() {
        session?.beginConfiguration()
        if let cameraInput = session?.inputs.first {
            session?.removeInput(cameraInput)
        }
        if let newCamera = cameraDevice.captureDevice {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: newCamera)
                
                if session?.canAddInput(deviceInput) == true {
                    session?.addInput(deviceInput)
                }
                
                session?.commitConfiguration()
                
                enableFlash(isFlashOn)
            } catch {
                print("error with creating AVCaptureDeviceInput")
            }
            
            zoomSlider.value = 1
            zoomSlider.isHidden = true
        }
    }
    
    func configMotionManager() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.2
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { [weak self] (motion, error) in
                if let motion = motion {
                    self?.outputAccelertionData(motion.gravity)
                }
            })
        }
    }
    
    func outputAccelertionData(_ acceleration: CMAcceleration) {
        var detectedOrientation: UIDeviceOrientation
        if acceleration.x >= 0.75 {
            detectedOrientation = .landscapeRight
        } else if acceleration.x <= -0.75 {
            detectedOrientation = .landscapeLeft
        } else if acceleration.y <= -0.75 {
            detectedOrientation = .portrait
        } else if acceleration.y >= 0.75 {
            detectedOrientation = .portraitUpsideDown
        } else {
            return
        }
        if detectedOrientation == currentOrientation {
            return
        }
        currentOrientation = detectedOrientation
        orientationDidChange()
    }
    
    @objc func orientationDidChange() {
        UIView.animate(withDuration: 0.25) {
            self.flashBtn.transform = CGAffineTransform(rotationAngle: self.radian)
            self.switchCameraBtn.transform = CGAffineTransform(rotationAngle: self.radian)
            self.takeBtn.transform = CGAffineTransform(rotationAngle: self.radian)
        }
    }
    
    @objc func setDefaultFocusAndExposure() {
        if let device = cameraDevice.captureDevice {
            do {
                try device.lockForConfiguration()
                device.isSubjectAreaChangeMonitoringEnabled = true
                device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                device.unlockForConfiguration()
                
            } catch {
                // Handle errors here
                print("There was an error focusing the device's camera")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchPoint = touches.first, touches.count == 1, touchPoint.view == photoPreviewImageView {
            let screenSize = photoPreviewImageView.bounds.size
            let focusPoint = CGPoint(x: touchPoint.location(in: photoPreviewImageView).y / screenSize.height, y: 1.0 - touchPoint.location(in: photoPreviewImageView).x / screenSize.width)

            if let device = cameraDevice.captureDevice {
                do {
                    try device.lockForConfiguration()
                    if device.isFocusPointOfInterestSupported {
                        device.focusPointOfInterest = focusPoint
                        device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                    }
                    if device.isExposurePointOfInterestSupported {
                        device.exposurePointOfInterest = focusPoint
                        device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    }
                    device.unlockForConfiguration()

                    autoFocus(at: touchPoint.location(in: view))
                    
                } catch let error {
                    print("Error touch \(error.localizedDescription)")
                }
            }
            
            autoFocus(at: touchPoint.location(in: view))
        }
    }
    
    // MARK: Component function
    @objc private func back() {
        motionManager.stopDeviceMotionUpdates()
        session?.stopRunning()
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func switchCamera() {
        cameraDevice = cameraDevice == .front ? .back : .front

        reconfigSession()
    }
    
    @objc func toggleFlashlight() {
        enableFlash(!self.isFlashOn)
    }
    
    func enableFlash(_ isEnable: Bool) {
        self.isFlashOn = isEnable
        
        if cameraDevice == .front {
            UIScreen.main.brightness = isEnable ? 1.0 : currentBrightness
            return
        }
        UIScreen.main.brightness = currentBrightness
    }
    
    @objc func zoomCameraPreview(_ slider: ZoomSlider) {
        let zoomLevel = slider.value
        
        guard let device = cameraDevice.captureDevice else { return }
        
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = CGFloat(zoomLevel)
            device.unlockForConfiguration()
        } catch {
            print("Zoom failed")
        }
    }
    
    @objc func zoomPinch(_ pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == .began {
            currentScale = zoomSlider.value
        }
        
        let maxScale = zoomSlider.maximumValue
        let scale = min(Float(pinchGesture.scale), maxScale)
        if scale == maxScale {
            currentScale = 1
        }
        
        zoomSlider.value = scale * currentScale
        zoomCameraPreview(zoomSlider)
    }
    
    private func autoFocus(at point: CGPoint) {
        focusView.startAnimate(at: point, in: self.view)
    }
    
    func cropImage(basedOn contentView: UIView, image: UIImage) -> UIImage {
        let previewWidth = contentView.frame.width
        let previewHeight = contentView.frame.height
        
        let width  = image.size.width * image.scale
        let height = image.size.height * image.scale
        
        let scale = min(width / previewWidth, height / previewHeight)
        
        let newWidth = previewWidth * scale
        let newHeight = previewHeight * scale
        
        let x = (width - newWidth) / 2
        let y = (height - newHeight) / 2
        let rect = CGRect(x: y, y: x, width: newHeight, height: newWidth)
        
        let cropImage = (image.cgImage?.cropping(to: rect))!
        
        return UIImage(cgImage: cropImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    @objc func takePhoto() {
        func takingPicture(action: ((UIImage) -> Void)?) {
            if let photoOutput = imageOutput as? AVCapturePhotoOutput {
                if let connection = photoOutput.connection(with: .video) {
                    connection.videoOrientation = .portrait
                    
                    takeAction = action
                    
                    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
                    if cameraDevice.captureDevice?.hasFlash == true {
                        settings.flashMode = isFlashOn ? .on : .off
                    }
                    photoOutput.capturePhoto(with: settings, delegate: self)
                }
            }
        }
        
        let takePhotoAction: ((UIImage) -> Void)? = { [weak self] image in
            guard let self = self else { return }
            
            self.delegate?.didCapture(self, image: image)
        }
        
        if isTakingPhoto {
            return
        }
        
        isTakingPhoto = true

        let flashView = UIView(frame: CGRect(origin: photoPreviewImageView.frame.origin, size: photoPreviewImageView.frame.size))
        flashView.alpha = 0.0
        flashView.backgroundColor = .white
        
        if cameraDevice == .front {
            self.view.addSubview(flashView)
            
            UIView.animate(withDuration: 0.15, animations: {
                flashView.alpha = 1.0
            }) { (finished) in
                if finished {
                    takingPicture { (image) in
                        UIView.animate(withDuration: 0.15, animations: {
                            flashView.alpha = 0.0
                        }) { (finished) in
                            if finished {
                                takePhotoAction?(image)
                                
                                flashView.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        } else {
            takingPicture(action: takePhotoAction)
        }
    }
    
    @objc private func cameraShowing() {
        setCameraRunning(true)
    }
    
    @objc private func cameraGone() {
        setCameraRunning(false)
    }
    
    func setCameraRunning(_ isRunning: Bool) {
        previewLayer?.connection?.isEnabled = isRunning
        
        if isRunning {
            if isFlashOn && cameraDevice == .front {
                UIScreen.main.brightness = 1.0
            }
        } else {
            UIScreen.main.brightness = currentBrightness
        }
        enableFlash(isRunning ? isFlashOn : false)
    }
}

private extension UIImage {
    var fixOrientation: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func rotate(radian: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radian)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radian))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            let image = UIImage(data: data)!
            let cropImage = self.cropImage(basedOn: photoPreviewImageView, image: image)
            let fixOrientation = cropImage.rotate(radian: -radian)!
            
            self.setCameraRunning(false)
            self.isTakingPhoto = false
            
            takeAction?(fixOrientation)
        }
    }
}
