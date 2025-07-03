// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Location
import struct Catena.IDFields
import protocol Catena.Fields

public protocol LocationFields: Fields where Model == Location.Identified {}

// MARK: -
extension IDFields: LocationFields where Model == Location.Identified {}
