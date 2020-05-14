import XCTest
import JSONAPI
import JSONAPITesting

class NoResourceObjectTests: XCTestCase {
    
    func test_relationship_access() {
        let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity2 = TestEntity2(attributes: .none, relationships: .init(other: entity1.pointer), meta: .none, links: .none)
        
        XCTAssertEqual(entity2.relationships.other, entity1.pointer)
    }
    
    //    func test_relationship_operator_access() {
    //        let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
    //        let entity2 = TestEntity2(attributes: .none, relationships: .init(other: entity1.pointer), meta: .none, links: .none)
    //
    //        XCTAssertEqual(entity2 ~> \NoResourceObjectTests.TestEntityType2.Relationships.other, entity1.id)
    //    }
    //
    //        func test_optional_relationship_operator_access() {
    //            let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
    //
    //            let entity = TestEntity9(attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalNullableOne: nil, optionalMany: .init(resourceObjects: [entity1, entity1], meta: .none, links: .none)), meta: .none, links: .none)
    //
    //            XCTAssertEqual(entity ~> \.optionalOne, Optional(entity1.id))
    //            XCTAssertEqual((entity ~> \.optionalOne).rawValue, Optional(entity1.id.rawValue))
    //        }
    //
    //        func test_toMany_relationship_operator_access() {
    //            let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
    //            let entity2 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
    //            let entity4 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
    //            let entity3 = TestEntity3(attributes: .none, relationships: .init(other: .init(pointers: [entity1.pointer, entity2.pointer, entity4.pointer])), meta: .none, links: .none)
    //
    //            XCTAssertEqual(entity3 ~> \.other, [entity1.id, entity2.id, entity4.id])
    //        }
    
    //    func test_optionalToMany_relationship_opeartor_access() {
    //        let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
    //        let entity = TestEntity9(attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: nil, optionalNullableOne: nil, optionalMany: .init(resourceObjects: [entity1, entity1], meta: .none, links: .none)), meta: .none, links: .none)
    //
    //        XCTAssertEqual(entity ~> \.optionalMany, [entity1.id, entity1.id])
    //    }
    
    func test_relationshipIds() {
        let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity2 = TestEntity2(attributes: .none, relationships: .init(other: entity1.pointer), meta: .none, links: .none)
        
        XCTAssertEqual(entity2.relationships.other.id, entity1.id)
    }
    
