import UIKit
import SnapKit

protocol DicomFilesViewInput: AnyObject {

}

protocol DicomFilesViewOutput: AnyObject {
  func viewDidLoad()
}


final class DicomFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Outlets


  // MARK: - Properties
  
  private let mainLabel = UILabel()
    
  private var tableOfDicom = UITableView()
  private let cellIndentifire = "Dicom"

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
      createTableView()
  }
  
    private func setupLabels() {
        mainLabel.text = "Серии снимков"
        mainLabel.font = .systemFont(ofSize: 36.0, weight: .bold)
        mainLabel.textColor = .white

        self.view.addSubview(mainLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(89)
            make.left.equalToSuperview().inset(32)
        }
    }
    
    private func createTableView() {
        self.tableOfDicom = UITableView(frame: view.bounds, style: .plain)
        tableOfDicom.register(UITableViewCell.self, forCellReuseIdentifier: cellIndentifire)
        
        self.tableOfDicom.delegate = self
        self.tableOfDicom.dataSource = self
        
        self.view.addSubview(tableOfDicom)
        
//        tableOfDicom.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableOfDicom.translatesAutoresizingMaskIntoConstraints = false
        tableOfDicom.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(179)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(413)
        }
    }
    
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifire, for: indexPath)
        
        cell.textLabel?.text = "section = \(indexPath.section), cell = \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.bounds.height - 179 - 413) / 3
    }
    //fff
    
    //MARK: - TableViewDataSource
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -› CGFloat {
//        return 100.0
//    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension DicomFilesViewController: DicomFilesViewInput {

}

//  tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "yourCell")
//
//  // MARK: tableView
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 3 // set to value needed
//  }
//
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "yourCell", for: indexPath) as! CustomTableViewCell
//    cell.textLabel?.text = "Cell at row \(indexPath.row)"
//    return cell
//  }
