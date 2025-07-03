// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Country
import struct Catena.IDFields
import protocol Catena.Fields

public protocol CountryFields: Fields where Model == Country.Identified {}

// MARK: -
extension IDFields: CountryFields where Model == Country.Identified {}
