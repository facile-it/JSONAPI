//
//  NoResourceObjectTests.swift
//  JSONAPI
//
//  Created by Andrea Rinaldi on 13/05/2020.
//

import XCTest
import JSONAPI
import JSONAPITesting

class NoResourceObjectTests: XCTestCase {
    
    
    
}
// MARK: - Test Types
extension NoResourceObjectTests {

    enum TestEntityType1: NoResourceObjectDescription {
        static var jsonType: String?{ return "test_entities"}

        typealias Attributes = NoAttributes
        typealias Relationships = NoRelationships
    }

    typealias TestEntity1 = NoResourceBasicEntity<TestEntityType1>
    
    enum TestEntityType2: NoResourceObjectDescription {
        
        static var jsonType: String?{ return "second_test_entities"}

        typealias Attributes = NoAttributes

        struct Relationships: JSONAPI.Relationships {
            let other: ToOneRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity2 = NoResourceBasicEntity<TestEntityType2>

    enum TestEntityType3: NoResourceObjectDescription {
        static var jsonType: String?{ return "third_test_entities"}

        typealias Attributes = NoAttributes

        struct Relationships: JSONAPI.Relationships {
            let others: ToManyRelationshipNoResource<TestEntity1, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity3 = NoResourceBasicEntity<TestEntityType3>

    enum TestEntityType4: NoResourceObjectDescription {
        static var jsonType: String?{ return "fourth_test_entities"}

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
        static var jsonType: String?{ return "fifth_test_entities"}

        typealias Relationships = NoRelationships

        struct Attributes: JSONAPI.Attributes {
            let floater: Attribute<Double>
        }
    }

    typealias TestEntity5 = NoResourceBasicEntity<TestEntityType5>

    enum TestEntityType6: NoResourceObjectDescription {
        static var jsonType: String?{ return "sixth_test_entities" }

        typealias Relationships = NoRelationships

        struct Attributes: JSONAPI.Attributes {
            let here: Attribute<String>
            let maybeHere: Attribute<String>?
            let maybeNull: Attribute<String?>
        }
    }

    typealias TestEntity6 = NoResourceBasicEntity<TestEntityType6>

    enum TestEntityType7: NoResourceObjectDescription {
        static var jsonType: String?{ return "seventh_test_entities" }

        typealias Relationships = NoRelationships

        struct Attributes: JSONAPI.Attributes {
            let here: Attribute<String>
            let maybeHereMaybeNull: Attribute<String?>?
        }
    }

    typealias TestEntity7 = NoResourceBasicEntity<TestEntityType7>

    enum TestEntityType8: NoResourceObjectDescription {
        static var jsonType: String?{ return "eighth_test_entities" }

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
        public static var jsonType: String? { return "ninth_test_entities" }

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
        public static var jsonType: String?{ return "tenth_test_entities" }

        typealias Attributes = NoAttributes

        public struct Relationships: JSONAPI.Relationships {
            let selfRef: ToOneRelationshipNoResource<TestEntity10, NoMetadata, NoLinks>
            let selfRefs: ToManyRelationshipNoResource<TestEntity10, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity10 = NoResourceBasicEntity<TestEntityType10>

    enum TestEntityType11: NoResourceObjectDescription {
        public static var jsonType: String? { return "eleventh_test_entities" }

        public struct Attributes: JSONAPI.Attributes {
            let number: ValidatedAttribute<Int, IntOver10>
        }

        typealias Relationships = NoRelationships
    }

    typealias TestEntity11 = NoResourceBasicEntity<TestEntityType11>

    enum TestEntityType12: NoResourceObjectDescription {
        public static var jsonType: String? { return "eleventh_test_entities" }

        public struct Attributes: JSONAPI.Attributes {
            let number: ValidatedAttribute<Int, IntOver10>
        }

        typealias Relationships = NoRelationships
    }

    typealias TestEntity12 = NoResourceBasicEntity<TestEntityType12>

    
    enum TestEntityType15: NoResourceObjectDescription {
        public static var jsonType: String? { return "fifth_test_entities" }

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
        public static var jsonType: String?{ return "unidentified_test_entities" }

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
        public static var jsonType: String? { return "meta_attribute_entity" }

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
        public static var jsonType: String? { return "meta_relationship_entity" }

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
