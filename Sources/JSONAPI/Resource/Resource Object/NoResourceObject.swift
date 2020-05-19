/// Something that is OptionalJSONTyped provides an Optional<String> representation
/// of its type.
public protocol OptionalJSONTyped {
    static var jsonType: String? { get }
}

public struct NoResourceIdDescription: RawIdType {}

public struct NoResourceId: Equatable, IdType {
    public typealias RawType = NoResourceIdDescription
    public var rawValue: NoResourceIdDescription
    
    public init(rawValue: NoResourceIdDescription) {
        self.rawValue = rawValue
    }

    public static let unidentified: Self = .init(rawValue: NoResourceIdDescription())
}

public protocol NoResourceObjectProxyDescription: OptionalJSONTyped {
    associatedtype Attributes: Equatable
    associatedtype Relationships: Equatable
}

/// A `NoResourceObjectDescription` describes a JSON API
/// NoResource Object. The NoResource Object
/// itself is encoded and decoded as an
/// `NoResourceObject`, which gets specialized on an
/// `NoResourceObjectDescription`.
public protocol NoResourceObjectDescription: NoResourceObjectProxyDescription where Attributes: JSONAPI.Attributes, Relationships: JSONAPI.Relationships {}

/// NoResourceObjectProxy is a protocol that can be used to create
/// types that _act_ like NoResourceObject but cannot be encoded
/// or decoded as NoResourceObjects.
@dynamicMemberLookup
public protocol NoResourceObjectProxy: Equatable, OptionalJSONTyped {
    associatedtype Description: NoResourceObjectProxyDescription
    associatedtype EntityRawIdType: JSONAPI.MaybeRawId
    
    /// The `Entity`'s Id. This can be of type `Unidentified` if
    /// the entity is being created clientside and the
    /// server is being asked to create a unique Id. Otherwise,
    /// this should be of a type conforming to `OptionalTypedId`.
    typealias Id = NoResourceId
    
    /// The JSON API compliant attributes of this `Entity`.
    typealias Attributes = Description.Attributes
    
    /// The JSON API compliant relationships of this `Entity`.
    typealias Relationships = Description.Relationships
    
    var id: Id { get }
    /// The JSON API compliant attributes of this `Entity`.
    var attributes: Attributes { get }
    
    /// The JSON API compliant relationships of this `Entity`.
    var relationships: Relationships { get }
}

extension NoResourceObjectProxy {
    /// The JSON API compliant "type" of this `NoResourceObject`.
    public static var jsonType: String? { return Description.jsonType }
}

/// A marker protocol.
public protocol AbstractNoResourceObject {}

/// ResourceObjectType is the protocol that ResourceObject conforms to. This
/// protocol lets other types accept any ResourceObject as a generic
/// specialization.
public protocol NoResourceObjectType: AbstractNoResourceObject, NoResourceObjectProxy, CodablePrimaryResource where Description: NoResourceObjectDescription {
    associatedtype Meta: JSONAPI.Meta
    associatedtype Links: JSONAPI.Links
    
    /// Any additional metadata packaged with the entity.
    var meta: Meta { get }
    
    /// Links related to the entity.
    var links: Links { get }
}

public protocol IdentifiableNoResourceObjectType: NoResourceObjectType, NoResourceRelatable where EntityRawIdType: JSONAPI.RawIdType {}

public struct NoResourceObject<Description: JSONAPI.NoResourceObjectDescription, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, EntityRawIdType: JSONAPI.MaybeRawId>:
NoResourceObjectType {
    
    public typealias Meta = MetaType
    public typealias Links = LinksType
    
    public var id: NoResourceObject.Id = .unidentified
    
    public var attributes: Description.Attributes
    
    public var relationships: Description.Relationships
    
    public var meta: MetaType
    
    public var links: LinksType
    
    public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
        self.attributes = attributes
        self.relationships = relationships
        self.meta = meta
        self.links = links
    }
}

public protocol NoResourceIdentifiable: OptionalJSONTyped {
    associatedtype NoResourceIdentifier: Equatable
}

/// The Relatable protocol describes anything that
/// has an IdType Identifier
public protocol NoResourceRelatable: NoResourceIdentifiable where NoResourceIdentifier: JSONAPI.IdType {}

extension NoResourceObject: NoResourceIdentifiable, IdentifiableNoResourceObjectType, NoResourceRelatable where EntityRawIdType: JSONAPI.RawIdType {
    public typealias NoResourceIdentifier = NoResourceObject.Id
}

extension NoResourceObject: CustomStringConvertible {
    public var description: String {
        "NoResourceObject<\(NoResourceObject.jsonType ?? "")>attributes: \(String(describing: attributes)), relationships: \(String(describing: relationships)))"
    }
}

extension NoResourceObject where EntityRawIdType: CreatableRawIdType {
    public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
        self.id = NoResourceObject.Id.unidentified
        self.attributes = attributes
        self.relationships = relationships
        self.meta = meta
        self.links = links
    }
}

