// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Show
import protocol Catena.Scoped

public protocol ShowSpec {
	associatedtype ShowFetch: Scoped<ShowFetchFields>

	associatedtype ShowFetchFields: ShowFields

	func fetchShow(named name: String) async -> ShowFetch
}
