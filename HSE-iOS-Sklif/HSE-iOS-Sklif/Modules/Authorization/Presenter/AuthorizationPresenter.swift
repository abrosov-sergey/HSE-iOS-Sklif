//
//  AuthorizationPresenter.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 14.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol AuthorizationModuleInput: AnyObject {

}

protocol AuthorizationModuleOutput: AnyObject {

}

final class AuthorizationPresenter {

  // MARK: - Properties

  weak var view: AuthorizationViewInput?
  var router: AuthorizationRouterInput?
  weak var output: AuthorizationModuleOutput?
}

// MARK: - AuthorizationViewOutput

extension AuthorizationPresenter: AuthorizationViewOutput {

  func viewDidLoad() {

  }
}

// MARK: - AuthorizationInput

extension AuthorizationPresenter: AuthorizationModuleInput {

}