extension NoResourceObject where EntityRawIdType == Unidentified {
    public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
        self.attributes = attributes
        self.relationships = relationships
        self.meta = meta
        self.links = links
    }
}

// MARK: - Identifying Unidentified Entities
public extension NoResourceObject where EntityRawIdType == Unidentified {
    /// Create a new `ResourceObject` from this one with a newly created
    /// unique Id of the given type.
    func identified<RawIdType: CreatableRawIdType>(byType: RawIdType.Type) -> NoResourceObject<Description, MetaType, LinksType, RawIdType> {
        return .init(attributes: attributes, relationships: relationships, meta: meta, links: links)
    }
    
    /// Create a new `ResourceObject` from this one with the given Id.
    func identified<RawIdType: JSONAPI.RawIdType>(by id: RawIdType) -> NoResourceObject<Description, MetaType, LinksType, RawIdType> {
        return .init(attributes: attributes, relationships: relationships, meta: meta, links: links)
    }
}

// MARK: - Attribute Access
public extension NoResourceObjectProxy {
    // MARK: Keypath Subscript Lookup
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    @available(*, deprecated, message: "This will be removed in a future version in favor of `resource.<attribute_name>` (dynamic member lookup)")
    subscript<T: AttributeType>(_ path: KeyPath<Description.Attributes, T>) -> T.ValueType {
        return attributes[keyPath: path].value
    }
    
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    @available(*, deprecated, message: "This will be removed in a future version in favor of `resource.<attribute_name>` (dynamic member lookup)")
    subscript<T: AttributeType>(_ path: KeyPath<Description.Attributes, T?>) -> T.ValueType? {
        return attributes[keyPath: path]?.value
    }
    
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    @available(*, deprecated, message: "This will be removed in a future version in favor of `resource.<attribute_name>` (dynamic member lookup)")
    subscript<T: AttributeType, U>(_ path: KeyPath<Description.Attributes, T?>) -> U? where T.ValueType == U? {
        // Implementation Note: Handles Transform that returns optional
        // type.
        return attributes[keyPath: path].flatMap { $0.value }
    }
    
    // MARK: Dynaminc Member Keypath Lookup
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    subscript<T: AttributeType>(dynamicMember path: KeyPath<Description.Attributes, T>) -> T.ValueType {
        return attributes[keyPath: path].value
    }
    
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    subscript<T: AttributeType>(dynamicMember path: KeyPath<Description.Attributes, T?>) -> T.ValueType? {
        return attributes[keyPath: path]?.value
    }
    
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    subscript<T: AttributeType, U>(dynamicMember path: KeyPath<Description.Attributes, T?>) -> U? where T.ValueType == U? {
        return attributes[keyPath: path].flatMap { $0.value }
    }
    
    // MARK: Direct Keypath Subscript Lookup
    /// Access the storage of the attribute at the given keypath. This just
    /// allows you to write `resourceObject[direct: \.propertyName]` instead
    /// of `resourceObject.attributes.propertyName`.
    /// Most of the subscripts dig into an `AttributeType`. This subscript
    /// returns the `AttributeType` (or another type, if you are accessing
    /// an attribute that is not stored in an `AttributeType`).
    subscript<T>(direct path: KeyPath<Description.Attributes, T>) -> T {
        // Implementation Note: Handles attributes that are not
        // AttributeType. These should only exist as computed properties.
        return attributes[keyPath: path]
    }
}

// MARK: - Meta-Attribute Access
public extension NoResourceObjectProxy {
    // MARK: Keypath Subscript Lookup
    /// Access an attribute requiring a transformation on the RawValue _and_
    /// a secondary transformation on this entity (self).
    @available(*, deprecated, message: "This will be removed in a future version in favor of `resource.<attribute_name>` (dynamic member lookup)")
    subscript<T>(_ path: KeyPath<Description.Attributes, (Self) -> T>) -> T {
        return attributes[keyPath: path](self)
    }
    
    // MARK: Dynamic Member Keypath Lookup
    /// Access an attribute requiring a transformation on the RawValue _and_
    /// a secondary transformation on this entity (self).
    subscript<T>(dynamicMember path: KeyPath<Description.Attributes, (Self) -> T>) -> T {
        return attributes[keyPath: path](self)
    }
}

