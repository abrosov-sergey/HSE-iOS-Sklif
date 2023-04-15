//
//  AuthorizationRouter.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 14.04.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
import UIKit

protocol AuthorizationRouterInput {
    func showDicomScreen()
}

final class AuthorizationRouter {

  // MARK: - Properties

  weak var view: UIViewController?
}

// MARK: - AuthorizationRouterInput

extension AuthorizationRouter: AuthorizationRouterInput {
    func showDicomScreen() {
        let (vc, input) = DicomFilesModuleConfigurator().configure()
        
        vc.modalPresentationStyle = .overFullScreen
        input.userAuth()
        
        self.view?.navigationController?.navigationBar.backgroundColor = .black
        self.view?.navigationController?.pushViewController(vc, animated: true)
        self.view?.navigationController?.navigationBar.backgroundColor = .black
    }
}

