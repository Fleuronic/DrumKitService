// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.CorpsEra
import struct Catena.IDFields
import protocol Catena.Fields

public protocol CorpsEraFields: Fields where Model == CorpsEra.Identified {}

// MARK: -
extension IDFields: CorpsEraFields where Model == CorpsEra.Identified {}
