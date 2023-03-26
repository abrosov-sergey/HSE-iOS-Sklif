import UIKit
import SnapKit

protocol DicomFilesViewInput: AnyObject {

}

protocol DicomFilesViewOutput: AnyObject {
  func viewDidLoad()
}


final class DicomFilesViewController: UIViewController {

  // MARK: - Outlets


  // MARK: - Properties
  
  private let mainLabel = UILabel()

  var output: DicomFilesViewOutput?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    
    setupUI()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
      view.backgroundColor = .black
      
      setupLabels()
  }
  
    private func setupLabels() {
        mainLabel.text = "Серии снимков формата DICOM"
        mainLabel.font = .systemFont(ofSize: 40.0, weight: .bold)
        mainLabel.textColor = .white

        self.view.addSubview(mainLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalToSuperview().inset(32)
        }
    }

  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension DicomFilesViewController: DicomFilesViewInput {

}
