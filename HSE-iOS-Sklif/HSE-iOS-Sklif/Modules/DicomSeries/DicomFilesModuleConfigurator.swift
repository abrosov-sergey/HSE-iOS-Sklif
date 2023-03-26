//
//  DicomFilesModuleConfigurator.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 26.03.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class DicomFilesModuleConfigurator {

  // MARK: - Configure

  func configure(
    output: DicomFilesModuleOutput? = nil
  ) -> (
    view: DicomFilesViewController,
    input: DicomFilesModuleInput
  ) {
    let view = DicomFilesViewController()
    let presenter = DicomFilesPresenter()
    let router = DicomFilesRouter()

    presenter.view = view
    presenter.router = router
    presenter.output = output

    router.view = view

    view.output = presenter

    return (view, presenter)
  }
}

