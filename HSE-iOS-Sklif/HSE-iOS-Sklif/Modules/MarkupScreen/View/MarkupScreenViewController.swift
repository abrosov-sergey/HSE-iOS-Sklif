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

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    
    view.backgroundColor = .black
      
    setupUI()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
      
      createScrollView()
      addTestImage()
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
            make.bottom.equalToSuperview().inset(63)
        }

        imageScrollView.isPagingEnabled = true
        imageScrollView.layer.cornerRadius = 15
        imageScrollView.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
        imageScrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.showsVerticalScrollIndicator = true
        imageScrollView.flashScrollIndicators()
        imageScrollView.minimumZoomScale = 0.1
        imageScrollView.maximumZoomScale = 5.0
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
        imageView.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
    
        imageScrollView.contentSize = testImage.size
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // Your action
    }

  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
