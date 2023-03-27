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
    
  private var addButton = UIButton()

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
      setupButton()
  }
  
    private func setupLabels() {
        mainLabel.text = "Серии снимков"
        mainLabel.font = .systemFont(ofSize: 36.0, weight: .bold)
        mainLabel.textColor = .white

        self.view.addSubview(mainLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(89)
            make.left.equalToSuperview().inset(16)
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
        
        tableOfDicom.layer.cornerRadius = 15
        tableOfDicom.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
    }
    
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifire, for: indexPath)
        
        cell.textLabel?.text = "Section = \(indexPath.section), Cell = \(indexPath.row)"
        cell.textLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
        
        return cell
    }
    
    //MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.bounds.height - 179 - 413) / 3
    }
    
    private func setupButton() {
        addButton.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        addButton.tag = 1
        
        self.view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(150)
//            make.top.equalToSuperview().inset(714)
            make.bottom.equalToSuperview().inset(54)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func addButtonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            dismiss(animated: true, completion: nil)
        }
    }
    
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