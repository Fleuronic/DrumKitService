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
import protocol Catenoid.AnonymousFields
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
	/// Which divisions were scored that season, ignoring the null-sentinel division.
	func listDivisions<Fields: Catenoid.AnonymousFields<Slot.Identified>>(
		scoredIn year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = []
	) async -> Results<Fields> {
		await fetchAnonymous(
			where: Slot.Identified.predicate(
				divisionedIn: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			)
		)
	}

	/// The event of every placed slot in the given events, one row per competitor.
	func listPlacedSlots<Fields: Catenoid.AnonymousFields<Slot.Identified>>(
		inEventsWith eventIDs: Set<Event.ID>
	) async -> Results<Fields> {
		await fetchAnonymous(
			where: Slot.Identified.predicate(placedInEventsWith: eventIDs),
			distinct: false
		)
	}

	/// How many distinct corps placed that season, optionally narrowed to one division.
	func countPlacedCorps(
		in year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		inDivisionWith divisionID: Division.ID? = nil
	) async -> SingleResult<Int> {
		var predicate = Slot.Identified.predicate(
			placedIn: year,
			includedCircuitNames: names,
			includedCircuitAbbreviations: abbreviations
		) && \Slot.Identified.performance.corps.id != Corps.ID.null

		if let divisionID {
			predicate = predicate && \Slot.Identified.performance.placement.division.id == divisionID
		}

		return await countDistinct(\Slot.Identified.performance.corps.id, where: predicate)
	}

	/// How many distinct corps had a slot in a circuited event that season, scored or not.
	func countCorps(
		in year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = []
	) async -> SingleResult<Int> {
		await countDistinct(
			\Slot.Identified.performance.corps.id,
			where: Slot.Identified.predicate(
				circuitedIn: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			) && \Slot.Identified.performance.corps.id != Corps.ID.null
		)
	}

	/// The latest-dated slot that season which placed in the given division.
	func fetchLatestSlot<Fields: Catenoid.AnonymousFields<Slot.Identified>>(
		placedIn year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		inDivisionWith divisionID: Division.ID
	) async -> SingleResult<Fields?> {
		let results: Results<Fields> = await fetchAnonymous(
			where: Slot.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations,
				divisionID: divisionID
			),
			distinct: false,
			sortedBy: \.event.value.date,
			ascending: false,
			limit: 1
		)

		return results.map(\.first)
	}
}
