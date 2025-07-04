// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Event
import struct Catena.IDFields
import protocol Catena.Fields

public protocol EventFields: Fields where Model == Event.Identified {}

// MARK: -
extension IDFields: EventFields where Model == Event.Identified {}
