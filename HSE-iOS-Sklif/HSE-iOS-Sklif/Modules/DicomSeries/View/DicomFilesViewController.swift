import UIKit
import SnapKit
import UniformTypeIdentifiers
import MobileCoreServices

protocol DicomFilesViewInput: AnyObject {

}

protocol DicomFilesViewOutput: AnyObject {
  func viewDidLoad()
}


final class DicomFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
  // MARK: - Outlets


  // MARK: - Properties
  
  private let mainLabel = UILabel()
    
  private var tableOfDicom = UITableView()
  private let cellIndentifire = "Dicom"
  private var cellsInfo = ["Тестовый снимок", "Тестовая серия снимков"]
  private var cellTestURLs = ["telegram-cloud-photo-size-2-5431460014284979770-y 1", "telegram-cloud-photo-size-2-5431460014284979770-y 1"]
  private var cellURLs = [""]
  private var cellUserURLs = [""]
  private var countOfDeletingTestCells = 0
    
  private var addButton = UIButton()
    
  private let supportedTypesOfFiles = [UTType.image, UTType.text, UTType.plainText, UTType.utf8PlainText,    UTType.utf16ExternalPlainText, UTType.utf16PlainText, UTType.delimitedText, UTType.commaSeparatedText,    UTType.tabSeparatedText, UTType.utf8TabSeparatedText, UTType.rtf, UTType.pdf, UTType.webArchive, UTType.image, UTType.jpeg, UTType.tiff, UTType.gif, UTType.png, UTType.bmp, UTType.ico, UTType.rawImage, UTType.svg, UTType.livePhoto, UTType.movie, UTType.video, UTType.audio, UTType.quickTimeMovie, UTType.mpeg,    UTType.mpeg2Video, UTType.mpeg2TransportStream, UTType.mp3, UTType.mpeg4Movie, UTType.mpeg4Audio, UTType.avi, UTType.aiff, UTType.wav, UTType.midi, UTType.archive, UTType.gzip, UTType.bz2, UTType.zip, UTType.appleArchive, UTType.spreadsheet, UTType.epub]

    
  private let userDefaults = UserDefaults()
    
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
      
      switch userDefaults.value(forKey: "cellURLs") {
      case let stringArray as [String]:
          if stringArray.count > 0 {
              cellURLs = cellTestURLs + stringArray
              cellUserURLs = stringArray
              
              for cellName in cellUserURLs {
                  let separatingStringURL = cellName.components(separatedBy: "/")
                  
                  cellsInfo.append("Ваша серия: " + separatingStringURL[separatingStringURL.count - 1])
              }
          } else {
              cellURLs = cellTestURLs
              cellUserURLs = [String]()
          }
      default:
          cellURLs = cellTestURLs
          cellUserURLs = [String]()
      }
      
      countOfDeletingTestCells = 0
//      print(cellURLs)
      
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
        
        tableOfDicom.translatesAutoresizingMaskIntoConstraints = false
        tableOfDicom.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(179)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(165)
        }
        
        tableOfDicom.layer.cornerRadius = 15
        tableOfDicom.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
    }
    
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifire, for: indexPath)
        
        cell.textLabel?.text = cellsInfo[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 37, green: 37, blue: 40)
        
        return cell
    }
    
    //MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.bounds.height - 179 - 165) / CGFloat(cellsInfo.count)
    }
    
    internal func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Trash action
        let trash = UIContextualAction(style: .destructive,
                                       title: "Удалить") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash(indexPath: indexPath)
                                        completionHandler(true)
        }
        trash.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [trash])

        return configuration
    }
    
    private func handleMoveToTrash(indexPath: IndexPath) {
        self.cellsInfo.remove(at: indexPath.row)
        self.cellURLs.remove(at: indexPath.row)
        
        if indexPath.row >= (2 - countOfDeletingTestCells) {
            self.cellUserURLs.remove(at: indexPath.row - 2 + countOfDeletingTestCells)
        }
        
        if indexPath.row == 0 || indexPath.row == 1 {
            if countOfDeletingTestCells == 0 && indexPath.row == 0 {
                countOfDeletingTestCells += 1
            } else if countOfDeletingTestCells == 0 && indexPath.row == 1 {
                countOfDeletingTestCells += 1
            } else if countOfDeletingTestCells == 1 && indexPath.row == 0 {
                countOfDeletingTestCells += 1
            }
        }
        
        userDefaults.set(cellUserURLs, forKey: "cellURLs")
        
        self.tableOfDicom.deleteRows(at: [indexPath], with: .automatic)
        self.tableOfDicom.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    private func setupButton() {
        addButton.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        addButton.tag = 1
        
        self.view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func addButtonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            dismiss(animated: true, completion: nil)
            
            selectFiles()
        }
    }
    
    func selectFiles() {
        let types = UTType.types(tag: "jpg",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        let stringURL = "\(myURL)"
        let separatingStringURL = stringURL.components(separatedBy: "/")
        
        cellsInfo.append("Ваша серия: " + separatingStringURL[separatingStringURL.count - 1])
        cellURLs.append(stringURL)
        cellUserURLs.append(stringURL)
        
        print(cellUserURLs)
        
        userDefaults.setValue(cellUserURLs, forKey: "cellURLs")
        
        // Add in array
        tableOfDicom.reloadData()
    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension DicomFilesViewController: DicomFilesViewInput {

}
