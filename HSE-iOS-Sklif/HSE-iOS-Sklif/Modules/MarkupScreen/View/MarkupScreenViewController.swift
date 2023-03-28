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
        self.imageScrollView = UIScrollView(frame: view.bounds)
        imageScrollView.isPagingEnabled = true
        
        self.imageScrollView.delegate = self
        
        self.view.addSubview(imageScrollView)
        
    //        tableOfDicom.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(63)
            make.left.equalToSuperview().inset(7)
            make.right.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(63)
        }
        
        imageScrollView.layer.cornerRadius = 15
        imageScrollView.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
    }
    
    private func addTestImage() {
//        var testImage: UIImage?
        let testImage = UIImage(named: "telegram-cloud-photo-size-2-5431460014284979770-y 1")
        
//        var rect = self.view.bounds
        let imageView = UIImageView()
        
        self.imageScrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.bottom.top.left.right.equalToSuperview()
        }
        
        imageView.contentMode = .center
        imageView.image = testImage
    }
    
//    private func newImageViewWithImage(rects: CGRect) -> UIImageView {
//        let result = UIImageView(frame: rects)
//
//        return result
//    }

  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
