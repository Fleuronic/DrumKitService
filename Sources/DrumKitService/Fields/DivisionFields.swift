// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Division
import struct Catena.IDFields
import protocol Catena.Fields

public protocol DivisionFields: Fields where Model == Division.Identified {}

// MARK: -
extension IDFields: DivisionFields where Model == Division.Identified {}
