import XCTest
import JSONAPI
import JSONAPITesting

class NoResourceObjectTests: XCTestCase {
    
    func test_relationship_access() {
        
        let resourceObjectEntity1 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity2 = TestEntity2(attributes: .none, relationships: .init(other: resourceObjectEntity1.pointer), meta: .none, links: .none)
        
        XCTAssertEqual(entity2.relationships.other, resourceObjectEntity1.pointer)
    }
    
    func test_relationship_operator_access() {
        let resourceObjectEntity1 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity2 = TestEntity2(attributes: .none, relationships: .init(other: resourceObjectEntity1.pointer), meta: .none, links: .none)
        
        XCTAssertEqual(entity2 ~> \.other, resourceObjectEntity1.id)
    }
    
    func test_optional_relationship_operator_access() {
        let resourceObjectEntity1 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        
        let entity = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: .init(
                    resourceObject: resourceObjectEntity1,
                    meta: .none,
                    links: .none),
                optionalOne: .init(
                    resourceObject: resourceObjectEntity1,
                    meta: .none,
                    links: .none),
                optionalNullableOne: nil,
                optionalMany: .init(
                    resourceObjects: [resourceObjectEntity1, resourceObjectEntity1],
                    meta: .none,
                    links: .none)),
            meta: .none,
            links: .none)
        
        XCTAssertEqual(entity ~> \.optionalOne, Optional(resourceObjectEntity1.id))
        XCTAssertEqual((entity ~> \.optionalOne).rawValue, Optional(resourceObjectEntity1.id.rawValue))
    }
    
    func test_toMany_relationship_operator_access() {
        
        let resourceObjectEntity1 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let resourceObjectEntity2 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let resourceObjectEntity4 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity3 = TestEntity3(attributes: .none, relationships: .init(others: .init(pointers: [resourceObjectEntity1.pointer, resourceObjectEntity2.pointer, resourceObjectEntity4.pointer])), meta: .none, links: .none)
        
        XCTAssertEqual(entity3 ~> \.others, [resourceObjectEntity1.id, resourceObjectEntity2.id, resourceObjectEntity4.id])
    }
    
    func test_optionalToMany_relationship_opeartor_access() {
        let entity1 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity = TestEntity9(attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: nil, optionalNullableOne: nil, optionalMany: .init(resourceObjects: [entity1, entity1], meta: .none, links: .none)), meta: .none, links: .none)
        
        XCTAssertEqual(entity ~> \.optionalMany, [entity1.id, entity1.id])
    }
    
    func test_relationshipIds() {
        
        let resourceObjectEntity1 = ResourceObject.TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity2 = TestEntity2(attributes: .none, relationships: .init(other: resourceObjectEntity1.pointer), meta: .none, links: .none)
        
        XCTAssertEqual(entity2.relationships.other.id, resourceObjectEntity1.id)
    }
    
    func test_unidentifiedEntityAttributeAccess() {
        let entity = UnidentifiedTestEntity(attributes: .init(me: "hello"), relationships: .none, meta: .none, links: .none)
        
        XCTAssertEqual(entity.me, "hello")
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_unidentifiedEntityAttributeAccess_deprecated() {
        let entity = UnidentifiedTestEntity(attributes: .init(me: "hello"), relationships: .none, meta: .none, links: .none)
        
        XCTAssertEqual(entity[\.me], "hello")
    }
    
    func test_initialization() {
        
        let resourceObjectEntity1 = ResourceObject.TestEntity1(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none)
        
        let resourceObjectEntity2 = ResourceObject.TestEntity2(
            id: .init(rawValue: "cool"),
            attributes: .none,
            relationships: .init(
                other: .init(resourceObject: resourceObjectEntity1)),
            meta: .none,
            links: .none)
        
        let _ = TestEntity2(
            attributes: .none,
            relationships: .init(
                other: .init(
                    resourceObject: resourceObjectEntity1)),
            meta: .none,
            links: .none)
        
        let _ = TestEntity2(
            attributes: .none,
            relationships: .init(
                other: .init(
                    resourceObject: resourceObjectEntity1)),
            meta: .none,
            links: .none)
        
        let _ = TestEntity3(
            attributes: .none,
            relationships: .init(
                others: .init(
                    ids: [.init(rawValue: "10"), .init(rawValue: "20"), resourceObjectEntity1.id])),
            meta: .none,
            links: .none)
        
        let _ = TestEntity3(
            attributes: .none,
            relationships: .init(others: .none),
            meta: .none,
            links: .none)
        
        let _ = TestEntity4(
            attributes: .init(
                word: .init(value: "hello"),
                number: .init(value: 10),
                array: .init(value: [10.2, 10.3])),
            relationships: .init(other: resourceObjectEntity2.pointer),
            meta: .none,
            links: .none)
        
        let _ = TestEntity5(
            attributes: .init(floater: .init(value: 10.2)),
            relationships: .none,
            meta: .none,
            links: .none)
        
        let _ = TestEntity6(
            attributes: .init(
                here: .init(value: "here"),
                maybeHere: nil,
                maybeNull: .init(value: nil)),
            relationships: .none,
            meta: .none,
            links: .none)
        
        let _ = TestEntity7(
            attributes: .init(
                here: .init(value: "hello"),
                maybeHereMaybeNull: .init(value: "world")),
            relationships: .none,
            meta: .none,
            links: .none)
        
        XCTAssertNoThrow(try TestEntity8(
            attributes: .init(
                string: .init(value: "hello"),
                int: .init(value: 10),
                stringFromInt: .init(rawValue: 20),
                plus: .init(rawValue: 30),
                doubleFromInt: .init(rawValue: 32),
                omitted: nil,
                nullToString: .init(rawValue: nil)),
            relationships: .none,
            meta: .none,
            links: .none))
        
        let _ = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: .init(id: nil),
                optionalOne: nil,
                optionalNullableOne: nil,
                optionalMany: nil),
            meta: .none,
            links: .none)
        
        let _ = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: .init(id:nil),
                optionalOne: nil,
                optionalNullableOne: nil,
                optionalMany: nil),
            meta: .none,
            links: .none)
        
        let _ = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: .init(resourceObject: resourceObjectEntity1, meta: .none, links: .none),
                optionalOne: nil,
                optionalNullableOne: nil,
                optionalMany: nil),
            meta: .none,
            links: .none)
        
        let _ = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: nil,
                optionalOne: resourceObjectEntity1.pointer,
                optionalNullableOne: nil,
                optionalMany: nil),
            meta: .none,
            links: .none)
        
        let _ = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: nil,
                optionalOne: nil,
                optionalNullableOne: .init(
                    resourceObject: resourceObjectEntity1,
                    meta: .none,
                    links: .none),
                optionalMany: nil),
            meta: .none,
            links: .none)
        
        let _ = TestEntity9(
            attributes: .none,
            relationships: .init(
                one: resourceObjectEntity1.pointer,
                nullableOne: nil,
                optionalOne: nil,
                optionalNullableOne: .init(
                    resourceObject: resourceObjectEntity1,
                    meta: .none,
                    links: .none),
                optionalMany: .init(
                    resourceObjects: [],
                    meta: .none,
                    links: .none)),
            meta: .none,
            links: .none)
        
        let e10id1 = ResourceObject.TestEntity10.Identifier(rawValue: "hello")
        let e10id2 = ResourceObject.TestEntity10.Id(rawValue: "world")
        let e10id3 = ResourceObject.TestEntity10.Id(rawValue: "!")
        
        let _ = TestEntity10(
            attributes: .none,
            relationships: .init(
                selfRef: .init(id: e10id1),
                selfRefs: .init(ids: [e10id2, e10id3])),
            meta: .none,
            links: .none)
        
        XCTAssertNoThrow(try TestEntity11(
            attributes: .init(number: .init(rawValue: 11)),
            relationships: .none,
            meta: .none,
            links: .none))
        
        let _ = UnidentifiedTestEntity(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .none)
        
        let _ = UnidentifiedTestEntityWithMeta(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .init(x: "world", y: nil), links: .none)
        
        let _ = UnidentifiedTestEntityWithLinks(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .init(link1: .init(url: "hmmm")))
    }
    
}

