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
      self.navigationController?.navigationBar.barTintColor = UIColor.black

    view.backgroundColor = .black
    
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
        
        print((output?.listOfPhotos[0])!)
        
        var testImage = UIImage()
        
        if (output?.listOfPhotos[0])!.count == 2 {
            testImage = UIImage(named: (output?.listOfPhotos[0])!)!
        } else {
            let urlImage = URL(string: (output?.listOfPhotos[0])!)!
            
            urlImage.startAccessingSecurityScopedResource()
            let imageData = try! Data(contentsOf: URL(string: (output?.listOfPhotos[0])!)!)
            testImage = UIImage(data: imageData)!
            urlImage.stopAccessingSecurityScopedResource()
        }
        
        imageView = UIImageView()
        
        self.imageScrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.top.left.right.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 11.0
        imageView.clipsToBounds = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = testImage
        imageView.center = imageScrollView.center
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        return self.imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }

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
        sliderForPhoto.value = 0
        sliderForPhoto.tag = 1
        
        if (Int((output?.listOfPhotos.count)!) == 1) {
            sliderForPhoto.isHidden = true
        }
        
        sliderForPhoto.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
    }
    
    @objc func sliderValueChange(sender: UISlider) {
        var currentValue = Int(sender.value)
        
        print((output?.listOfPhotos[currentValue])!)
        
        var testImage = UIImage()
        
        if (output?.listOfPhotos[currentValue])!.count == 2 {
            testImage = UIImage(named: (output?.listOfPhotos[currentValue])!)!
        } else {
            let urlImage = URL(string: (output?.listOfPhotos[currentValue])!)!
            
            urlImage.startAccessingSecurityScopedResource()
            let imageData = try! Data(contentsOf: URL(string: (output?.listOfPhotos[currentValue])!)!)
            testImage = UIImage(data: imageData)!
            urlImage.stopAccessingSecurityScopedResource()
        }
        
        self.imageView.image = testImage
    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
