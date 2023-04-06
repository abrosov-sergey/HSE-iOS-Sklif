import UIKit

protocol MarkupScreenViewInput: AnyObject {

}

protocol MarkupScreenViewOutput: AnyObject {
  func viewDidLoad()
  var listOfPhotos: [String] { get }
}


final class MarkupScreenViewController: UIViewController, UIScrollViewDelegate {

  // MARK: - Outlets


  // MARK: - Properties

  var output: MarkupScreenViewOutput?
    
    private var imageScrollView = UIScrollView()
    private var imageView: UIImageView!
    private var sliderForPhoto = UISlider()
    

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    
      self.navigationController?.navigationBar.backgroundColor = .black
//      self.navigationController?.navigationBar.tintColor = .black
//      self.navigationController?.navigationBar.barStyle = .black
      self.navigationController?.navigationBar.barTintColor = UIColor.black
//      self.navigationController?.navigationBar.tintColor = .black

    view.backgroundColor = .black
    
//    listOfPhotos = ["file:///Users/sergeyabrosov/Library/Developer/CoreSimulator/Devices/CBB4E03E-4E64-418D-8926-87044F5C200A/data/Containers/Shared/AppGroup/EFA30EB2-323E-4CED-A605-191AF1F17C6D/File%20Provider%20Storage/%D0%97%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B8/njashnye-kotiki4%202", "11", "22", "33", "44", "11", "22", "33", "44", "11", "22", "33"]
    
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
            make.top.equalToSuperview().inset(100)
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
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = true
        imageScrollView.flashScrollIndicators()
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 5.0
        imageScrollView.layer.borderColor = CGColor(red: 0.1, green: 0.1, blue: 0.55, alpha: 1)
        imageScrollView.layer.borderWidth = 2.5
    }
    
    private func addTestImage() {
        imageView?.removeFromSuperview()
        imageView = nil
        
        let testImage = UIImage(named: (output?.listOfPhotos[0])!)
        imageView = UIImageView()
        
        self.imageScrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.top.left.right.equalToSuperview()
        }
        
//        imageView.contentScaleFactor = 0.5
//        imageView.scalesLargeContentImage = false
        imageView.layer.cornerRadius = 11.0
        imageView.clipsToBounds = false
        imageView.backgroundColor = .black
//        imageView.contentMode = .center
//        imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = testImage
        imageView.center = imageScrollView.center
    
        //imageScrollView.contentSize = testImage.size
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        return self.imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
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
        sliderForPhoto.tintColor = UIColor(red: 25, green: 25, blue: 140)
        sliderForPhoto.minimumValue = 0
        sliderForPhoto.maximumValue = Float((output?.listOfPhotos.count)! - 1)
        sliderForPhoto.value = 1
        sliderForPhoto.tag = 1
        
        if (Int((output?.listOfPhotos.count)!) == 1) {
            sliderForPhoto.isHidden = true
        }
        
        sliderForPhoto.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
    }
    
    @objc func sliderValueChange(sender: UISlider) {
        var currentValue = Int(sender.value)
//        var sliderRow = sender.tag
        
        self.imageView.image = UIImage(named: (output?.listOfPhotos[currentValue])!)
    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
