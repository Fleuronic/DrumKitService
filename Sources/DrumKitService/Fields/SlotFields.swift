// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Slot
import struct Catena.IDFields
import protocol Catena.Fields

public protocol SlotFields: Fields where Model == Slot.Identified {}

// MARK: -
extension IDFields: SlotFields where Model == Slot.Identified {}
