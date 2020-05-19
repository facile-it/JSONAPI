/// An ResourceObject ID. These IDs can be encoded to or decoded from
/// JSON API IDs.
public struct OptionalTypedId<RawType: MaybeRawId>: Equatable, OptionalId {

    public let rawValue: RawType

    public init(rawValue: RawType) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawType.self)
        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension OptionalTypedId: Hashable, CustomStringConvertible, AbstractId, IdType where RawType: RawIdType {
    public static func id(from rawValue: RawType) -> OptionalTypedId<RawType> {
        return OptionalTypedId(rawValue: rawValue)
    }
}

extension OptionalTypedId: CreatableIdType where RawType: CreatableRawIdType {
    public init() {
        rawValue = .unique()
    }
}

extension OptionalTypedId where RawType == Unidentified {
    public static var unidentified: OptionalTypedId { return .init(rawValue: Unidentified()) }
}