// MARK: - Relationship Access
public extension NoResourceObjectProxy {
    /// Access to an Id of a `ToOneRelationship`.
    /// This allows you to write `resourceObject ~> \.other` instead
    /// of `resourceObject.relationships.other.id`.
    static func ~><OtherEntity: Identifiable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>>) -> OtherEntity.Identifier {
        return entity.relationships[keyPath: path].id
    }
    
    /// Access to an Id of an optional `ToOneRelationship`.
    /// This allows you to write `resourceObject ~> \.other` instead
    /// of `resourceObject.relationships.other?.id`.
    static func ~><OtherEntity: OptionalRelatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>?>) -> OtherEntity.Identifier {
        // Implementation Note: This signature applies to `ToOneRelationship<E?, _, _>?`
        // whereas the one below applies to `ToOneRelationship<E, _, _>?`
        return entity.relationships[keyPath: path]?.id
    }
    
    /// Access to an Id of an optional `ToOneRelationship`.
    /// This allows you to write `resourceObject ~> \.other` instead
    /// of `resourceObject.relationships.other?.id`.
    static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>?>) -> OtherEntity.Identifier? {
        // Implementation Note: This signature applies to `ToOneRelationship<E, _, _>?`
        // whereas the one above applies to `ToOneRelationship<E?, _, _>?`
        return entity.relationships[keyPath: path]?.id
    }
    
    /// Access to all Ids of a `ToManyRelationship`.
    /// This allows you to write `resourceObject ~> \.others` instead
    /// of `resourceObject.relationships.others.ids`.
    static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity, MType, LType>>) -> [OtherEntity.Identifier] {
        return entity.relationships[keyPath: path].ids
    }
    
    /// Access to all Ids of an optional `ToManyRelationship`.
    /// This allows you to write `resourceObject ~> \.others` instead
    /// of `resourceObject.relationships.others?.ids`.
    static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity, MType, LType>?>) -> [OtherEntity.Identifier]? {
        return entity.relationships[keyPath: path]?.ids
    }
}

// MARK: - Meta-Relationship Access
public extension NoResourceObjectProxy {
    /// Access to an Id of a `ToOneRelationship`.
    /// This allows you to write `resourceObject ~> \.other` instead
    /// of `resourceObject.relationships.other.id`.
    static func ~><Identifier: IdType>(entity: Self, path: KeyPath<Description.Relationships, (Self) -> Identifier>) -> Identifier {
        return entity.relationships[keyPath: path](entity)
    }
    
    /// Access to all Ids of a `ToManyRelationship`.
    /// This allows you to write `resourceObject ~> \.others` instead
    /// of `resourceObject.relationships.others.ids`.
    static func ~><Identifier: IdType>(entity: Self, path: KeyPath<Description.Relationships, (Self) -> [Identifier]>) -> [Identifier] {
        return entity.relationships[keyPath: path](entity)
    }
}

infix operator ~>

// MARK: - Codable
private enum NoResourceObjectCodingKeys: String, CodingKey {
    case type = "type"
    case attributes = "attributes"
    case relationships = "relationships"
    case meta = "meta"
    case links = "links"
}

public extension NoResourceObject {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NoResourceObjectCodingKeys.self)
        
        try container.encode(NoResourceObject.jsonType, forKey: .type)
        
        if Description.Attributes.self != NoAttributes.self {
            let nestedEncoder = container.superEncoder(forKey: .attributes)
            try attributes.encode(to: nestedEncoder)
        }
        
        if Description.Relationships.self != NoRelationships.self {
            try container.encode(relationships, forKey: .relationships)
        }
        
        if MetaType.self != NoMetadata.self {
            try container.encode(meta, forKey: .meta)
        }
        
        if LinksType.self != NoLinks.self {
            try container.encode(links, forKey: .links)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoResourceObjectCodingKeys.self)
        
        let type: String? = try? container.decode(Optional<String>.self, forKey: .type)
       
        guard NoResourceObject.jsonType == type else {
            throw ResourceObjectDecodingError(
                expectedJSONAPIType: NoResourceObject.jsonType ?? "unexpected",
                found: type ?? "unexpected"
            )
        }
        
        do {
            attributes = try (NoAttributes() as? Description.Attributes)
                ?? container.decodeIfPresent(Description.Attributes.self, forKey: .attributes)
                ?? Description.Attributes(from: EmptyObjectDecoder())
        } catch let decodingError as DecodingError {
            throw ResourceObjectDecodingError(decodingError)
                ?? decodingError
        } catch _ as EmptyObjectDecodingError {
            throw ResourceObjectDecodingError(
                subjectName: ResourceObjectDecodingError.entireObject,
                cause: .keyNotFound,
                location: .attributes
            )
        }
        
        do {
            relationships = try (NoRelationships() as? Description.Relationships)
                ?? container.decodeIfPresent(Description.Relationships.self, forKey: .relationships)
                ?? Description.Relationships(from: EmptyObjectDecoder())
        } catch let decodingError as DecodingError {
            throw ResourceObjectDecodingError(decodingError)
                ?? decodingError
        } catch let decodingError as JSONAPICodingError {
            throw ResourceObjectDecodingError(decodingError)
                ?? decodingError
        } catch _ as EmptyObjectDecodingError {
            throw ResourceObjectDecodingError(
                subjectName: ResourceObjectDecodingError.entireObject,
                cause: .keyNotFound,
                location: .relationships
            )
        }
        
        meta = try (NoMetadata() as? MetaType) ?? container.decode(MetaType.self, forKey: .meta)
        
        links = try (NoLinks() as? LinksType) ?? container.decode(LinksType.self, forKey: .links)
    }
}
