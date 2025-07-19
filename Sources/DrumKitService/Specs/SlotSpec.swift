// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB
import struct DrumKit.Slot
import struct DrumKit.Event
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol SlotSpec {
	associatedtype SlotList: Scoped<SlotListFields>

	associatedtype SlotListFields: SlotFields

	func listSlots() async -> SlotList
	func listSlots(inEventWith id: Event.ID) async -> SlotList
}

// MARK: -
public extension SlotSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	SlotListFields: Fields<Slot.Identified> & Decodable {
	func listSlots() async -> Results<SlotListFields> {
		await fetch()
	}

	func listSlots(inEventWith id: Event.ID) async -> Results<SlotListFields> {
		await fetch(where: \.event.id == id)
	}
}
