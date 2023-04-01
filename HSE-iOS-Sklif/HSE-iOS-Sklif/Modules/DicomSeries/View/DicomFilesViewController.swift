import UIKit
import SnapKit
import UniformTypeIdentifiers

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
  private var cellsInfo = ["Один снимок формата .image", "Серия снимков формата .image", "Один снимок в серии DICOM", "Несколько снимков в серии DICOM"]
//  private var cellsImages
    
  private var addButton = UIButton()
    
  private let supportedTypesOfFiles = [UTType.image, UTType.text, UTType.plainText, UTType.utf8PlainText,    UTType.utf16ExternalPlainText, UTType.utf16PlainText, UTType.delimitedText, UTType.commaSeparatedText,    UTType.tabSeparatedText, UTType.utf8TabSeparatedText, UTType.rtf, UTType.pdf, UTType.webArchive, UTType.image, UTType.jpeg, UTType.tiff, UTType.gif, UTType.png, UTType.bmp, UTType.ico, UTType.rawImage, UTType.svg, UTType.livePhoto, UTType.movie, UTType.video, UTType.audio, UTType.quickTimeMovie, UTType.mpeg,    UTType.mpeg2Video, UTType.mpeg2TransportStream, UTType.mp3, UTType.mpeg4Movie, UTType.mpeg4Audio, UTType.avi, UTType.aiff, UTType.wav, UTType.midi, UTType.archive, UTType.gzip, UTType.bz2, UTType.zip, UTType.appleArchive, UTType.spreadsheet, UTType.epub]

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
    
//    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//
//    private func tableView(_ tableView: UITableView, editActionForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") { (_, indexPath) in
//
//            self.cellsInfo.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
//        }
//
//        deleteAction.backgroundColor = .systemRed
//        return [deleteAction]
//    }
    
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
        
        self.tableOfDicom.deleteRows(at: [indexPath], with: .automatic)
        self.tableOfDicom.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

//    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//            //tableView.cellForRow(at: NSIndexPath)?.delete(<#T##sender: Any?##Any?#>)
//            cellsInfo.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
//            //tableView.reloadData()
//        }
//    }
    
    private func setupButton() {
        addButton.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        addButton.tag = 1
        
        self.view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(150)
//            make.top.equalToSuperview().inset(714)
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func addButtonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            dismiss(animated: true, completion: nil)
            
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypesOfFiles, asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
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
