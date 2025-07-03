// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Venue
import struct Catena.IDFields
import protocol Catena.Fields

public protocol VenueFields: Fields where Model == Venue.Identified {}

// MARK: -
extension IDFields: VenueFields where Model == Venue.Identified {}
