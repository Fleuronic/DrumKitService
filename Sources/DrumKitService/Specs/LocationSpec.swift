// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Location
import protocol Catena.Scoped

public protocol LocationSpec {
	associatedtype LocationFetch: Scoped<LocationFetchFields>

	associatedtype LocationFetchFields: LocationFields

	func fetchLocation(
		city: String, 
		state: String
	) async -> LocationFetch
}
