//
//  RootSceneTests.swift
//  iOSAppTests
//
//  Created by Morisson Marcel on 01/12/22.
//

@testable import iOSApp
import ViewInspector
import XCTest
import SwiftUI

extension RootScene: Inspectable { }

final class RootSceneTests: XCTestCase {
    func testViewHierarchy() throws {
        let expected = "Hello, world!"
        let sut = RootScene()
        
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
}