    func test_pointerWithMetaAndLinks() {
        
        let entity = TestEntity4WithMetaAndLinks(attributes: .init(word: "hello", number: 10, array: []), relationships: .init(other: .init(id: .id(from: "2"))), meta: .init(x: "world", y: nil), links: .init(link1: .init(url: "ok")))
        
        let pointer = entity.pointer(withMeta: TestEntityMeta(x: "world", y: nil), links: TestEntityLinks(link1: .init(url: "ok")))
        
        XCTAssertEqual(pointer.id, entity.id)
        XCTAssertEqual(pointer.meta.x, "world")
        XCTAssertEqual(pointer.links.link1.url, "ok")
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
        let entity1 = TestEntity1(id: .init(rawValue: "wow"), attributes: .none, relationships: .none, meta: .none, links: .none)
        let entity2 = TestEntity2(id: .init(rawValue: "cool"), attributes: .none, relationships: .init(other: .init(resourceObject: entity1)), meta: .none, links: .none)
        let _ = TestEntity2(id: .init(rawValue: "cool"), attributes: .none, relationships: .init(other: .init(resourceObject: entity1)), meta: .none, links: .none)
        let _ = TestEntity2(id: .init(rawValue: "cool"), attributes: .none, relationships: .init(other: .init(resourceObject: entity1)), meta: .none, links: .none)
        let _ = TestEntity3(id: .init(rawValue: "3"), attributes: .none, relationships: .init(other: .init(ids: [.init(rawValue: "10"), .init(rawValue: "20"), entity1.id])), meta: .none, links: .none)
        let _ = TestEntity3(id: .init(rawValue: "3"), attributes: .none, relationships: .init(other: .none), meta: .none, links: .none)
        let _ = TestEntity4(id: .init(rawValue: "4"), attributes: .init(word: .init(value: "hello"), number: .init(value: 10), array: .init(value: [10.2, 10.3])), relationships: .init(other: entity2.pointer), meta: .none, links: .none)
        let _ = TestEntity5(id: .init(rawValue: "5"), attributes: .init(floater: .init(value: 10.2)), relationships: .none, meta: .none, links: .none)
        let _ = TestEntity6(id: .init(rawValue: "6"), attributes: .init(here: .init(value: "here"), maybeHere: nil, maybeNull: .init(value: nil)), relationships: .none, meta: .none, links: .none)
        let _ = TestEntity7(id: .init(rawValue: "7"), attributes: .init(here: .init(value: "hello"), maybeHereMaybeNull: .init(value: "world")), relationships: .none, meta: .none, links: .none)
        XCTAssertNoThrow(try TestEntity8(id: .init(rawValue: "8"), attributes: .init(string: .init(value: "hello"), int: .init(value: 10), stringFromInt: .init(rawValue: 20), plus: .init(rawValue: 30), doubleFromInt: .init(rawValue: 32), omitted: nil, nullToString: .init(rawValue: nil)), relationships: .none, meta: .none, links: .none))
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: nil, optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: .init(resourceObject: nil), optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: .init(id: nil), optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: nil, optionalOne: entity1.pointer, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: nil, optionalOne: nil, optionalNullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalMany: nil), meta: .none, links: .none)
        //        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(one: entity1.pointer, nullableOne: nil, optionalOne: nil, optionalNullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalMany: .init(resourceObjects: [], meta: .none, links: .none)), meta: .none, links: .none)
        let e10id1 = TestEntity10.Identifier(rawValue: "hello")
        let e10id2 = TestEntity10.Id(rawValue: "world")
        let e10id3 = TestEntity10.Id(rawValue: "!")
        let _ = TestEntity10(id: .init(rawValue: "10"), attributes: .none, relationships: .init(selfRef: .init(id: e10id1), selfRefs: .init(ids: [e10id2, e10id3])), meta: .none, links: .none)
        XCTAssertNoThrow(try TestEntity11(id: .init(rawValue: "11"), attributes: .init(number: .init(rawValue: 11)), relationships: .none, meta: .none, links: .none))
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
        XCTAssertEqual(identifiedCopy.id, OptionalTypedId(rawValue: "hello"))
    }
    
    func test_copyWithNewId() {
        let identifiedEntity = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        
        let identifiedCopy = identifiedEntity.withNewIdentifier()
        
        XCTAssertNotEqual(identifiedEntity.id, identifiedCopy.id)
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
    //
    //    func test_EntitySomeRelationshipsNoAttributes() {
    //        let entity = decoded(type: TestEntity3.self,
    //                                   data: entity_no_resource_some_relationships_no_attributes)
    //
    //        XCTAssert(type(of: entity.attributes) == NoAttributes.self)
    //
    //        XCTAssertEqual((entity ~> \.others).map { $0.rawValue }, ["364B3B69-4DF1-467F-B52E-B0C9E44F666E"])
    //        XCTAssertNoThrow(try TestEntity3.check(entity))
    //
    //        testEncoded(entity: entity)
    //    }
    //
    //    func test_EntitySomeRelationshipsNoAttributes_encode() {
    //        test_DecodeEncodeEquality(type: TestEntity3.self,
    //                                  data: entity_no_resource_some_relationships_no_attributes)
    //    }
    //
    //    func test_EntitySomeRelationshipsSomeAttributes() {
    //        let entity = decoded(type: TestEntity4.self,
    //                             data: entity_no_resource_some_relationships_some_attributes)
    //
    //        XCTAssertEqual(entity.word, "coolio")
    //        XCTAssertEqual(entity.number, 992299)
    //        XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
    //        XCTAssertNoThrow(try TestEntity4.check(entity))
    //
    //        testEncoded(entity: entity)
    //    }
    //
    //    @available(*, deprecated, message: "remove next major version")
    //    func test_EntitySomeRelationshipsSomeAttributes_deprecated() {
    //        let entity = decoded(type: TestEntity4.self,
    //                             data: entity_no_resource_some_relationships_some_attributes)
    //
    //        XCTAssertEqual(entity[\.word], "coolio")
    //        XCTAssertEqual(entity[\.number], 992299)
    //    }
    //
    //    func test_EntitySomeRelationshipsSomeAttributes_encode() {
    //        test_DecodeEncodeEquality(type: TestEntity4.self,
    //                                  data: entity_no_resource_some_relationships_some_attributes)
    //    }
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

// MARK: - Test Types
extension NoResourceObjectTests {
    
    enum TestEntityType1: NoResourceObjectDescription {
        static var jsonType: String? { return nil}
        
        typealias Attributes = NoAttributes
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity1 = NoResourceBasicEntity<TestEntityType1>
    
    enum TestEntityType1Typed: NoResourceObjectDescription {
        static var jsonType: String? { return "test_entities" }
        
        typealias Attributes = NoAttributes
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity1Typed = NoResourceBasicEntity<TestEntityType1>
    
    
    enum TestEntityType2: NoResourceObjectDescription {
        
        static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        struct Relationships: JSONAPI.Relationships {
            let other: ToOneRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>
        }
    }
    
    typealias TestEntity2 = NoResourceBasicEntity<TestEntityType2>
    
    enum TestEntityType3: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        struct Relationships: JSONAPI.Relationships {
            let other: ToManyRelationshipNoResource<TestEntity1Typed, NoMetadata, NoLinks>
        }
    }
    
    typealias TestEntity3 = NoResourceBasicEntity<TestEntityType3>
    
    enum TestEntityType4: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        struct Relationships: JSONAPI.Relationships {
            let other: ToOneRelationshipNoResource<TestEntity2, NoMetadata, NoLinks>
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
    
    enum TestEntityType5: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Relationships = NoRelationships
        
        struct Attributes: JSONAPI.Attributes {
            let floater: Attribute<Double>
        }
    }
    
    typealias TestEntity5 = NoResourceBasicEntity<TestEntityType5>
    
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
    
    enum TestEntityType7: NoResourceObjectDescription {
        static var jsonType: String? { return nil }
        
        typealias Relationships = NoRelationships
        
        struct Attributes: JSONAPI.Attributes {
            let here: Attribute<String>
            let maybeHereMaybeNull: Attribute<String?>?
        }
    }
    
    typealias TestEntity7 = NoResourceBasicEntity<TestEntityType7>
    
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
    
    enum TestEntityType9: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        public struct Relationships: JSONAPI.Relationships {
            let one: ToOneRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>
            
            //            let nullableOne: ToOneRelationshipNoResource<TestEntity1?, NoMetadata, NoLinks>
            
            let optionalOne: ToOneRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>?
            
            //            let optionalNullableOne: ToOneRelationshipNoResource<TestEntity1?, NoMetadata, NoLinks>?
            
            let optionalMany: ToManyRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>?
            
            // a nullable many is not allowed. it should
            // just be an empty array.
        }
    }
    
    typealias TestEntity9 = NoResourceBasicEntity<TestEntityType9>
    
    enum TestEntityType10: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        public struct Relationships: JSONAPI.Relationships {
            let selfRef: ToOneRelationshipNoResource<TestEntity10, NoMetadata, NoLinks>
            let selfRefs: ToManyRelationshipNoResource<TestEntity10, NoMetadata, NoLinks>
        }
    }
    
    typealias TestEntity10 = NoResourceBasicEntity<TestEntityType10>
    
    enum TestEntityType11: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        public struct Attributes: JSONAPI.Attributes {
            let number: ValidatedAttribute<Int, IntOver10>
        }
        
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity11 = NoResourceBasicEntity<TestEntityType11>
    
    enum TestEntityType12: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        public struct Attributes: JSONAPI.Attributes {
            let number: ValidatedAttribute<Int, IntOver10>
        }
        
        typealias Relationships = NoRelationships
    }
    
    typealias TestEntity12 = NoResourceBasicEntity<TestEntityType12>
    
    
    enum TestEntityType15: NoResourceObjectDescription {
        public static var jsonType: String? { return nil }
        
        typealias Attributes = NoAttributes
        
        public struct Relationships: JSONAPI.Relationships {
            public init() {
                optionalOne = nil
                //                optionalNullableOne = nil
                optionalMany = nil
            }
            
            let optionalOne: ToOneRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>?
            
            //            let optionalNullableOne: ToOneRelationshipNoResource<TestEntity1?, NoMetadata, NoLinks>?
            
            let optionalMany: ToManyRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>?
        }
    }
    
    typealias TestEntity15 = NoResourceBasicEntity<TestEntityType15>
    
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
                    (entity.id.rawValue.count % 2) == 0
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
            var metaRelationship: (TestEntityWithMetaRelationship) -> TestEntity1.Identifier {
                return { entity in
                    return TestEntity1.Identifier(rawValue: "hello")
                }
            }
            
            var toManyMetaRelationship: (TestEntityWithMetaRelationship) -> [TestEntity1.Identifier] {
                return { entity in
                    return [TestEntity1.Identifier.id(from: "hello")]
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
