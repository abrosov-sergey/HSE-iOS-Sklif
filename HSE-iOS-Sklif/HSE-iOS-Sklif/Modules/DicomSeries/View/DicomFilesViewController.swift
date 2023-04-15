import UIKit
import SnapKit
import UniformTypeIdentifiers
import MobileCoreServices
import ZIPFoundation

protocol DicomFilesViewInput: AnyObject {

}

protocol DicomFilesViewOutput: AnyObject {
  func viewDidLoad()
  func cellDidPressed(arrayOfPhotos: [String])
}


final class DicomFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
  // MARK: - Outlets


  // MARK: - Properties
  
  private let mainLabel = UILabel()
    
  private var tableOfDicom = UITableView()
  private let cellIndentifire = "Dicom"
  private var cellsInfo = ["Тестовый снимок", "Тестовая серия снимков"]
  private var cellTestURLs = [String : [String]]()
  private var cellURLs = [String : [String]]()
  private var cellUserURLs = [String : [String]]()
  private var countOfDeletingTestCells = 0
    
  private var addButton = UIButton()
    
//  private let supportedTypesOfFiles = [UTType.image, UTType.text, UTType.plainText, UTType.utf8PlainText,    UTType.utf16ExternalPlainText, UTType.utf16PlainText, UTType.delimitedText, UTType.commaSeparatedText,    UTType.tabSeparatedText, UTType.utf8TabSeparatedText, UTType.rtf, UTType.pdf, UTType.webArchive, UTType.image, UTType.jpeg, UTType.tiff, UTType.gif, UTType.png, UTType.bmp, UTType.ico, UTType.rawImage, UTType.svg, UTType.livePhoto, UTType.movie, UTType.video, UTType.audio, UTType.quickTimeMovie, UTType.mpeg,    UTType.mpeg2Video, UTType.mpeg2TransportStream, UTType.mp3, UTType.mpeg4Movie, UTType.mpeg4Audio, UTType.avi, UTType.aiff, UTType.wav, UTType.midi, UTType.archive, UTType.gzip, UTType.bz2, UTType.zip, UTType.appleArchive, UTType.spreadsheet, UTType.epub]
    
    private let supportedTypesOfFiles = [UTType.image, UTType.image, UTType.jpeg, UTType.png,  UTType.rawImage, UTType.svg, UTType.video, UTType.avi, UTType.archive, UTType.gzip, UTType.zip]

    
  private let userDefaults = UserDefaults()
    
  var output: DicomFilesViewOutput?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
      
    cellTestURLs["0"] = ["22"]
    cellTestURLs["1"] = ["11", "22", "33", "44", "11", "22", "33", "44", "11", "22", "33"]
    
    setupUI()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
      view.backgroundColor = .black
      
//      userDefaults.setValue("", forKey: "cellURLs")
      
      let jsonDecoder = JSONDecoder()
//      let stringArray1 = try? jsonDecoder.decode([String : [String]].self, from: userDefaults.value(forKey: "cellURLs") as! Data)
      let stringArray1 = [String : [String]]()
      
      switch stringArray1 {
      case let stringArray as [String : [String]]:
          if stringArray.count > 0 {
              cellURLs = cellTestURLs
              cellURLs = cellURLs.merging(stringArray) { (current, _) in current }
              cellUserURLs = stringArray
              
              for cellName in cellUserURLs {
                  if cellName.value.count >= 1 {
                      let separatingStringURL = cellName.value[0].components(separatedBy: "/")
                      
                      cellsInfo.append("Ваша серия: " + separatingStringURL[separatingStringURL.count - 1])
                  } else {
                      cellsInfo.append("Ваша серия: " + "пусто")
                  }
              }
          } else {
              cellURLs = cellTestURLs
          }
      default:
          cellURLs = cellTestURLs
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
        self.cellURLs.removeValue(forKey: "\(indexPath.row)")
        
        if indexPath.row >= (2 - countOfDeletingTestCells) {
            self.cellUserURLs.removeValue(forKey: "\(indexPath.row - 2 + countOfDeletingTestCells)")
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
        
        let jsonData = try? JSONSerialization.data(withJSONObject: cellUserURLs)
        userDefaults.set(jsonData, forKey: "cellURLs")
        
        self.tableOfDicom.deleteRows(at: [indexPath], with: .automatic)
        self.tableOfDicom.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        output?.cellDidPressed(arrayOfPhotos: cellURLs["\(indexPath.row)"]!)
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
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypesOfFiles)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        myURL.startAccessingSecurityScopedResource()
        
        let stringURL = "\(myURL)"
        let separatingStringURL = stringURL.components(separatedBy: "/")
        
        cellsInfo.append("Ваша серия: " + separatingStringURL[separatingStringURL.count - 1])
        
        if 1 == 0 {
            let fileManager = FileManager()
        
            var sourceURL = myURL
            var destinationURL = "file:/"
            
//            print(sourceURL)
//            sourceURL.deletingLastPathComponent()
//            print(sourceURL)
//            sourceURL.appendingPathComponent("p")
//            print(sourceURL)
            
            sourceURL.startAccessingSecurityScopedResource()
            URL(string: destinationURL)!.startAccessingSecurityScopedResource()
            
            for i in 1..<(separatingStringURL.count - 1) {
                destinationURL += separatingStringURL[i]
                if i != separatingStringURL.count - 2 {
                    destinationURL += "/"
                }
            }
//            destinationURL += "/NewDirectory"

            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let docURL = URL(string: documentsDirectory)!
            let dataPath = docURL.appendingPathComponent("MyFolder2")
            
            dataPath.startAccessingSecurityScopedResource()
            print(docURL)
            print(dataPath)
            
            if !FileManager.default.fileExists(atPath: dataPath.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            do {
                
                print(sourceURL)
                print(destinationURL)
                
                try fileManager.unzipItem(at: URL(fileURLWithPath: "\(sourceURL)"), to: dataPath)
            } catch {
                print("Extraction of ZIP archive failed with error:\(error)")
            }
            
            var newUrls: [String] = []
            
            do {
                let fileManager = FileManager.default
                
                do {
                    let fileURLs = try fileManager.contentsOfDirectory(atPath: "\(dataPath)")
                    
                    newUrls = fileURLs
                    
                    print(fileURLs)
                } catch {
                    print("Error while enumerating files")
                }
            } catch {
                print(error)
            }
            
            let count1 = Int(cellURLs.count)
            cellURLs["\(count1)"] = newUrls

            if !cellUserURLs.isEmpty {
                print("here1")

                let count2 = cellUserURLs.count
                cellUserURLs["\(count2)"] = newUrls
            } else {
                print("here2")
                
                cellUserURLs["0"] = newUrls
            }
            
            sourceURL.stopAccessingSecurityScopedResource()
            URL(string: destinationURL)!.stopAccessingSecurityScopedResource()
            dataPath.stopAccessingSecurityScopedResource()
        } else {
            let count1 = Int(cellURLs.count)
            cellURLs["\(count1)"] = [stringURL]

            if !cellUserURLs.isEmpty {
                print("here1")

                let count2 = cellUserURLs.count
                cellUserURLs["\(count2)"] = [stringURL]
            } else {
                print("here2")
                
                cellUserURLs["0"] = [stringURL]
            }
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: cellUserURLs)
        userDefaults.set(jsonData, forKey: "cellURLs")
        
        // Add in array
        tableOfDicom.reloadData()
        
        myURL.stopAccessingSecurityScopedResource()
    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension DicomFilesViewController: DicomFilesViewInput {

}
