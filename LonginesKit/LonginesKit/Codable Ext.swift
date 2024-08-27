//
//  Codable Ext.swift
//  LonginesKit
//
//  Created by liam on 27/8/24.
//

import Foundation

public extension Encodable {
    /// Convert a model to JSON.
    func encodeJSON(_ format: JSONEncoder.OutputFormatting? = nil, dateEncoding: JSONEncoder.DateEncodingStrategy? = nil, dataEncoding: JSONEncoder.DataEncodingStrategy = .base64) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = dataEncoding
        encoder.dateEncodingStrategy = dateEncoding ?? .secondsSince1970

        // Output format
        if let format = format {
            encoder.outputFormatting = format
        }
        return try encoder.encode(self)
    }
}

public extension Decodable {
    /// Map JSON to model.
    static func decodeJSON(_ json: Data?, dateDecoding: JSONDecoder.DateDecodingStrategy? = nil, dataDecoding: JSONDecoder.DataDecodingStrategy = .base64) throws -> Self {
        guard let json = json else {
            let error = NSError(domain: LonginesKit.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Input data must not be nil."])
            throw error
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = dataDecoding
        decoder.dateDecodingStrategy = dateDecoding ?? .secondsSince1970

        return try decoder.decode(self, from: json)
    }
}
