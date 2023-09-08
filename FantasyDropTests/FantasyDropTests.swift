//
//  FantasyDropTests.swift
//  FantasyDropTests
//
//  Created by Dmitro Levkutnyk on 08.09.2023.
//

import XCTest
@testable import FantasyDrop

final class FantasyDropTests: XCTestCase {
  
  let api = Api(refreshToken: "91q26ELJ1G4AAAAAAAAAAbFJ6S7TNhSfm928x1RMbC6WX71XTQbIGUuw_ekKpfgw")
  
  func testApp() {
    testRefreshToken()
    testLoadFilesList()
    testDownloadFile()
  }
  
  func testRefreshToken() {
    let expectation = expectation(description: "Test refresh token")
    api.refreshToken { token in
      if let token = token {
        XCTAssert(!token.isEmpty)
        expectation.fulfill()
      } else {
        XCTFail("Can't get token")
      }
    }
    
    wait(for: [expectation], timeout: 10)
  }
  
  func testDownloadFile() {
    let expectation = expectation(description: "Test downloading file")
    api.download(path: "/img_6346.heic") { result in
      switch result {
      case .success(let value):
        XCTAssert(value.1.isFileURL)
        expectation.fulfill()
      case .error(let errorDescription):
        XCTFail(errorDescription)
      }
    }
    wait(for: [expectation], timeout: 20)
  }
  
  func testLoadFilesList() {
    let expectation = expectation(description: "Test load file list")
    api.loadFilesList { result in
      switch result {
      case .success(let value):
        XCTAssert(!value.isEmpty)
        expectation.fulfill()
      case .error(let string):
        XCTFail(string)
      }
    }
    wait(for: [expectation], timeout: 10)
  }
  
}
