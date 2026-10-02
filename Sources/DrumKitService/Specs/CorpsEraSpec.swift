// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.CorpsEra
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol CorpsEraSpec {}

// MARK: -
public extension CorpsEraSpec where
	Self: Storage & ResultProviding,
	Error == StorageError {
	func listCorpsEras<ListFields: CorpsEraFields & Fields<CorpsEra.Identified> & Decodable>() async -> Results<ListFields> {
		await fetch()
	}
}
