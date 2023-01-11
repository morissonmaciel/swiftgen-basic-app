//
//  ReaderViewModelTests.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 10/01/23.
//

import XCTest
@testable import PaperedApp

final class ReaderViewModelTests: XCTestCase {
    
    func testExtractArticleContents() {
        let url = URL(string: "https://spacenews.com/chinas-tianwen-1-mars-orbiter-and-rover-appear-to-be-in-trouble/")!
        let sut = ReaderViewModel.shared
        let expectation = expectation(description: "Remote scrap url")
        
        sut.extractArticleContents(for: url) { result in
            expectation.fulfill()
            
            switch result {
            case .success(let text):
                XCTAssertTrue(text.count > 0)
                XCTAssertTrue(text.localizedStandardContains("China"))
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
            
        }
        
        waitForExpectations(timeout: 5)
    }
}
