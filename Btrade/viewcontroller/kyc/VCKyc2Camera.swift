import UIKit
import AVFoundation
class VCKyc2Camera: VCBase, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var photo_btn: UIButton!
    weak var delegate:CameraResult?
    
    
    let photo_imageview : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .brown
        return iv
    }()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //let imageviewheight : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setuplayout()
     }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 여기다가 frame 값을 넣은 이유는 viewdidload에서는 view1의 레이아웃이 다 지정되지 않았기 때문에 생명주기를 활용하여 viewdidload다음 순서에서 view1의 데이터를 받아온다.
        
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            DispatchQueue.main.async {
                // 여기서 view1 은 내가 카메라가 나올 uiView
                self.videoPreviewLayer.frame = self.view1.bounds
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    var cameraPosition: AVCaptureDevice.Position = .back
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let oldImage = UIImage(data: imageData)!
        let newImage = rotateImage(image:oldImage)
        delegate?.result(newImage.jpegData(compressionQuality: 1.0))
        goBack(view1!)
        
    }
    
    func rotateImage(image:UIImage)->UIImage{
        var rotatedImage = UIImage();
        switch image.imageOrientation
        {
            case .right:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:.up);
            
           case .down:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:.up);
            
            case .left:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:.up);
    
        default:
                return image
        }
        return rotatedImage;
    }
    
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        
        
        
        // 여기서 view1 은 내가 카메라가 나올 uiView
        view1.layer.addSublayer(videoPreviewLayer)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setuplayout(){
        //view.addSubview(photo_imageview)
        //photoImageViewManager()
    }
    
    
    func photoImageViewManager() {
        photo_imageview.widthAnchor.constraint(equalToConstant: 100).isActive = true
        photo_imageview.heightAnchor.constraint(equalToConstant: 100).isActive = true
        photo_imageview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        photo_imageview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
}
