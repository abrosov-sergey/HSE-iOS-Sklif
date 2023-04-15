//
//  DicomFilesPresenter.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 26.03.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol DicomFilesModuleInput: AnyObject {
    func userAuth()
}

protocol DicomFilesModuleOutput: AnyObject {

}

final class DicomFilesPresenter {

  // MARK: - Properties

  weak var view: DicomFilesViewInput?
  var router: DicomFilesRouterInput?
  weak var output: DicomFilesModuleOutput?
}

// MARK: - DicomFilesViewOutput

extension DicomFilesPresenter: DicomFilesViewOutput {
    func cellDidPressed(arrayOfPhotos: [String]) {
        print("here2")
        router?.showMakupScreen(arrayOfPhotos: arrayOfPhotos)
    }
    

  func viewDidLoad() {

  }
}

// MARK: - DicomFilesInput

extension DicomFilesPresenter: DicomFilesModuleInput {
    func userAuth() {
        //
    }
}
