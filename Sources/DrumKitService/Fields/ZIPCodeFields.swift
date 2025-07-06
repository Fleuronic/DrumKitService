// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.ZIPCode
import struct Catena.IDFields
import protocol Catena.Fields

public protocol ZIPCodeFields: Fields where Model == ZIPCode.Identified {}

// MARK: -
extension IDFields: ZIPCodeFields where Model == ZIPCode.Identified {}
