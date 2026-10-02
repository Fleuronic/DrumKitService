// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.DivisionSubordination
import struct Catena.IDFields
import protocol Catena.Fields

public protocol DivisionSubordinationFields: Fields where Model == DivisionSubordination.Identified {}

// MARK: -
extension IDFields: DivisionSubordinationFields where Model == DivisionSubordination.Identified {}
