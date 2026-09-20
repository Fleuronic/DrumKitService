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
import struct DrumKit.Division
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Catenoid.Database
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

	func listSlots(placedInEventsWith eventIDs: Set<Event.ID>) async -> Results<SlotListFields> {
		await fetch(where: Slot.Identified.predicate(placedInEventsWith: eventIDs))
	}

	func listSlots(placedInEventsWith eventIDs: Set<Event.ID>, forCorpsWith corpsIDs: Set<Corps.ID>) async -> Results<SlotListFields> {
		await fetch(
			where: Slot.Identified.predicate(
				eventIDs: eventIDs,
				corpsIDs: corpsIDs
			)
		)
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

// MARK: -
public extension SlotSpec where
	Self: Catenoid.Database & ResultProviding,
	Store == PersistDB.Store<ReadWrite>,
	Error == Never,
	SlotListFields: Fields<Slot.Identified> & Decodable {
	func countDivisions(
		scoredIn year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = []
	) async -> SingleResult<Int> {		await countDistinct(
			\Slot.Identified.performance.placement.division.id,
			where: Slot.Identified.predicate(
				divisionedIn: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			)
		)
	}

	/// Every placed slot that season for the given corps.
	func listSlots(
		placedIn year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		forCorpsWith corpsIDs: Set<Corps.ID>
	) async -> Results<SlotListFields> {
		await fetch(
			where: Slot.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations,
				corpsIDs: corpsIDs
			)
		)
	}

	/// Whether anything placed in the given division that season.
	func containsSlot(
		placedIn year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		inDivisionWith divisionID: Division.ID
	) async -> SingleResult<Bool> {
		let results: Results<SlotListFields> = await fetch(
			where: Slot.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations,
				divisionID: divisionID
			),
			limit: 1
		)

		return results.map { !$0.isEmpty }
	}

	/// The latest-dated slot that season which placed in the given division.
	func fetchLatestSlot(
		placedIn year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		inDivisionWith divisionID: Division.ID
	) async -> SingleResult<SlotListFields?> {
		let results: Results<SlotListFields> = await fetch(
			where: Slot.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations,
				divisionID: divisionID
			),
			sortedBy: \.event.value.date,
			ascending: false,
			limit: 1
		)

		return results.map(\.first)
	}
}
