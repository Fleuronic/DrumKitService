// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Event
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol EventSpec {
	associatedtype EventList: Scoped<EventListFields>

	associatedtype EventListFields: EventFields

	func listEvents(for year: Int) async -> EventList
}

// MARK: -
public extension EventSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	EventListFields: Fields<Event.Identified> & Decodable {
	func listEvents(for year: Int) async -> Results<EventListFields> {
		let predicate = Event.Identified.predicate(year: year)
		return await fetch(where: predicate)
	}
}
