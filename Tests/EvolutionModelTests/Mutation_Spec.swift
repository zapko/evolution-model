//
// Created by Konstantin Zabelin on 10.01.2022.
//

import XCTest
import EvolutionModel


final class Mutation_Spec: XCTestCase {

    func test_Mutator_passes_length_of_mutated_behaviour_to_the_picker() throws {

        let pickerIsCalled = expectation(description: "Picker is called")

        let sut = Mutation.makeMutator(picker: {
            length in
            pickerIsCalled.fulfill()
            XCTAssertEqual(length, 3)
            return .add(.remove(1), at: 0)
        })

        sut([.remove(2), .remove(3), .remove(4)])

        waitForExpectations(timeout: 0.1)
    }

    func test_Mutator_applies_mutation_it_receives_from_picker() throws {

        let sut = Mutation.makeMutator(picker: { _ in .add(.remove(1), at: 0) })

        XCTAssertEqual(
            sut(nil),
            [.remove(1)]
        )
    }
}

