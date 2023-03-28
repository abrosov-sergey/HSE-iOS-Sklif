//
//  MarkupScreenViewController.swift
//  HSE-iOS-Sklif
//
//  Created Сергей Абросов on 28.03.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MarkupScreenViewInput: AnyObject {

}

protocol MarkupScreenViewOutput: AnyObject {
  func viewDidLoad()
}


final class MarkupScreenViewController: UIViewController {

  // MARK: - Outlets


  // MARK: - Properties

  var output: MarkupScreenViewOutput?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {

  }

  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
