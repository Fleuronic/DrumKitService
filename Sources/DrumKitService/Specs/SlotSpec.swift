// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB
import struct DrumKit.Slot
import struct DrumKit.Event
import struct DrumKit.Performance
import struct DrumKit.Feature
import struct DrumKit.Corps
import struct DrumKit.Ensemble
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol SlotSpec {
	associatedtype SlotList: Scoped<SlotListFields>

	associatedtype SlotListFields: SlotFields

	func listSlots(in year: Int) async -> SlotList
	func fetchSlots(inEventWith eventID: Event.ID, forPerformanceByCorpsWith corpsID: Corps.ID?, ensembleWith ensembleID: Ensemble.ID?) async -> SlotList
}

// MARK: -
public extension SlotSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	SlotListFields: Fields<Slot.Identified> & Decodable {
	func listSlots(in year: Int) async -> Results<SlotListFields> {
		await fetch(where: Slot.Identified.predicate(year: year))
	}

	func fetchSlots(inEventWith eventID: Event.ID, forPerformanceByCorpsWith corpsID: Corps.ID?, ensembleWith ensembleID: Ensemble.ID?) async -> Results<SlotListFields> {
		await fetch(
			where: Slot.Identified.predicate(
				eventID: eventID,
				corpsID: corpsID,
				ensembleID: ensembleID
			)
		)
	}
}
