public protocol NoResourceRelationshipType {
    associatedtype LinksType
    associatedtype MetaType
    
    var links: LinksType { get }
    var meta: MetaType { get }
}

/// An NoResourceObject relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `One<ResourceObjectDescription>`

public struct ToOneRelationshipNoResource<NoResourceIdentifiable: JSONAPI.NoResourceIdentifiable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: NoResourceRelationshipType, Equatable {
    
    public let id: NoResourceIdentifiable.Identifier
    
    public let meta: MetaType
    public let links: LinksType
    
    public init(id: NoResourceIdentifiable.Identifier, meta: MetaType, links: LinksType) {
        self.id = id
        self.meta = meta
        self.links = links
    }
}

extension ToOneRelationshipNoResource where MetaType == NoMetadata, LinksType == NoLinks {
    public init(id: NoResourceIdentifiable.Identifier) {
        self.init(id: id, meta: .none, links: .none)
    }
}

extension ToOneRelationshipNoResource {
    public init<T: NoResourceObjectType>(resourceObject: T, meta: MetaType, links: LinksType) where T.Id == NoResourceIdentifiable.Identifier {
        self.init(id: resourceObject.id, meta: meta, links: links)
    }
}

extension ToOneRelationshipNoResource where MetaType == NoMetadata, LinksType == NoLinks {
    public init<T: NoResourceObjectType>(resourceObject: T) where T.Id == NoResourceIdentifiable.Identifier {
        self.init(id: resourceObject.id, meta: .none, links: .none)
    }
}

extension ToOneRelationshipNoResource where NoResourceIdentifiable: NoResourceOptionalRelatable {
    public init<T: NoResourceObjectType>(resourceObject: T?, meta: MetaType, links: LinksType) where T.Id == NoResourceIdentifiable.Wrapped.Identifier {
        self.init(id: resourceObject?.id, meta: meta, links: links)
    }
}

extension ToOneRelationshipNoResource where NoResourceIdentifiable: NoResourceOptionalRelatable, MetaType == NoMetadata, LinksType == NoLinks {
    public init<T: NoResourceObjectType>(resourceObject: T?) where T.Id == NoResourceIdentifiable.Wrapped.Identifier {
        self.init(id: resourceObject?.id, meta: .none, links: .none)
    }
}

/// An ResourceObject relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `Many<ResourceObjectDescription>`
public struct ToManyRelationshipNoResource<NoResourceRelatable: JSONAPI.NoResourceRelatable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: NoResourceRelationshipType, Equatable {
    
    public let ids: [NoResourceRelatable.Identifier]
    
    public let meta: MetaType
    public let links: LinksType
    
    public init(ids: [NoResourceRelatable.Identifier], meta: MetaType, links: LinksType) {
        self.ids = ids
        self.meta = meta
        self.links = links
    }
    
    public init<T: JSONAPI.NoResourceIdentifiable>(pointers: [ToOneRelationshipNoResource<T, NoMetadata, NoLinks>], meta: MetaType, links: LinksType) where T.Identifier == NoResourceRelatable.Identifier {
        ids = pointers.map { $0.id }
        self.meta = meta
        self.links = links
    }
    
    public init<T: NoResourceObjectType>(resourceObjects: [T], meta: MetaType, links: LinksType) where T.Id == NoResourceRelatable.Identifier {
        self.init(ids: resourceObjects.map { $0.id }, meta: meta, links: links)
    }
    
    private init(meta: MetaType, links: LinksType) {
        self.init(ids: [], meta: meta, links: links)
    }
    
    public static func none(withMeta meta: MetaType, links: LinksType) -> ToManyRelationshipNoResource {
        return ToManyRelationshipNoResource(meta: meta, links: links)
    }
}

extension ToManyRelationshipNoResource where MetaType == NoMetadata, LinksType == NoLinks {
    
    public init(ids: [NoResourceRelatable.Identifier]) {
        self.init(ids: ids, meta: .none, links: .none)
    }
    
    public init<T: JSONAPI.NoResourceIdentifiable>(pointers: [ToOneRelationshipNoResource<T, NoMetadata, NoLinks>]) where T.Identifier == NoResourceRelatable.Identifier {
        self.init(pointers: pointers, meta: .none, links: .none)
    }
    
    public static var none: ToManyRelationshipNoResource {
        return .none(withMeta: .none, links: .none)
    }
    
    public init<T: NoResourceObjectType>(resourceObjects: [T]) where T.Id == NoResourceRelatable.Identifier {
        self.init(resourceObjects: resourceObjects, meta: .none, links: .none)
    }
}

public protocol NoResourceIdentifiable: OptionalJSONTyped {
    associatedtype Identifier: Equatable
}

/// The Relatable protocol describes anything that
/// has an IdType Identifier
public protocol NoResourceRelatable: NoResourceIdentifiable where Identifier: JSONAPI.IdType {}

/// OptionalRelatable just describes an Optional
/// with a Reltable Wrapped type.
public protocol NoResourceOptionalRelatable: Identifiable where Identifier == Wrapped.Identifier? {
    associatedtype Wrapped: JSONAPI.NoResourceRelatable
}

//private extension Optional: NoResourceIdentifiable, NoResourceOptionalRelatable, OptionalJSONTyped where Wrapped: JSONAPI.NoResourceRelatable {
//
//    public typealias Identifier = Wrapped.Identifier?
//
//    public static var jsonType: String? { Wrapped.jsonType }
//}

// MARK: Codable
private enum NoResourceLinkageCodingKeys: String, CodingKey {
    case data = "data"
    case meta = "meta"
    case links = "links"
}
private enum NoResourceIdentifierCodingKeys: String, CodingKey {
    case id = "id"
    case entityType = "type"
}

