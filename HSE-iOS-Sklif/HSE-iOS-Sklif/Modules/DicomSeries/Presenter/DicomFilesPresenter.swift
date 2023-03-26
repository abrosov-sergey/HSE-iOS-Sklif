//
//  DicomFilesPresenter.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 26.03.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol DicomFilesModuleInput: AnyObject {

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

  func viewDidLoad() {

  }
}

// MARK: - DicomFilesInput

extension DicomFilesPresenter: DicomFilesModuleInput {

}
