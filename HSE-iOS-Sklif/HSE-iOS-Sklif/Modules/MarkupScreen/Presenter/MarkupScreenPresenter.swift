protocol MarkupScreenModuleInput: AnyObject {

}

protocol MarkupScreenModuleOutput: AnyObject {

}

final class MarkupScreenPresenter {

  // MARK: - Properties

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

}
