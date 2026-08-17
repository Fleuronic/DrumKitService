// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB
import Identity
import Foundation
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
	func listSlots(inEventWith detailsURL: URL) async -> SlotList
	func listSlots(inEventsWith eventIDs: Set<Event.ID>) async -> SlotList
}

// MARK: -
public extension SlotSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	SlotListFields: Fields<Slot.Identified> & Decodable {
	func listSlots(in year: Int) async -> Results<SlotListFields> {
		await fetch(where: Slot.Identified.predicate(year: year))
	}

	func listSlots(inEventWith detailsURL: URL) async -> Results<SlotListFields> {
		await fetch(where: Slot.Identified.predicate(eventDetailsURL: detailsURL))
	}

	func listSlots(inEventsWith eventIDs: Set<Event.ID>) async -> Results<SlotListFields> {
		await fetch(where: Slot.Identified.predicate(eventIDs: eventIDs))
	}

	func listSlots(inEventsWith eventIDs: Set<Event.ID>, maxRank: Int) async -> Results<SlotListFields> {
		await fetch(where: Slot.Identified.predicate(eventIDs: eventIDs, maxRank: maxRank))
	}

	func listSlots(inEventWith eventID: Event.ID, forPerformanceByCorpsWith corpsID: Corps.ID?, ensembleWith ensembleID: Ensemble.ID?) async -> Results<SlotListFields> {
		await fetch(
			where: Slot.Identified.predicate(
				eventID: eventID,
				corpsID: corpsID,
				ensembleID: ensembleID
			)
		)
	}
}
