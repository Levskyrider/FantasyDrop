//
//  AuthViewModel.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit

enum AuthViewModelEvent {
  
}

class AuthViewModel {
  var onEvent: ((AuthViewModelEvent) -> ())?
  var api: Api
  
  init(api: Api = Api()) {
    self.api = api
  }
  
}
