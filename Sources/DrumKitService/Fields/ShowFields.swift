// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Show
import struct Catena.IDFields
import protocol Catena.Fields

public protocol ShowFields: Fields where Model == Show.Identified {}

// MARK: -
extension IDFields: ShowFields where Model == Show.Identified {}
