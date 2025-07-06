// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Circuit
import struct Catena.IDFields
import protocol Catena.Fields

public protocol CircuitFields: Fields where Model == Circuit.Identified {}

// MARK: -
extension IDFields: CircuitFields where Model == Circuit.Identified {}
