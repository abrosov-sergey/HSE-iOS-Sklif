//
//  DicomFilesRouter.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 26.03.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
import UIKit

protocol DicomFilesRouterInput {
    func showMakupScreen(arrayOfPhotos: [String])
}

final class DicomFilesRouter {

  // MARK: - Properties

  weak var view: UIViewController?
}

// MARK: - DicomFilesRouterInput

extension DicomFilesRouter: DicomFilesRouterInput {
    func showMakupScreen(arrayOfPhotos: [String]) {
        print("here")
        
        let (vc, input) = MarkupScreenModuleConfigurator().configure()
        
        vc.modalPresentationStyle = .overFullScreen
        input.cellDidPressed(arrayOfPhotos: arrayOfPhotos)
        
//        self.view?.present(vc, animated: true)
        self.view?.navigationController?.navigationBar.backgroundColor = .black
        self.view?.navigationController?.pushViewController(vc, animated: true)
        self.view?.navigationController?.navigationBar.backgroundColor = .black
    }
    
    
}

