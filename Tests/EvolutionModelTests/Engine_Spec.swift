//
// Created by Konstantin Zabelin on 03.01.2022.
//

import XCTest
import EvolutionModel


final class Engine_Spec: XCTestCase {

    func test_empty_space_produces_no_changes() throws {

        let sut = Engine()
        let state = Engine.State(space: [], behaviours: [:])

        XCTAssertTrue(sut.determineSpaceChanges(for: state).isEmpty)
    }
}
