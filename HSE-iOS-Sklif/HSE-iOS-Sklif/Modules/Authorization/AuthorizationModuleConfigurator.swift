//
//  AuthorizationModuleConfigurator.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 14.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class AuthorizationModuleConfigurator {

  // MARK: - Configure

  func configure(
    output: AuthorizationModuleOutput? = nil
  ) -> (
    view: AuthorizationViewController,
    input: AuthorizationModuleInput
  ) {
    let view = AuthorizationViewController()
    let presenter = AuthorizationPresenter()
    let router = AuthorizationRouter()

    presenter.view = view
    presenter.router = router
    presenter.output = output

    router.view = view

    view.output = presenter

    return (view, presenter)
  }
}

