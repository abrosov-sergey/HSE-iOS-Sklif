import UIKit

protocol MarkupScreenViewInput: AnyObject {

}

protocol MarkupScreenViewOutput: AnyObject {
  func viewDidLoad()
}


final class MarkupScreenViewController: UIViewController, UIScrollViewDelegate {

  // MARK: - Outlets


  // MARK: - Properties

  var output: MarkupScreenViewOutput?
    
    private var imageScrollView = UIScrollView()
    private var imageView: UIImageView!
    private var sliderForPhoto = UISlider()
    
    private var listOfPhotos = [String]()

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    
    view.backgroundColor = .black
    
    listOfPhotos = ["1", "2", "3", "4", "5", "6", "6", "6", "6", "6", "6"]
    
    setupUI()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
      createScrollView()
      addTestImage()
      setupSlider()
  }

    private func createScrollView() {
        imageScrollView = UIScrollView(frame: view.bounds)
        
        imageScrollView.delegate = self
        
        self.view.addSubview(imageScrollView)
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(63)
            make.left.equalToSuperview().inset(7)
            make.right.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(100)
        }

        imageScrollView.isPagingEnabled = true
        imageScrollView.layer.cornerRadius = 15
//        imageScrollView.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
        imageScrollView.backgroundColor = .black
        imageScrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.showsVerticalScrollIndicator = true
        imageScrollView.flashScrollIndicators()
        imageScrollView.minimumZoomScale = 0.1
        imageScrollView.maximumZoomScale = 5.0
        imageScrollView.layer.borderColor = CGColor(red: 0.1, green: 0.1, blue: 0.55, alpha: 1)
        imageScrollView.layer.borderWidth = 2.5
    }
    
    private func addTestImage() {
        imageView?.removeFromSuperview()
        imageView = nil
        
        let testImage = UIImage(named: "telegram-cloud-photo-size-2-5431460014284979770-y 1")!
        imageView = UIImageView()
        
        self.imageScrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.top.left.right.equalToSuperview()
        }
        
        imageView.image = testImage
        imageView.layer.cornerRadius = 11.0
        imageView.clipsToBounds = false
//        imageView.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
        imageView.backgroundColor = .black
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
    
        imageScrollView.contentSize = testImage.size
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        // Your action
//    }

    private func setupSlider() {
        self.view.addSubview(sliderForPhoto)
        
        sliderForPhoto.translatesAutoresizingMaskIntoConstraints = false
        sliderForPhoto.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(50)
        }
        
        sliderForPhoto.thumbTintColor = UIColor(red: 47, green: 47, blue: 50)
        sliderForPhoto.tintColor = UIColor(red: 47, green: 47, blue: 155)
        sliderForPhoto.minimumValue = 0
        sliderForPhoto.maximumValue = Float(listOfPhotos.count - 1)
        sliderForPhoto.value = 1
        sliderForPhoto.tag = 1

        sliderForPhoto.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
    }
    
    @objc func sliderValueChange(sender: UISlider) {
        var currentValue = Int(sender.value)
        var sliderRow = sender.tag
        
        print(currentValue)
    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
