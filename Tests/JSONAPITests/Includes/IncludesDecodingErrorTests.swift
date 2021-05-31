//
//  IncludesDecodingErrorTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/14/19.
//

import XCTest
import JSONAPI

final class IncludesDecodingErrorTests: XCTestCase {
    func test_unexpectedIncludeType() {
        
        XCTAssertNoThrow(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: three_different_type_includes))

    }
}

// MARK: - Test Types
extension IncludesDecodingErrorTests {
    enum TestEntityType: ResourceObjectDescription {

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity1" }

        public struct Attributes: JSONAPI.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>

    enum TestEntityType2: ResourceObjectDescription {

        public static var jsonType: String { return "test_entity2" }

        public struct Relationships: JSONAPI.Relationships {
            let entity1: ToOneRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>
        }

        public struct Attributes: JSONAPI.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity2 = BasicEntity<TestEntityType2>

    enum TestEntityType4: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity4" }
    }

    typealias TestEntity4 = BasicEntity<TestEntityType4>

    enum TestEntityType6: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        public static var jsonType: String { return "test_entity6" }

        struct Relationships: JSONAPI.Relationships {
            let entity4: ToOneRelationship<TestEntity4, NoIdMetadata, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity6 = BasicEntity<TestEntityType6>
}
