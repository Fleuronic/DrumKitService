// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.ZIPCode
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol ZIPCodeSpec {
	associatedtype ZIPCodeList: Scoped<ZIPCodeListFields>

	associatedtype ZIPCodeListFields: ZIPCodeFields

	func listZIPCodes() async -> ZIPCodeList
}

// MARK: -
public extension ZIPCodeSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	ZIPCodeListFields: Fields<ZIPCode.Identified> & Decodable {
	func listZIPCodes() async -> Results<ZIPCodeListFields> {
		await fetch()
	}
}
