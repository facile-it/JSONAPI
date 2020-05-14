let entity_no_resource_no_relationships_no_attributes = """
{
    "id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
}
""".data(using: .utf8)!

let entity_no_resource_no_relationships_some_attributes = """
{
"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
"attributes": {
"floater": 123.321
}
}
""".data(using: .utf8)!

let entity_no_resource_some_relationships_no_attributes = """
{
"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
"relationships": {
"others": {
"data": [{
"type": "test_entities",
"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
}]
}
}
}
""".data(using: .utf8)!

let entity_no_resource_some_relationships_some_attributes = """
{
"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
"attributes": {
"word": "coolio",
"number": 992299,
"array": [12.3, 4, 0.1]
},
"relationships": {
"other": {
"data": {
"type": "second_test_entities",
"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
}
}
}
}
""".data(using: .utf8)!

let entity_no_resource_some_relationships_some_attributes_with_meta = """
{
    "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
    "attributes": {
        "word": "coolio",
        "number": 992299,
        "array": [12.3, 4, 0.1]
    },
    "relationships": {
        "other": {
            "data": {
                "type": "second_test_entities",
                "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
            }
        }
    },
    "meta": {
        "x": "world",
        "y": 5
    },
    "links": {
        "link1": "https://image.com/image.png"
    }
}
""".data(using: .utf8)!

let entity_no_resource_some_relationships_some_attributes_with_links = """
{
    "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
    "attributes": {
        "word": "coolio",
        "number": 992299,
        "array": [12.3, 4, 0.1]
    },
    "relationships": {
        "other": {
            "data": {
                "type": "second_test_entities",
                "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
            }
        }
    },
    "links": {
        "link1": "https://image.com/image.png"
    }
}
""".data(using: .utf8)!

let entity_no_resource_some_relationships_some_attributes_with_meta_and_links = """
{
    "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
    "attributes": {
        "word": "coolio",
        "number": 992299,
        "array": [12.3, 4, 0.1]
    },
    "relationships": {
        "other": {
            "data": {
                "type": "second_test_entities",
                "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
            }
        }
    },
    "meta": {
        "x": "world",
        "y": 5
    },
    "links": {
        "link1": "https://image.com/image.png"
    }
}
""".data(using: .utf8)!

let entity_no_resource_one_omitted_attribute = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeNull": "World"
    }
}
""".data(using: .utf8)!

let entity_no_resource_one_null_attribute = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeHere": "World",
        "maybeNull": null
    }
}
""".data(using: .utf8)!

let entity_no_resource_all_attributes = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeHere": "World",
        "maybeNull": "!"
    }
}
""".data(using: .utf8)!

let entity_no_resource_one_null_and_one_missing_attribute = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeNull": null
    }
}
""".data(using: .utf8)!

let entity_no_resource_broken_missing_nullable_attribute = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeHere": "World"
    }
}
""".data(using: .utf8)!

let entity_no_resource_null_optional_nullable_attribute = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeHereMaybeNull": null
    }
}
""".data(using: .utf8)!

let entity_no_resource_non_null_optional_nullable_attribute = """
{
    "id": "1",
    "attributes": {
        "here": "Hello",
        "maybeHereMaybeNull": "World"
    }
}
""".data(using: .utf8)!

let entity_no_resource_int_to_string_attribute = """
{
    "id": "1",
    "attributes": {
        "string": "22",
        "int": 22,
        "stringFromInt": 22,
        "plus": 22,
        "doubleFromInt": 22,
        "nullToString": null
    }
}
""".data(using: .utf8)!

