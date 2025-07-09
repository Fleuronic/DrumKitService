// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Placement
import struct Catena.IDFields
import protocol Catena.Fields

public protocol PlacementFields: Fields where Model == Placement.Identified {}

// MARK: -
extension IDFields: PlacementFields where Model == Placement.Identified {}
