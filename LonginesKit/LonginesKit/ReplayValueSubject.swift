//
//  ReplayValueSubject.swift
//  LonginesKit
//
//  Created by liam on 16/7/24.
//

import Foundation
import Combine

public class ReplayValueSubject<T> {
    private var buffer: [T]
    private let subject: CurrentValueSubject<[T], Never>
    private var cancellables = Set<AnyCancellable>()
    private let bufferSize: Int
    
    public init(bufferSize: Int) {
        self.bufferSize = bufferSize
        self.buffer = []
        self.subject = CurrentValueSubject<[T], Never>([])
    }
    
    public func send(_ value: T) {
        buffer.append(value)
        if buffer.count > bufferSize {
            buffer.removeFirst()
        }
        subject.send(buffer)
    }
    
    public func sink(receiveValue: @escaping (T) -> Void) -> AnyCancellable {
        return subject.sink(receiveValue: { values in
            guard !values.isEmpty else { return }
            values.forEach { value in
                receiveValue(value)
            }
        })
    }
}
