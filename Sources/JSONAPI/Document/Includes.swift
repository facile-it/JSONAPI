//
//  Includes.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

import Poly

public typealias Include = EncodableJSONPoly

/// A structure holding zero or more included Resource Objects.
/// The resources are accessed by their type using a subscript.
///
/// If you have
///
///     let includes: Includes<Include2<Thing1, Thing2>> = ...
///
/// then you can access all `Thing1` included resources with
///
///     let includedThings = includes[Thing1.self]
public struct Includes<I: Include>: Encodable, Equatable {
    public static var none: Includes { return .init(values: []) }

    public let values: [I]

    public init(values: [I]) {
        self.values = values
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        guard I.self != NoIncludes.self else {
            throw JSONAPICodingError.illegalEncoding("Attempting to encode Include0, which should be represented by the absense of an 'included' entry altogether.", path: encoder.codingPath)
        }

        for value in values {
            try container.encode(value)
        }
    }

    public var count: Int {
        return values.count
    }
}

extension Includes: Decodable where I: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        // If not parsing includes, no need to loop over them.
        guard I.self != NoIncludes.self else {
            values = []
            return
        }

        var valueAggregator = [I]()
        var idx = 0
        while !container.isAtEnd {
            do {
                valueAggregator.append(try container.decode(I.self))
                idx = idx + 1
            } catch let error as PolyDecodeNoTypesMatchedError {
                let errors: [ResourceObjectDecodingError] = error
                    .individualTypeFailures
                    .compactMap { decodingError in
                        switch decodingError.error {
                        case .typeMismatch(_, let context),
                             .valueNotFound(_, let context),
                             .keyNotFound(_, let context),
                             .dataCorrupted(let context):
                            return context.underlyingError as? ResourceObjectDecodingError
                        @unknown default:
                            return nil
                        }
                }
                guard errors.count == error.individualTypeFailures.count else {
                    throw IncludesDecodingError(error: error, idx: idx)
                }
                throw IncludesDecodingError(
                    error: IncludeDecodingError(failures: errors),
                    idx: idx
                )
            } catch let error {
                throw IncludesDecodingError(error: error, idx: idx)
            }
        }

        values = valueAggregator
    }
}

extension Includes {
    public func appending(_ other: Includes<I>) -> Includes {
        return Includes(values: values + other.values)
    }
}

public func +<I: Include>(_ left: Includes<I>, _ right: Includes<I>) -> Includes<I> {
    return left.appending(right)
}

extension Includes: CustomStringConvertible {
    public var description: String {
        return "Includes(\(String(describing: values))"
    }
}

extension Includes where I == NoIncludes {
    public init() {
        values = []
    }
}

// MARK: - 0 includes
public typealias Include0 = Poly0
public typealias NoIncludes = Include0

// MARK: - 1 include
public typealias Include1 = Poly1
extension Includes where I: _Poly1 {
    public subscript(_ lookup: I.A.Type) -> [I.A] {
        return values.compactMap { $0.a }
    }
}

// MARK: - 2 includes
public typealias Include2 = Poly2
extension Includes where I: _Poly2 {
    public subscript(_ lookup: I.B.Type) -> [I.B] {
        return values.compactMap { $0.b }
    }
}

// MARK: - 3 includes
public typealias Include3 = Poly3
extension Includes where I: _Poly3 {
    public subscript(_ lookup: I.C.Type) -> [I.C] {
        return values.compactMap { $0.c }
    }
}

// MARK: - 4 includes
public typealias Include4 = Poly4
extension Includes where I: _Poly4 {
    public subscript(_ lookup: I.D.Type) -> [I.D] {
        return values.compactMap { $0.d }
    }
}

// MARK: - 5 includes
public typealias Include5 = Poly5
extension Includes where I: _Poly5 {
    public subscript(_ lookup: I.E.Type) -> [I.E] {
        return values.compactMap { $0.e }
    }
}

// MARK: - 6 includes
public typealias Include6 = Poly6
extension Includes where I: _Poly6 {
    public subscript(_ lookup: I.F.Type) -> [I.F] {
        return values.compactMap { $0.f }
    }
}

// MARK: - 7 includes
public typealias Include7 = Poly7
extension Includes where I: _Poly7 {
    public subscript(_ lookup: I.G.Type) -> [I.G] {
        return values.compactMap { $0.g }
    }
}

// MARK: - 8 includes
public typealias Include8 = Poly8
extension Includes where I: _Poly8 {
    public subscript(_ lookup: I.H.Type) -> [I.H] {
        return values.compactMap { $0.h }
    }
}

// MARK: - 9 includes
public typealias Include9 = Poly9
extension Includes where I: _Poly9 {
    public subscript(_ lookup: I.I.Type) -> [I.I] {
        return values.compactMap { $0.i }
    }
}

// MARK: - 10 includes
public typealias Include10 = Poly10
extension Includes where I: _Poly10 {
    public subscript(_ lookup: I.J.Type) -> [I.J] {
        return values.compactMap { $0.j }
    }
}

// MARK: - 11 includes
public typealias Include11 = Poly11
extension Includes where I: _Poly11 {
    public subscript(_ lookup: I.K.Type) -> [I.K] {
        return values.compactMap { $0.k }
    }
}

// MARK: - 12 includes
public typealias Include12 = Poly12
extension Includes where I: _Poly12 {
    public subscript(_ lookup: I.L.Type) -> [I.L] {
        return values.compactMap { $0.l }
    }
}

// MARK: - 13 includes
public typealias Include13 = Poly13
extension Includes where I: _Poly13 {
    public subscript(_ lookup: I.M.Type) -> [I.M] {
        return values.compactMap { $0.m }
    }
}

// MARK: - 14 includes
public typealias Include14 = Poly14
extension Includes where I: _Poly14 {
    public subscript(_ lookup: I.N.Type) -> [I.N] {
        return values.compactMap { $0.n }
    }
}

// MARK: - DecodingError
public struct IncludesDecodingError: Swift.Error, Equatable {
    public let error: Swift.Error
    public let idx: Int

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.idx == rhs.idx
            && String(describing: lhs) == String(describing: rhs)
    }
}

extension IncludesDecodingError: CustomStringConvertible {
    public var description: String {
        return "Include \(idx + 1) failed to parse: \(error)"
    }
}

public struct IncludeDecodingError: Swift.Error, Equatable, CustomStringConvertible {
    public let failures: [ResourceObjectDecodingError]

    public var description: String {
        return failures
            .enumerated()
            .map {
                "\nCould not have been Include Type \($0.offset + 1) because:\n\($0.element)"
        }.joined(separator: "\n")
    }
}
