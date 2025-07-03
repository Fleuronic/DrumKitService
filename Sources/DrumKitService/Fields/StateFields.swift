// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.State
import struct Catena.IDFields
import protocol Catena.Fields

public protocol StateFields: Fields where Model == State.Identified {}

// MARK: -
extension IDFields: StateFields where Model == State.Identified {}
