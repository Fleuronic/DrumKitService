// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Address
import struct Catena.IDFields
import protocol Catena.Fields

public protocol AddressFields: Fields where Model == Address.Identified {}

// MARK: -
extension IDFields: AddressFields where Model == Address.Identified {}
