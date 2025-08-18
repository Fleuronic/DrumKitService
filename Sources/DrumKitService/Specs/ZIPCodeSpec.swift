// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.ZIPCode
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol ZIPCodeSpec {
	associatedtype ZIPCodeFetch: Scoped<ZIPCodeFetchFields>

	associatedtype ZIPCodeFetchFields: ZIPCodeFields

	func fetchZIPCode(with code: String) async -> ZIPCodeFetch
}

// MARK: -
public extension ZIPCodeSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	ZIPCodeFetchFields: Fields<ZIPCode.Identified> & Decodable {
	func fetchZIPCode(with code: String) async -> SingleResult<ZIPCodeFetchFields?> {
		let results: Results<ZIPCodeFetchFields> = await fetch(
			where: ZIPCode.Identified.predicate(code: code)
		)

		return results.map(\.first)
	}
}
