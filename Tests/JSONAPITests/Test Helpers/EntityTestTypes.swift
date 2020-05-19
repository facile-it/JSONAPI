//
//  EntityTestTypes.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/15/18.
//

import JSONAPI

public typealias Entity<Description: JSONAPI.ResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.ResourceObject<Description, Meta, Links, String>

public typealias BasicEntity<Description: JSONAPI.ResourceObjectDescription> = Entity<Description, NoMetadata, NoLinks>

public typealias NewEntity<Description: JSONAPI.ResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.ResourceObject<Description, Meta, Links, Unidentified>

public typealias NoResourceEntity<Description: JSONAPI.NoResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.NoResourceObject<Description, Meta, Links, String>

public typealias NoResourceBasicEntity<Description: JSONAPI.NoResourceObjectDescription> = NoResourceEntity<Description, NoMetadata, NoLinks>

public typealias NoResourceNewEntity<Description: JSONAPI.NoResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.NoResourceObject<Description, Meta, Links, Unidentified>

extension String: JSONAPI.JSONAPIURL {}
