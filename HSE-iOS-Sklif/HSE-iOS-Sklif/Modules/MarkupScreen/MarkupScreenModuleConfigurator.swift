import UIKit

final class MarkupScreenModuleConfigurator {

  // MARK: - Configure

  func configure(
    output: MarkupScreenModuleOutput? = nil
  ) -> (
    view: MarkupScreenViewController,
    input: MarkupScreenModuleInput
  ) {
    let view = MarkupScreenViewController()
    let presenter = MarkupScreenPresenter()
    let router = MarkupScreenRouter()

    presenter.view = view
    presenter.router = router
    presenter.output = output

    router.view = view

    view.output = presenter

    return (view, presenter)
  }
}

