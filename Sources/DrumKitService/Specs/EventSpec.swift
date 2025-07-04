// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Event
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol EventSpec {
	associatedtype EventList: Scoped<EventListFields>

	associatedtype EventListFields: EventFields

	func listEvents() async -> EventList
}

// MARK: -
public extension EventSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	EventListFields: Fields<Event.Identified> & Decodable {
	func listEvents() async -> Results<EventListFields> {
		await fetch()
	}
}
