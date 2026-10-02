// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.DivisionRank
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol DivisionRankSpec {}

// MARK: -
public extension DivisionRankSpec where
	Self: Storage & ResultProviding,
	Error == StorageError {
	func listDivisionRanks<ListFields: DivisionRankFields & Fields<DivisionRank.Identified> & Decodable>() async -> Results<ListFields> {
		await fetch()
	}
}