extension ToOneRelationshipNoResource: Codable where NoResourceIdentifiable.Identifier: OptionalId {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoResourceLinkageCodingKeys.self)
        
        if let noMeta = NoMetadata() as? MetaType {
            meta = noMeta
        } else {
            meta = try container.decode(MetaType.self, forKey: .meta)
        }
        
        if let noLinks = NoLinks() as? LinksType {
            links = noLinks
        } else {
            links = try container.decode(LinksType.self, forKey: .links)
        }
        
        // A little trickery follows. If the id is nil, the
        // container.decode(Identifier.self) will fail even if Identifier
        // is Optional. However, we can check if decoding nil
        // succeeds and then attempt to coerce nil to a Identifier
        // type at which point we can store nil in `id`.
        let anyNil: Any? = nil
        if try container.decodeNil(forKey: .data) {
            guard let val = anyNil as? NoResourceIdentifiable.Identifier else {
                throw DecodingError.valueNotFound(
                    Self.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected non-null relationship data."
                    )
                )
            }
            id = val
            return
        }
        
        let identifier: KeyedDecodingContainer<NoResourceIdentifierCodingKeys>
        do {
            identifier = try container.nestedContainer(keyedBy: NoResourceIdentifierCodingKeys.self, forKey: .data)
        } catch let error as DecodingError {
            guard case let .typeMismatch(type, context) = error, type is _DictionaryType.Type else {
                throw error
            }
            throw JSONAPICodingError.quantityMismatch(expected: .one, path: context.codingPath)
        }
        
        let type = try identifier.decode(String.self, forKey: .entityType)
        
        guard type == NoResourceIdentifiable.jsonType else {
            throw JSONAPICodingError.typeMismatch(expected: NoResourceIdentifiable.jsonType ?? "", found: type, path: decoder.codingPath)
        }
        
        id = NoResourceIdentifiable.Identifier(
            rawValue: try identifier.decode(NoResourceIdentifiable.Identifier.RawType.self, forKey: .id))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NoResourceLinkageCodingKeys.self)
        
        if MetaType.self != NoMetadata.self {
            try container.encode(meta, forKey: .meta)
        }
        
        if LinksType.self != NoLinks.self {
            try container.encode(links, forKey: .links)
        }
        
        // If id is nil, instead of {id: , type: } we will just
        // encode `null`
        let anyNil: Any? = nil
        let nilId = anyNil as? NoResourceIdentifiable.Identifier
        guard id != nilId else {
            try container.encodeNil(forKey: .data)
            return
        }
        
        var identifier = container.nestedContainer(keyedBy: NoResourceIdentifierCodingKeys.self, forKey: .data)
        
        try identifier.encode(id, forKey: .id)
        try identifier.encode(NoResourceIdentifiable.jsonType, forKey: .entityType)
    }
    
}

extension ToManyRelationshipNoResource: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoResourceLinkageCodingKeys.self)
        
        if let noMeta = NoMetadata() as? MetaType {
            meta = noMeta
        } else {
            meta = try container.decode(MetaType.self, forKey: .meta)
        }
        
        if let noLinks = NoLinks() as? LinksType {
            links = noLinks
        } else {
            links = try container.decode(LinksType.self, forKey: .links)
        }
        
        var identifiers: UnkeyedDecodingContainer
        do {
            identifiers = try container.nestedUnkeyedContainer(forKey: .data)
        } catch let error as DecodingError {
            guard case let .typeMismatch(type, context) = error,
                type is _ArrayType.Type else {
                    throw error
            }
            throw JSONAPICodingError.quantityMismatch(expected: .many,
                                                      path: context.codingPath)
        }
        
        var newIds = [NoResourceRelatable.Identifier]()
        while !identifiers.isAtEnd {
            let identifier = try identifiers.nestedContainer(keyedBy: NoResourceIdentifierCodingKeys.self)
            
            let type = try identifier.decode(String.self, forKey: .entityType)
            
            guard type == NoResourceRelatable.jsonType else {
                throw JSONAPICodingError.typeMismatch(expected: NoResourceRelatable.jsonType ?? "", found: type, path: decoder.codingPath)
            }
            
            newIds.append(NoResourceRelatable.Identifier(rawValue: try identifier.decode(NoResourceRelatable.Identifier.RawType.self, forKey: .id)))
        }
        ids = newIds
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NoResourceLinkageCodingKeys.self)
        
        if MetaType.self != NoMetadata.self {
            try container.encode(meta, forKey: .meta)
        }
        
        if LinksType.self != NoLinks.self {
            try container.encode(links, forKey: .links)
        }
        
        var identifiers = container.nestedUnkeyedContainer(forKey: .data)
        
        for id in ids {
            var identifier = identifiers.nestedContainer(keyedBy: NoResourceIdentifierCodingKeys.self)
            
            try identifier.encode(id.rawValue, forKey: .id)
            try identifier.encode(NoResourceRelatable.jsonType, forKey: .entityType)
        }
    }
}

// MARK: CustomStringDescribable
extension ToOneRelationshipNoResource: CustomStringConvertible {
    public var description: String { return "Relationship(\(String(describing: id)))" }
}

extension ToManyRelationshipNoResource: CustomStringConvertible {
    public var description: String { return "Relationship([\(ids.map(String.init(describing:)).joined(separator: ", "))])" }
}

private protocol _DictionaryType {}
extension Dictionary: _DictionaryType {}

private protocol _ArrayType {}
extension Array: _ArrayType {}