// MARK: - Identifying entity copies
extension NoResourceObjectTests {
    func test_copyIdentifiedByType() {
        let unidentifiedEntity = UnidentifiedTestEntity(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .none)
        
        let identifiedCopy = unidentifiedEntity.identified(byType: String.self)
        
        XCTAssertEqual(unidentifiedEntity.attributes, identifiedCopy.attributes)
        XCTAssertEqual(unidentifiedEntity.relationships, identifiedCopy.relationships)
    }
    
    func test_copyIdentifiedByValue() {
        let unidentifiedEntity = UnidentifiedTestEntity(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .none)
        
        let identifiedCopy = unidentifiedEntity.identified(by: "hello")
        
        XCTAssertEqual(unidentifiedEntity.attributes, identifiedCopy.attributes)
        XCTAssertEqual(unidentifiedEntity.relationships, identifiedCopy.relationships)
        XCTAssertEqual(identifiedCopy.id, NoResourceId.unidentified)
    }
    
}

// MARK: - Encode/Decode
extension NoResourceObjectTests {
    
    func test_EntityNoRelationshipsNoAttributes() {
        let entity = decoded(type: TestEntity1.self,
                             data: entity_no_resource_no_relationships_no_attributes)
        
        XCTAssert(type(of: entity.relationships) == NoRelationships.self)
        XCTAssert(type(of: entity.attributes) == NoAttributes.self)
        XCTAssertNoThrow(try TestEntity1.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_EntityNoRelationshipsNoAttributes_encode() {
        test_DecodeEncodeEquality(type: TestEntity1.self,
                                  data: entity_no_resource_no_relationships_no_attributes)
    }
    
    func test_EntityNoRelationshipsSomeAttributes() {
        let entity = decoded(type: TestEntity5.self,
                             data: entity_no_resource_no_relationships_some_attributes)
        
        XCTAssert(type(of: entity.relationships) == NoRelationships.self)
        
        XCTAssertEqual(entity.floater, 123.321)
        XCTAssertNoThrow(try TestEntity5.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_EntityNoRelationshipsSomeAttributes_deprecated() {
        let entity = decoded(type: TestEntity5.self,
                             data: entity_no_resource_no_relationships_some_attributes)
        XCTAssertEqual(entity[\.floater], 123.321)
    }
    
    func test_EntityNoRelationshipsSomeAttributes_encode() {
        test_DecodeEncodeEquality(type: TestEntity5.self,
                                  data: entity_no_resource_no_relationships_some_attributes)
    }
    
    func test_EntitySomeRelationshipsNoAttributes() {
        let entity = decoded(type: TestEntity3.self,
                             data: entity_no_resource_some_relationships_no_attributes)
        
        XCTAssert(type(of: entity.attributes) == NoAttributes.self)
        
        XCTAssertEqual((entity ~> \.others).map { $0.rawValue }, ["364B3B69-4DF1-467F-B52E-B0C9E44F666E"])
        XCTAssertNoThrow(try TestEntity3.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_EntitySomeRelationshipsNoAttributes_encode() {
        test_DecodeEncodeEquality(type: TestEntity3.self,
                                  data: entity_no_resource_some_relationships_no_attributes)
    }
    
    func test_EntitySomeRelationshipsSomeAttributes() {
        let entity = decoded(type: TestEntity4.self,
                             data: entity_no_resource_some_relationships_some_attributes)
        
        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
        XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
        XCTAssertNoThrow(try TestEntity4.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_EntitySomeRelationshipsSomeAttributes_deprecated() {
        let entity = decoded(type: TestEntity4.self,
                             data: entity_no_resource_some_relationships_some_attributes)
        
        XCTAssertEqual(entity[\.word], "coolio")
        XCTAssertEqual(entity[\.number], 992299)
    }
    
    func test_EntitySomeRelationshipsSomeAttributes_encode() {
        test_DecodeEncodeEquality(type: TestEntity4.self,
                                  data: entity_no_resource_some_relationships_some_attributes)
    }
}

// MARK: Attribute omission and nullification
extension NoResourceObjectTests {
    
    func test_entityOneOmittedAttribute() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_one_omitted_attribute)
        
        XCTAssertEqual(entity.here, "Hello")
        XCTAssertNil(entity.maybeHere)
        XCTAssertEqual(entity.maybeNull, "World")
        XCTAssertNoThrow(try TestEntity6.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_entityOneOmittedAttribute_deprecated() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_one_omitted_attribute)
        
        XCTAssertEqual(entity[\.here], "Hello")
        XCTAssertNil(entity[\.maybeHere])
        XCTAssertEqual(entity[\.maybeNull], "World")
    }
    
    func test_entityOneOmittedAttribute_encode() {
        test_DecodeEncodeEquality(type: TestEntity6.self,
                                  data: entity_no_resource_one_omitted_attribute)
    }
    
    func test_entityOneNullAttribute() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_one_null_attribute)
        
        XCTAssertEqual(entity.here, "Hello")
        XCTAssertEqual(entity.maybeHere, "World")
        XCTAssertNil(entity.maybeNull)
        XCTAssertNoThrow(try TestEntity6.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_entityOneNullAttribute_deprecated() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_one_null_attribute)
        
        XCTAssertEqual(entity[\.here], "Hello")
        XCTAssertEqual(entity[\.maybeHere], "World")
        XCTAssertNil(entity[\.maybeNull])
    }
    
    func test_entityOneNullAttribute_encode() {
        test_DecodeEncodeEquality(type: TestEntity6.self,
                                  data: entity_no_resource_one_null_attribute)
    }
    
    func test_entityAllAttribute() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_all_attributes)
        
        XCTAssertEqual(entity.here, "Hello")
        XCTAssertEqual(entity.maybeHere, "World")
        XCTAssertEqual(entity.maybeNull, "!")
        XCTAssertNoThrow(try TestEntity6.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_entityAllAttribute_deprecated() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_all_attributes)
        
        XCTAssertEqual(entity[\.here], "Hello")
        XCTAssertEqual(entity[\.maybeHere], "World")
        XCTAssertEqual(entity[\.maybeNull], "!")
    }
    
    func test_entityAllAttribute_encode() {
        test_DecodeEncodeEquality(type: TestEntity6.self,
                                  data: entity_no_resource_all_attributes)
    }
    
    func test_entityOneNullAndOneOmittedAttribute() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_one_null_and_one_missing_attribute)
        
        XCTAssertEqual(entity.here, "Hello")
        XCTAssertNil(entity.maybeHere)
        XCTAssertNil(entity.maybeNull)
        XCTAssertNoThrow(try TestEntity6.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_entityOneNullAndOneOmittedAttribute_deprecated() {
        let entity = decoded(type: TestEntity6.self,
                             data: entity_no_resource_one_null_and_one_missing_attribute)
        
        XCTAssertEqual(entity[\.here], "Hello")
        XCTAssertNil(entity[\.maybeHere])
        XCTAssertNil(entity[\.maybeNull])
    }
    
    func test_entityOneNullAndOneOmittedAttribute_encode() {
        test_DecodeEncodeEquality(type: TestEntity6.self,
                                  data: entity_no_resource_one_null_and_one_missing_attribute)
    }
    
    func test_entityBrokenNullableOmittedAttribute() {
        XCTAssertThrowsError(try JSONDecoder().decode(TestEntity6.self,
                                                      from: entity_no_resource_broken_missing_nullable_attribute))
    }
    
    func test_NullOptionalNullableAttribute() {
        let entity = decoded(type: TestEntity7.self,
                             data: entity_no_resource_null_optional_nullable_attribute)
        
        XCTAssertEqual(entity.here, "Hello")
        XCTAssertNil(entity.maybeHereMaybeNull)
        XCTAssertNoThrow(try TestEntity7.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_NullOptionalNullableAttribute_deprecated() {
        let entity = decoded(type: TestEntity7.self,
                             data: entity_no_resource_null_optional_nullable_attribute)
        
        XCTAssertEqual(entity[\.here], "Hello")
        XCTAssertNil(entity[\.maybeHereMaybeNull])
    }
    
    func test_NullOptionalNullableAttribute_encode() {
        test_DecodeEncodeEquality(type: TestEntity7.self,
                                  data: entity_no_resource_null_optional_nullable_attribute)
    }
    
    func test_NonNullOptionalNullableAttribute() {
        let entity = decoded(type: TestEntity7.self,
                             data: entity_no_resource_non_null_optional_nullable_attribute)
        
        XCTAssertEqual(entity.here, "Hello")
        XCTAssertEqual(entity.maybeHereMaybeNull, "World")
        XCTAssertNoThrow(try TestEntity7.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_NonNullOptionalNullableAttribute_deprecated() {
        let entity = decoded(type: TestEntity7.self,
                             data: entity_no_resource_non_null_optional_nullable_attribute)
        
        XCTAssertEqual(entity[\.here], "Hello")
        XCTAssertEqual(entity[\.maybeHereMaybeNull], "World")
    }
    
    func test_NonNullOptionalNullableAttribute_encode() {
        test_DecodeEncodeEquality(type: TestEntity7.self,
                                  data: entity_no_resource_non_null_optional_nullable_attribute)
    }
}

// MARK: Attribute Transformation
extension NoResourceObjectTests {
    func test_IntToString() {
        let entity = decoded(type: TestEntity8.self,
                             data: entity_no_resource_int_to_string_attribute)
        
        XCTAssertEqual(entity.string, "22")
        XCTAssertEqual(entity.int, 22)
        XCTAssertEqual(entity.stringFromInt, "22")
        XCTAssertEqual(entity.plus, 122)
        XCTAssertEqual(entity.doubleFromInt, 22.0)
        XCTAssertEqual(entity.nullToString, "nil")
        XCTAssertNoThrow(try TestEntity8.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_IntToString_deprecated() {
        let entity = decoded(type: TestEntity8.self,
                             data: entity_no_resource_int_to_string_attribute)
        
        XCTAssertEqual(entity[\.string], "22")
        XCTAssertEqual(entity[\.int], 22)
        XCTAssertEqual(entity[\.stringFromInt], "22")
        XCTAssertEqual(entity[\.plus], 122)
        XCTAssertEqual(entity[\.doubleFromInt], 22.0)
        XCTAssertEqual(entity[\.nullToString], "nil")
    }
    
    func test_IntToString_encode() {
        test_DecodeEncodeEquality(type: TestEntity8.self,
                                  data: entity_no_resource_int_to_string_attribute)
    }
}

// MARK: Attribute Validation
extension NoResourceObjectTests {
    func test_IntOver10_success() {
        XCTAssertNoThrow(decoded(type: TestEntity11.self, data: entity_no_resource_valid_validated_attribute))
    }
    
    func test_IntOver10_encode() {
        test_DecodeEncodeEquality(type: TestEntity11.self, data: entity_no_resource_valid_validated_attribute)
    }
    
    func test_IntOver10_failure() {
        XCTAssertThrowsError(try JSONDecoder().decode(TestEntity11.self, from: entity_no_resource_invalid_validated_attribute))
    }
}

// MARK: Relationship omission and nullification
extension NoResourceObjectTests {
    func test_nullableRelationshipNotNullOrOmitted() {
        let entity = decoded(type: TestEntity9.self,
                             data: entity_no_resource_optional_not_omitted_relationship)
        
        XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
        XCTAssertEqual((entity ~> \.one).rawValue, "4459")
        XCTAssertNil(entity ~> \.optionalOne)
        XCTAssertEqual((entity ~> \.optionalNullableOne)?.rawValue, "1229")
        XCTAssertNoThrow(try TestEntity9.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_nullableRelationshipNotNullOrOmitted_encode() {
        test_DecodeEncodeEquality(type: TestEntity9.self,
                                  data: entity_no_resource_optional_not_omitted_relationship)
    }
    
    func test_nullableRelationshipNotNull() {
        let entity = decoded(type: TestEntity9.self,
                             data: entity_no_resource_omitted_relationship)
        
        XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
        XCTAssertEqual((entity ~> \.one).rawValue, "4459")
        XCTAssertNil(entity ~> \.optionalNullableOne)
        XCTAssertNoThrow(try TestEntity9.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_nullableRelationshipNotNull_encode() {
        test_DecodeEncodeEquality(type: TestEntity9.self,
                                  data: entity_no_resource_omitted_relationship)
    }
    
    func test_optionalNullableRelationshipNulled() {
        let entity = decoded(type: TestEntity9.self,
                             data: entity_no_resource_optional_nullable_nulled_relationship)
        
        XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
        XCTAssertEqual((entity ~> \.one).rawValue, "4459")
        XCTAssertNil(entity ~> \.optionalNullableOne)
        XCTAssertNil((entity ~> \.optionalNullableOne).rawValue)
        XCTAssertNoThrow(try TestEntity9.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_optionalNullableRelationshipNulled_encode() {
        test_DecodeEncodeEquality(type: TestEntity9.self,
                                  data: entity_no_resource_optional_nullable_nulled_relationship)
    }
    
    func test_optionalNullableRelationshipOmitted() {
        let entity = decoded(type: TestEntity15.self,
                             data: entity_no_resource_all_relationships_optional_and_omitted)
        
        XCTAssertNil(entity ~> \.optionalOne)
        XCTAssertNil(entity ~> \.optionalNullableOne)
        XCTAssertNil(entity ~> \.optionalMany)
        XCTAssertNoThrow(try TestEntity15.check(entity))
    }
    
    func test_nullableRelationshipIsNull() {
        let entity = decoded(type: TestEntity9.self,
                             data: entity_no_resource_nulled_relationship)
        
        XCTAssertNil(entity ~> \.nullableOne)
        XCTAssertEqual((entity ~> \.one).rawValue, "4452")
        XCTAssertNil(entity ~> \.optionalNullableOne)
        XCTAssertNoThrow(try TestEntity9.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_nullableRelationshipIsNull_encode() {
        test_DecodeEncodeEquality(type: TestEntity9.self,
                                  data: entity_no_resource_nulled_relationship)
    }
    
    func test_optionalToManyIsNotOmitted() {
        let entity = decoded(type: TestEntity9.self,
                             data: entity_no_resource_optional_to_many_relationship_not_omitted)
        
        XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
        XCTAssertEqual((entity ~> \.one).rawValue, "4459")
        XCTAssertEqual((entity ~> \.optionalMany)?[0].rawValue, "332223")
        XCTAssertNil(entity ~> \.optionalNullableOne)
        XCTAssertNoThrow(try TestEntity9.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_optionalToManyIsNotOmitted_encode() {
        test_DecodeEncodeEquality(type: TestEntity9.self,
                                  data: entity_no_resource_optional_to_many_relationship_not_omitted)
    }
}

// MARK: Relationships of same type as root entity
extension NoResourceObjectTests {
    func test_RleationshipsOfSameType() {
        let entity = decoded(type: TestEntity10.self,
                             data: entity_no_resource_self_ref_relationship)
        
        XCTAssertEqual((entity ~> \.selfRef).rawValue, "1")
        XCTAssertNoThrow(try TestEntity10.check(entity))
        
        testEncoded(entity: entity)
    }
    
    func test_RleationshipsOfSameType_encode() {
        test_DecodeEncodeEquality(type: TestEntity10.self,
                                  data: entity_no_resource_self_ref_relationship)
    }
}

// MARK: Unidentified
extension NoResourceObjectTests {
    func test_UnidentifiedEntity() {
        let entity = decoded(type: UnidentifiedTestEntity.self,
                             data: entity_no_resource_unidentified)
        
        XCTAssertNil(entity.me)
        XCTAssertEqual(entity.id, .unidentified)
        XCTAssertNoThrow(try UnidentifiedTestEntity.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_UnidentifiedEntity_deprecated() {
        let entity = decoded(type: UnidentifiedTestEntity.self,
                             data: entity_no_resource_unidentified)
        
        XCTAssertNil(entity[\.me])
    }
    
    func test_UnidentifiedEntity_encode() {
        test_DecodeEncodeEquality(type: UnidentifiedTestEntity.self,
                                  data: entity_no_resource_unidentified)
    }
    
    func test_UnidentifiedEntityWithAttributes() {
        let entity = decoded(type: UnidentifiedTestEntity.self,
                             data: entity_no_resource_unidentified_with_attributes)
        
        XCTAssertEqual(entity.me, "unknown")
        XCTAssertEqual(entity.id, .unidentified)
        XCTAssertNoThrow(try UnidentifiedTestEntity.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_UnidentifiedEntityWithAttributes_deprecated() {
        let entity = decoded(type: UnidentifiedTestEntity.self,
                             data: entity_no_resource_unidentified_with_attributes)
        
        XCTAssertEqual(entity[\.me], "unknown")
    }
    
    func test_UnidentifiedEntityWithAttributes_encode() {
        test_DecodeEncodeEquality(type: UnidentifiedTestEntity.self,
                                  data: entity_no_resource_unidentified_with_attributes)
    }
}

// MARK: With Meta and/or Links
extension NoResourceObjectTests {
    func test_UnidentifiedEntityWithAttributesAndMeta() {
        let entity = decoded(type: UnidentifiedTestEntityWithMeta.self,
                             data: entity_no_resource_unidentified_with_attributes_and_meta)
        
        XCTAssertEqual(entity.me, "unknown")
        XCTAssertEqual(entity.id, .unidentified)
        XCTAssertEqual(entity.meta.x, "world")
        XCTAssertEqual(entity.meta.y, 5)
        XCTAssertNoThrow(try UnidentifiedTestEntityWithMeta.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_UnidentifiedEntityWithAttributesAndMeta_deprecated() {
        let entity = decoded(type: UnidentifiedTestEntityWithMeta.self,
                             data: entity_no_resource_unidentified_with_attributes_and_meta)
        
        XCTAssertEqual(entity[\.me], "unknown")
    }
    
    func test_UnidentifiedEntityWithAttributesAndMeta_encode() {
        test_DecodeEncodeEquality(type: UnidentifiedTestEntityWithMeta.self,
                                  data: entity_no_resource_unidentified_with_attributes_and_meta)
    }
    
    func test_UnidentifiedEntityWithAttributesAndLinks() {
        let entity = decoded(type: UnidentifiedTestEntityWithLinks.self,
                             data: entity_no_resource_unidentified_with_attributes_and_links)
        
        XCTAssertEqual(entity.me, "unknown")
        XCTAssertEqual(entity.id, .unidentified)
        XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
        XCTAssertNoThrow(try UnidentifiedTestEntityWithLinks.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_UnidentifiedEntityWithAttributesAndLinks_deprecated() {
        let entity = decoded(type: UnidentifiedTestEntityWithLinks.self,
                             data: entity_no_resource_unidentified_with_attributes_and_links)
        
        XCTAssertEqual(entity[\.me], "unknown")
    }
    
    func test_UnidentifiedEntityWithAttributesAndLinks_encode() {
        test_DecodeEncodeEquality(type: UnidentifiedTestEntityWithLinks.self,
                                  data: entity_no_resource_unidentified_with_attributes_and_links)
    }
    
    func test_UnidentifiedEntityWithAttributesAndMetaAndLinks() {
        let entity = decoded(type: UnidentifiedTestEntityWithMetaAndLinks.self,
                             data: entity_no_resource_unidentified_with_attributes_and_meta_and_links)
        
        XCTAssertEqual(entity.me, "unknown")
        XCTAssertEqual(entity.id, .unidentified)
        XCTAssertEqual(entity.meta.x, "world")
        XCTAssertEqual(entity.meta.y, 5)
        XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
        XCTAssertNoThrow(try UnidentifiedTestEntityWithMetaAndLinks.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_UnidentifiedEntityWithAttributesAndMetaAndLinks_deprecated() {
        let entity = decoded(type: UnidentifiedTestEntityWithMetaAndLinks.self,
                             data: entity_no_resource_unidentified_with_attributes_and_meta_and_links)
        
        XCTAssertEqual(entity[\.me], "unknown")
    }
    
    func test_UnidentifiedEntityWithAttributesAndMetaAndLinks_encode() {
        test_DecodeEncodeEquality(type: UnidentifiedTestEntityWithMetaAndLinks.self,
                                  data: entity_no_resource_unidentified_with_attributes_and_meta_and_links)
    }
    
    func test_EntitySomeRelationshipsSomeAttributesWithMeta() {
        let entity = decoded(type: TestEntity4WithMeta.self,
                             data: entity_no_resource_some_relationships_some_attributes_with_meta)
        
        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
        XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
        XCTAssertEqual(entity.meta.x, "world")
        XCTAssertEqual(entity.meta.y, 5)
        XCTAssertNoThrow(try TestEntity4WithMeta.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_EntitySomeRelationshipsSomeAttributesWithMeta_deprecated() {
        let entity = decoded(type: TestEntity4WithMeta.self,
                             data: entity_no_resource_some_relationships_some_attributes_with_meta)
        
        XCTAssertEqual(entity[\.word], "coolio")
        XCTAssertEqual(entity[\.number], 992299)
    }
    
    func test_EntitySomeRelationshipsSomeAttributesWithMeta_encode() {
        test_DecodeEncodeEquality(type: TestEntity4WithMeta.self,
                                  data: entity_no_resource_some_relationships_some_attributes_with_meta)
    }
    
    func test_EntitySomeRelationshipsSomeAttributesWithLinks() {
        let entity = decoded(type: TestEntity4WithLinks.self,
                             data: entity_no_resource_some_relationships_some_attributes_with_links)
        
        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
        XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
        XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
        XCTAssertNoThrow(try TestEntity4WithLinks.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_EntitySomeRelationshipsSomeAttributesWithLinks_deprecated() {
        let entity = decoded(type: TestEntity4WithLinks.self,
                             data: entity_no_resource_some_relationships_some_attributes_with_links)
        
        XCTAssertEqual(entity[\.word], "coolio")
        XCTAssertEqual(entity[\.number], 992299)
    }
    
    func test_EntitySomeRelationshipsSomeAttributesWithLinks_encode() {
        test_DecodeEncodeEquality(type: TestEntity4WithLinks.self,
                                  data: entity_no_resource_some_relationships_some_attributes_with_links)
    }
    
    func test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks() {
        let entity = decoded(type: TestEntity4WithMetaAndLinks.self,
                             data: entity_no_resource_some_relationships_some_attributes_with_meta_and_links)
        
        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
        XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
        XCTAssertEqual(entity.meta.x, "world")
        XCTAssertEqual(entity.meta.y, 5)
        XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
        XCTAssertNoThrow(try TestEntity4WithMetaAndLinks.check(entity))
        
        testEncoded(entity: entity)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks_deprecated() {
        let entity = decoded(type: TestEntity4WithMetaAndLinks.self,
                             data: entity_no_resource_some_relationships_some_attributes_with_meta_and_links)
        
        XCTAssertEqual(entity[\.word], "coolio")
        XCTAssertEqual(entity[\.number], 992299)
    }
    
    func test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks_encode() {
        test_DecodeEncodeEquality(type: TestEntity4WithMetaAndLinks.self,
                                  data: entity_no_resource_some_relationships_some_attributes_with_meta_and_links)
    }
}

// MARK: With a Meta Attribute
extension NoResourceObjectTests {
    func test_MetaEntityAttributeAccessWorks() {
        let entity1 = TestEntityWithMetaAttribute(attributes: .init(),
                                                  relationships: .none,
                                                  meta: .none,
                                                  links: .none)
        
        XCTAssertEqual(entity1.metaAttribute, true)
    }
    
    @available(*, deprecated, message: "remove next major version")
    func test_MetaEntityAttributeAccessWorks_deprecated() {
        let entity1 = TestEntityWithMetaAttribute(attributes: .init(),
                                                  relationships: .none,
                                                  meta: .none,
                                                  links: .none)
        
        XCTAssertEqual(entity1[\.metaAttribute], true)
    }
}

// MARK: With a Meta Relationship
extension NoResourceObjectTests {
    func test_MetaEntityRelationshipAccessWorks() {
        let entity1 = TestEntityWithMetaRelationship(attributes: .none,
                                                     relationships: .init(),
                                                     meta: .none,
                                                     links: .none)
        
        XCTAssertEqual(entity1 ~> \.metaRelationship, NoResourceObjectTests.TestEntity1.NoResourceIdentifier.unidentified)
    }
    
    func test_toManyMetaRelationshipAccessWorks() {
        let entity1 = TestEntityWithMetaRelationship(attributes: .none,
                                                     relationships: .init(),
                                                     meta: .none,
                                                     links: .none)
        
        XCTAssertEqual(entity1 ~> \.toManyMetaRelationship, [NoResourceObjectTests.TestEntity1.NoResourceIdentifier.unidentified])
    }
}

// MARK: - Test Types
extension NoResourceObjectTests {
    
    //Type1
    enum TestEntityType1: NoResourceObjectDescription {
        
        static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity1 = NoResourceBasicEntity<TestEntityType1>
    
    //Type2
    enum TestEntityType2: NoResourceObjectDescription {
        
        static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        struct Relationships: JSONAPI.Relationships {
            let other: ToOneRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>
        }
    }
    
    typealias TestEntity2 = NoResourceBasicEntity<TestEntityType2>
    
    //Type3
    enum TestEntityType3: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        struct Relationships: JSONAPI.Relationships {
            let others: ToManyRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>
        }
    }
    
    typealias TestEntity3 = NoResourceBasicEntity<TestEntityType3>
    
    //Type4
    enum TestEntityType4: NoResourceObjectDescription {
        
        static var jsonType: String? { return nil }
        
        struct Relationships: JSONAPI.Relationships {
            let other: ToOneRelationship<ResourceObject.TestEntity2, NoMetadata, NoLinks>
        }
        
        struct Attributes: JSONAPI.Attributes {
            let word: Attribute<String>
            let number: Attribute<Int>
            let array: Attribute<[Double]>
        }
    }
    
    typealias TestEntity4 = NoResourceBasicEntity<TestEntityType4>
    
    typealias TestEntity4WithMeta = NoResourceEntity<TestEntityType4, TestEntityMeta, NoLinks>
    
    typealias TestEntity4WithLinks = NoResourceEntity<TestEntityType4, NoMetadata, TestEntityLinks>
    
    typealias TestEntity4WithMetaAndLinks = NoResourceEntity<TestEntityType4, TestEntityMeta, TestEntityLinks>
    
    //Type5
    enum TestEntityType5: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Relationships = NoRelationships
        
        struct Attributes: JSONAPI.Attributes {
            let floater: Attribute<Double>
        }
    }
    
    typealias TestEntity5 = NoResourceBasicEntity<TestEntityType5>
    
    //Type6
    enum TestEntityType6: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Relationships = NoRelationships
        
        struct Attributes: JSONAPI.Attributes {
            let here: Attribute<String>
            let maybeHere: Attribute<String>?
            let maybeNull: Attribute<String?>
        }
    }
    
    typealias TestEntity6 = NoResourceBasicEntity<TestEntityType6>
    
    //Type7
    enum TestEntityType7: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Relationships = NoRelationships
        
        struct Attributes: JSONAPI.Attributes {
            let here: Attribute<String>
            let maybeHereMaybeNull: Attribute<String?>?
        }
    }
    
    typealias TestEntity7 = NoResourceBasicEntity<TestEntityType7>
    
    //Type8
    enum TestEntityType8: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Relationships = NoRelationships
        
        struct Attributes: JSONAPI.Attributes {
            let string: Attribute<String>
            let int: Attribute<Int>
            let stringFromInt: TransformedAttribute<Int, IntToString>
            let plus: TransformedAttribute<Int, IntPlusOneHundred>
            let doubleFromInt: TransformedAttribute<Int, IntToDouble>
            let omitted: TransformedAttribute<Int, IntToString>?
            let nullToString: TransformedAttribute<Int?, OptionalToString<Int>>
        }
    }
    
    typealias TestEntity8 = NoResourceBasicEntity<TestEntityType8>
    
    //Type9
    enum TestEntityType9: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        public struct Relationships: JSONAPI.Relationships {
            let one: ToOneRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>
            
            let nullableOne: ToOneRelationship<ResourceObject.TestEntity1?, NoMetadata, NoLinks>
            
            let optionalOne: ToOneRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>?
            
            let optionalNullableOne: ToOneRelationship<ResourceObject.TestEntity1?, NoMetadata, NoLinks>?
            
            let optionalMany: ToManyRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>?
            
            // a nullable many is not allowed. it should
            // just be an empty array.
        }
    }
    
    typealias TestEntity9 = NoResourceBasicEntity<TestEntityType9>
    
    //Type10
    enum TestEntityType10: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        public struct Relationships: JSONAPI.Relationships {
            let selfRef: ToOneRelationship<ResourceObject.TestEntity10, NoMetadata, NoLinks>
            let selfRefs: ToManyRelationship<ResourceObject.TestEntity10, NoMetadata, NoLinks>
        }
    }
    
    typealias TestEntity10 = NoResourceBasicEntity<TestEntityType10>
    
    //Type11
    enum TestEntityType11: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        public struct Attributes: JSONAPI.Attributes {
            let number: ValidatedAttribute<Int, IntOver10>
        }
        
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity11 = NoResourceBasicEntity<TestEntityType11>
    
    //Type12
    enum TestEntityType12: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        public struct Attributes: JSONAPI.Attributes {
            let number: ValidatedAttribute<Int, IntOver10>
        }
        
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity12 = NoResourceBasicEntity<TestEntityType12>
    
    //Type15
    enum TestEntityType15: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        public struct Relationships: JSONAPI.Relationships {
            public init() {
                optionalOne = nil
                optionalNullableOne = nil
                optionalMany = nil
            }
            
            let optionalOne: ToOneRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>?
            
            let optionalNullableOne: ToOneRelationship<ResourceObject.TestEntity1?, NoMetadata, NoLinks>?
            
            let optionalMany: ToManyRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>?
        }
    }
    
    typealias TestEntity15 = NoResourceBasicEntity<TestEntityType15>
    
    //Unidentified
    enum UnidentifiedTestEntityType: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        struct Attributes: JSONAPI.Attributes {
            let me: Attribute<String>?
        }
        
        typealias Relationships = NoRelationships
    }
    
    typealias UnidentifiedTestEntity = NoResourceNewEntity<UnidentifiedTestEntityType, NoMetadata, NoLinks>
    
    typealias UnidentifiedTestEntityWithMeta = NoResourceNewEntity<UnidentifiedTestEntityType, TestEntityMeta, NoLinks>
    
    typealias UnidentifiedTestEntityWithLinks = NoResourceNewEntity<UnidentifiedTestEntityType, NoMetadata, TestEntityLinks>
    
    typealias UnidentifiedTestEntityWithMetaAndLinks = NoResourceNewEntity<UnidentifiedTestEntityType, TestEntityMeta, TestEntityLinks>
    
    enum TestEntityWithMetaAttributeDescription: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        struct Attributes: JSONAPI.Attributes {
            var metaAttribute: (TestEntityWithMetaAttribute) -> Bool {
                return { entity in
                    return entity.id == .unidentified
                }
            }
        }
        
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntityWithMetaAttribute = NoResourceBasicEntity<TestEntityWithMetaAttributeDescription>
    
    enum TestEntityWithMetaRelationshipDescription: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        struct Relationships: JSONAPI.Relationships {
            var metaRelationship: (TestEntityWithMetaRelationship) -> TestEntity1.NoResourceIdentifier {
                return { _ in TestEntity1.NoResourceIdentifier.unidentified }
            }
            
            var toManyMetaRelationship: (TestEntityWithMetaRelationship) -> [TestEntity1.NoResourceIdentifier] {
                return { entity in
                    return [TestEntity1.NoResourceIdentifier.unidentified]
                }
            }
        }
    }
    
    typealias TestEntityWithMetaRelationship = NoResourceBasicEntity<TestEntityWithMetaRelationshipDescription>
    
    enum IntToString: Transformer {
        public static func transform(_ from: Int) -> String {
            return String(from)
        }
    }
    
    enum IntPlusOneHundred: Transformer {
        public static func transform(_ from: Int) -> Int {
            return from + 100
        }
    }
    
    enum IntToDouble: Transformer {
        public static func transform(_ from: Int) -> Double {
            return Double(from)
        }
    }
    
    enum OptionalToString<T>: Transformer {
        public static func transform(_ from: T?) -> String {
            return String(describing: from)
        }
    }
    
    enum IntOver10: Validator {
        enum Error: Swift.Error {
            case under10
        }
        
        public static func transform(_ from: Int) throws -> Int {
            guard from > 10 else {
                throw Error.under10
            }
            return from
        }
    }
    
    struct TestEntityMeta: JSONAPI.Meta {
        let x: String
        let y: Int?
    }
    
    struct TestEntityLinks: JSONAPI.Links {
        let link1: Link<String, NoMetadata>
    }
}

extension NoResourceObjectTests {
    enum ResourceObject {
        
        enum TestEntityType1: ResourceObjectDescription {
            static var jsonType: String { return "test_entities"}
            
            typealias Attributes = NoAttributes
            typealias Relationships = NoRelationships
        }
        
        typealias TestEntity1 = BasicEntity<TestEntityType1>
        
        enum TestEntityType2: ResourceObjectDescription {
            
            static var jsonType: String { return "second_test_entities" }
            
            typealias Attributes = NoAttributes
            
            struct Relationships: JSONAPI.Relationships {
                let other: ToOneRelationship<ResourceObject.TestEntity1, NoMetadata, NoLinks>
            }
        }
        
        typealias TestEntity2 = BasicEntity<ResourceObject.TestEntityType2>
        
        enum TestEntityType4: ResourceObjectDescription {
            static var jsonType: String { return "fourth_test_entities"}
            
            struct Relationships: JSONAPI.Relationships {
                let other: ToOneRelationship<TestEntity2, NoMetadata, NoLinks>
            }
            
            struct Attributes: JSONAPI.Attributes {
                let word: Attribute<String>
                let number: Attribute<Int>
                let array: Attribute<[Double]>
            }
        }
        
        typealias TestEntity4 = BasicEntity<TestEntityType4>
        
        enum TestEntityType10: ResourceObjectDescription {
            public static var jsonType: String { return "tenth_test_entities" }
            
            typealias Attributes = NoAttributes
            
            public struct Relationships: JSONAPI.Relationships {
                let selfRef: ToOneRelationship<TestEntity10, NoMetadata, NoLinks>
                let selfRefs: ToManyRelationship<TestEntity10, NoMetadata, NoLinks>
            }
        }
        
        typealias TestEntity10 = BasicEntity<TestEntityType10>
        
    }
}
