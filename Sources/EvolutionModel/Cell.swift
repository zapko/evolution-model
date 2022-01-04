//
// Created by Konstantin Zabelin on 04.01.2022.
//

import Foundation


public struct Cell: Equatable,
                    Hashable,
                    ExpressibleByIntegerLiteral,
                    ExpressibleByStringLiteral {

    public private(set) var agents: [Agent]

    mutating public func add(agent: Agent) {
        agents.append(agent)
    }

    mutating public func remove(agent: Agent) {
        guard let index = agents.firstIndex(of: agent) else {
            return
        }

        agents.remove(at: index)
    }


    // MARK: - Initialization / Deinitialization

    public init(agents: [Agent]) {
        self.agents = agents
    }


    // MARK: - ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        agents = [.init(integerLiteral: value)]
    }


    // MARK: - ExpressibleByStringLiteral

    public init(stringLiteral value: String) {
        agents = value
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)
            .map(Agent.init(attribute:))
    }
}

