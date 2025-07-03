// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Corps
import struct Catena.IDFields
import protocol Catena.Fields

public protocol CorpsFields: Fields where Model == Corps.Identified {}

// MARK: -
extension IDFields: CorpsFields where Model == Corps.Identified {}
