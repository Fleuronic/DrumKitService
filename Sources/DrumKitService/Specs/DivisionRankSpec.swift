// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.DivisionRank
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol DivisionRankSpec {
	associatedtype DivisionRankList: Scoped<DivisionRankListFields>

	associatedtype DivisionRankListFields: DivisionRankFields

	func listDivisionRanks() async -> DivisionRankList
}

// MARK: -
public extension DivisionRankSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	DivisionRankListFields: Fields<DivisionRank.Identified> & Decodable {
	func listDivisionRanks() async -> Results<DivisionRankListFields> {
		await fetch()
	}
}
