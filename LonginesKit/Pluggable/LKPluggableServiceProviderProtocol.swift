//
//  LKPluggableServiceProviderProtocol.swift
//
//  Created by aiden on 27/10/2023.
//

import Foundation
public protocol PluggableServiceProviderProtocol {
    associatedtype S
    var services: [S] { get }

    func queryService<S>() -> S?
}
