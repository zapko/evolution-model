//
// Created by Konstantin Zabelin on 04.01.2022.
//

import Foundation


public struct Cell: Equatable,
                    Hashable,
                    Codable,
                    ExpressibleByIntegerLiteral,
                    ExpressibleByStringLiteral {

    public private(set) var agents: Set<Agent>

    mutating public func add(agent: Agent) {
        agents.insert(agent)
    }

    mutating public func remove(agent: Agent) {
        agents.remove(agent)
    }

    public static let empty = Cell(agents: [])


    // MARK: - Initialization / Deinitialization

    public init(agents: [Agent]) {
        self.agents = Set(agents)
    }


    // MARK: - ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        agents = Set([.init(integerLiteral: value)])
    }


    // MARK: - ExpressibleByStringLiteral

    public init(stringLiteral value: String) {
        agents = Set(value
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)
            .map(Agent.init(attribute:)))
    }
}

