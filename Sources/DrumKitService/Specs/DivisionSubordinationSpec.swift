// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.DivisionSubordination
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol DivisionSubordinationSpec {}

// MARK: -
public extension DivisionSubordinationSpec where
	Self: Storage & ResultProviding,
	Error == StorageError {
	func listDivisionSubordinations<ListFields: DivisionSubordinationFields & Fields<DivisionSubordination.Identified> & Decodable>() async -> Results<ListFields> {
		await fetch()
	}
}
