//
//  DocumentDecodingErrorTests.swift
//  
//
//  Created by Mathew Polzin on 11/10/19.
//

import XCTest
import JSONAPI
import Poly

final class DocumentDecodingErrorTests: XCTestCase {
    func test_singlePrimaryResource_missing() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
                from: single_document_null
            )
        ) { error in
            guard let docError = error as? DocumentDecodingError,
                case .primaryResourceMissing = docError else {
                    XCTFail("Expected primary resource missing error. Got \(error)")
                    return
            }

            XCTAssertEqual(String(describing: error), "Primary Resource missing.")
        }
    }

    func test_singlePrimaryResource_failure() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
                from: single_document_no_includes_missing_relationship
            )
        ) { error in
            guard let docError = error as? DocumentDecodingError,
                case .primaryResource = docError else {
                    XCTFail("Expected primary resource document error. Got \(error)")
                    return
            }

            XCTAssertEqual(String(describing: error), "Primary Resource failed to parse because 'author' relationship is required and missing.")
        }
    }

    func test_manyPrimaryResource_missing() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
                from: many_document_no_includes_data_is_null
            )
        ) { error in
            guard let docError = error as? DocumentDecodingError,
                case .primaryResourcesMissing = docError else {
                    XCTFail("Expected primary resource missing error. Got \(error)")
                    return
            }

            XCTAssertEqual(String(describing: error), "Primary Resources array missing.")
        }
    }

    func test_manyPrimaryResource_failure() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
                from: many_document_no_includes_missing_relationship
            )
        ) { error in
            guard let docError = error as? DocumentDecodingError,
                case .primaryResource = docError else {
                    XCTFail("Expected primary resource document error. Got \(error)")
                    return
            }

            XCTAssertEqual(String(describing: error), "Primary Resource 2 failed to parse because 'author' relationship is required and missing.")
        }
    }

    func test_always_valid_includes() {
        let sut = (try? testDecoder
            .decode(
                Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
                from: single_document_some_unknown_includes))
        
        let allIncludes = sut?.body.includes?.count
        let authorCases = sut?.body.includes?[Author.self].count
        let noneCases = sut?.body.includes?.values.filter { $0 == .none }.count
        
        XCTAssertEqual(allIncludes, 3)
        XCTAssertEqual(authorCases, 2)
        XCTAssertEqual(noneCases, 1)
    }

    func test_wantSuccess_foundError() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.SuccessDocument.self,
                from: error_document_no_metadata
            )
        ) { error in
            XCTAssertEqual(String(describing: error), #"Expected a success document with a 'data' property but found an error document."#)
        }
    }

    func test_wantError_foundSuccess() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.ErrorDocument.self,
                from: single_document_some_includes_with_metadata_with_api_description
            )
        ) { error in
            XCTAssertEqual(String(describing: error), #"Expected an error document but found a success document with a 'data' property."#)
        }
    }
}

// MARK: - Test Types
extension DocumentDecodingErrorTests {
    enum AuthorType: ResourceObjectDescription {
        static var jsonType: String { return "authors" }

        typealias Attributes = NoAttributes
        typealias Relationships = NoRelationships
    }

    typealias Author = BasicEntity<AuthorType>

    enum ArticleType: ResourceObjectDescription {
        static var jsonType: String { return "articles" }

        typealias Attributes = NoAttributes

        struct Relationships: JSONAPI.Relationships {
            let author: ToOneRelationship<Author, NoIdMetadata, NoMetadata, NoLinks>
        }
    }

    typealias Article = BasicEntity<ArticleType>

    enum BookType: ResourceObjectDescription {
        static var jsonType: String { return "books" }

        struct Attributes: JSONAPI.SparsableAttributes {
            let pageCount: Attribute<Int>

            enum CodingKeys: String, SparsableCodingKey {
                case pageCount
            }
        }

        struct Relationships: JSONAPI.Relationships {
            let author: ToOneRelationship<Author, NoIdMetadata, NoMetadata, NoLinks>
            let series: ToManyRelationship<Book, NoIdMetadata, NoMetadata, NoLinks>
        }
    }

    typealias Book = BasicEntity<BookType>

    struct TestPageMetadata: JSONAPI.Meta {
        let total: Int
        let limit: Int
        let offset: Int
    }

    struct TestLinks: JSONAPI.Links {
        let link: Link<String, NoMetadata>
        let link2: Link<String,TestMetadata>

        struct TestMetadata: JSONAPI.Meta {
            let hello: String
        }
    }

    typealias TestAPIDescription = APIDescription<NoMetadata>

    enum TestError: JSONAPIError {
        case unknownError
        case basic(BasicError)

        struct BasicError: Codable, Equatable {
            let code: Int
            let description: String
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            self = (try? .basic(container.decode(BasicError.self))) ?? .unknown
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .unknownError:
                try container.encode("unknown")
            case .basic(let error):
                try container.encode(error)
            }
        }

        public static var unknown: Self {
            return .unknownError
        }
    }
}

