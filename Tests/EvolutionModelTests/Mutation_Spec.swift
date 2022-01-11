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

        _ = sut([.remove(2), .remove(3), .remove(4)])

        waitForExpectations(timeout: 0.1)
    }

    func test_Mutator_applies_mutation_it_receives_from_picker() throws {

        let sut = Mutation.makeMutator(picker: { _ in .add(.remove(1), at: 0) })

        XCTAssertEqual(
            sut(nil),
            [.remove(1)]
        )
    }

    func test_Mutation_picker_always_returns_add_at_0_when_length_is_zero() throws {

        let sut = Mutation.makeMutationPicker(
            actionGenerator: { .change(1, to: 2) })

        for _ in 0...100 {
            XCTAssertEqual(sut(0), .add(.change(1, to: 2), at: 0))
        }
    }

    func test_Mutation_picker_uses_action_generator_to_get_new_actions() throws {

        let generatorIsCalled = expectation(description: "Generator is called")

        let sut = Mutation.makeMutationPicker(
            actionGenerator: {
                generatorIsCalled.fulfill()
                return .change(1, to: 2) })

        _ = sut(0)

        waitForExpectations(timeout: 0.1)
    }

    func test_Mutation_picker_returns_random_mutation_with_index_from_0_to_length_minus_1 () throws {

        let sut = Mutation.makeMutationPicker { .remove(0) }

        struct Accumulator {
            var additionIndices = Set<Int>()
            var removalIndices = Set<Int>()
            var replacementIndices = Set<Int>()
        }

        let accumulator = (0...1000)
            .map { _ in sut(5) }
            .reduce(into: Accumulator()) {
                switch $1 {
                case .add(_, let index): $0.additionIndices.insert(index)
                case .remove(let index): $0.removalIndices.insert(index)
                case .replace(let index, _): $0.replacementIndices.insert(index)
                }
            }

        XCTAssertEqual(accumulator.additionIndices, Set([0, 1, 2, 3, 4, 5]))
        XCTAssertEqual(accumulator.removalIndices, Set([0, 1, 2, 3, 4]))
        XCTAssertEqual(accumulator.replacementIndices, Set([0, 1, 2, 3, 4]))
    }
}