let entity_no_resource_optional_not_omitted_relationship = """
{
    "id": "1",
    "relationships": {
        "nullableOne": {
            "data": {
                "id": "3323",
                "type": "test_entities"
            }
        },
        "one": {
            "data": {
                "id": "4459",
                "type": "test_entities"
            }
        },
        "optionalNullableOne": {
            "data": {
                "id": "1229",
                "type": "test_entities"
            }
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_optional_nullable_nulled_relationship = """
{
    "id": "1",
    "relationships": {
        "nullableOne": {
            "data": {
                "id": "3323",
                "type": "test_entities"
            }
        },
        "one": {
            "data": {
                "id": "4459",
                "type": "test_entities"
            }
        },
        "optionalNullableOne": {
            "data": null
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_omitted_relationship = """
{
    "id": "1",
    "relationships": {
        "nullableOne": {
            "data": {
                "id": "3323",
                "type": "test_entities"
            }
        },
        "one": {
            "data": {
                "id": "4459",
                "type": "test_entities"
            }
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_optional_to_many_relationship_not_omitted = """
{
    "id": "1",
    "relationships": {
        "nullableOne": {
            "data": {
                "id": "3323",
                "type": "test_entities"
            }
        },
        "one": {
            "data": {
                "id": "4459",
                "type": "test_entities"
            }
        },
        "optionalMany": {
            "data": [
                {
                    "id": "332223",
                    "type": "test_entities"
                }
            ]
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_nulled_relationship = """
{
    "id": "1",
    "relationships": {
        "nullableOne": {
            "data": null
        },
        "one": {
            "data": {
                "id": "4452",
                "type": "test_entities"
            }
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_self_ref_relationship = """
{
    "id": "1",
    "relationships": {
        "selfRefs": { "data": [] },
        "selfRef": {
            "data": {
                "id": "1",
                "type": "tenth_test_entities"
            }
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_invalid_validated_attribute = """
{
    "id": "1",
    "attributes": {
        "number": 10
    }
}
""".data(using: .utf8)!

let entity_no_resource_valid_validated_attribute = """
{
    "id": "1",
    "attributes": {
        "number": 60
    }
}
""".data(using: .utf8)!

let entity_no_resource_all_relationships_optional_and_omitted = """
{
    "id": "1",
    "attributes": {
        "number": 10
    }
}
""".data(using: .utf8)!

let entity_no_resource_nonNullable_relationship_is_null = """
{
    "id": "1",
    "relationships": {
        "required": null
    }
}
""".data(using: .utf8)!

let entity_no_resource_nonNullable_relationship_is_null2 = """
{
    "id": "1",
    "relationships": {
        "required": {
            "data": null
        }
    }
}
""".data(using: .utf8)!

let entit_no_resourcey_required_relationship_is_omitted = """
{
    "id": "1",
    "relationships": {
    }
}
""".data(using: .utf8)!

let entity_no_resource_relationship_is_wrong_type = """
{
    "id": "1",
    "relationships": {
        "required": {
            "data": {
                "id": "123",
                "type": "not_the_same"
            }
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_single_relationship_is_many = """
{
    "id": "1",
    "relationships": {
        "required": {
            "data": [{
                "id": "123",
                "type": "thirteenth_test_entities"
            }]
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_many_relationship_is_single = """
{
    "id": "1",
    "relationships": {
        "required": {
            "data": {
                "id": "123",
                "type": "thirteenth_test_entities"
            }
        },
        "omittable": {
            "data": {
                "id": "456",
                "type": "thirteenth_test_entities"
            }
        }
    }
}
""".data(using: .utf8)!

let entity_no_resource_relationships_entirely_missing = """
{
    "id": "1",
}
""".data(using: .utf8)!

let entity_no_resource_required_attribute_is_omitted = """
{
    "id": "1",
    "attributes": {
    }
}
""".data(using: .utf8)!

let entity_no_resource_nonNullable_attribute_is_null = """
{
    "id": "1",
    "attributes": {
        "required": null
    }
}
""".data(using: .utf8)!

let entity_no_resource_attribute_is_wrong_type = """
{
    "id": "1",
    "attributes": {
        "required": 10
    }
}
""".data(using: .utf8)!

let entity_no_resource_attribute_is_wrong_type2 = """
{
    "id": "1",
    "attributes": {
        "required": "hello",
        "other": "world"
    }
}
""".data(using: .utf8)!

let entity_no_resource_attribute_is_wrong_type3 = """
{
    "id": "1",
    "attributes": {
        "required": "hello",
        "yetAnother": 101
    }
}
""".data(using: .utf8)!

let entity_no_resource_attribute_is_wrong_type4 = """
{
    "id": "1",
    "attributes": {
        "required": "hello",
        "transformed": "world"
    }
}
""".data(using: .utf8)!

let entity_no_resource_attribute_always_fails = """
{
    "id": "1",
    "attributes": {
        "required": "hello",
        "transformed2": "world"
    }
}
""".data(using: .utf8)!

let entity_no_resource_attributes_entirely_missing = """
{
    "id": "1",
}
""".data(using: .utf8)!

let entity_no_resource_is_wrong_type = """
{
    "id": "1",
    "attributes": {
        "required": "hello",
        "yetAnother": 101
    }
}
""".data(using: .utf8)!

let entity_no_resource_type_is_wrong_type = """
{
    "id": "1",
    "attributes": {
        "required": "hello"
    }
}
""".data(using: .utf8)!

let entity_no_resource_type_is_missing = """
{
    "id": "1",
    "attributes": {
        "required": "hello"
    }
}
""".data(using: .utf8)!

let entity_no_resource_type_is_null = """
{
    "id": "1",
    "type": null,
    "attributes": {
        "required": "hello"
    }
}
""".data(using: .utf8)!

let entity_no_resource_unidentified = """
{
    "attributes": {}
}
""".data(using: .utf8)!

let entity_no_resource_unidentified_with_attributes = """
{
    "attributes": {
        "me": "unknown"
    }
}
""".data(using: .utf8)!

let entity_no_resource_unidentified_with_attributes_and_meta = """
{
    "attributes": {
        "me": "unknown"
    },
    "meta": {
        "x": "world",
        "y": 5
    }
}
""".data(using: .utf8)!

let entity_no_resource_unidentified_with_attributes_and_links = """
{
    "attributes": {
        "me": "unknown"
    },
    "links": {
        "link1": "https://image.com/image.png"
    }
}
""".data(using: .utf8)!

let entity_no_resource_unidentified_with_attributes_and_meta_and_links = """
{
    "attributes": {
        "me": "unknown"
    },
    "meta": {
        "x": "world",
        "y": 5
    },
    "links": {
        "link1": "https://image.com/image.png"
    }
}
""".data(using: .utf8)!
