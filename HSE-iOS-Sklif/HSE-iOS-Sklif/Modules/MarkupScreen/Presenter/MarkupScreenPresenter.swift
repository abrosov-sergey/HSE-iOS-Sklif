protocol MarkupScreenModuleInput: AnyObject {
    func cellDidPressed(arrayOfPhotos: [String])
}

protocol MarkupScreenModuleOutput: AnyObject {

}

final class MarkupScreenPresenter {

  // MARK: - Properties
    
  var listOfPhotos = [String]()

  weak var view: MarkupScreenViewInput?
  var router: MarkupScreenRouterInput?
  weak var output: MarkupScreenModuleOutput?
}

// MARK: - MarkupScreenViewOutput

extension MarkupScreenPresenter: MarkupScreenViewOutput {

  func viewDidLoad() {

  }
}

// MARK: - MarkupScreenInput

extension MarkupScreenPresenter: MarkupScreenModuleInput {
    func cellDidPressed(arrayOfPhotos: [String]) {
        listOfPhotos = arrayOfPhotos
    }
    

}
