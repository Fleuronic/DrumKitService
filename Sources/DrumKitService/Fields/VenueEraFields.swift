// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.VenueEra
import struct Catena.IDFields
import protocol Catena.Fields

public protocol VenueEraFields: Fields where Model == VenueEra.Identified {}

// MARK: -
extension IDFields: VenueEraFields where Model == VenueEra.Identified {}
