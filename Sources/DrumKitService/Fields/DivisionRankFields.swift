// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.DivisionRank
import struct Catena.IDFields
import protocol Catena.Fields

public protocol DivisionRankFields: Fields where Model == DivisionRank.Identified {}

// MARK: -
extension IDFields: DivisionRankFields where Model == DivisionRank.Identified {}
