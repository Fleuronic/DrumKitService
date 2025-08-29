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

	func listSlots(in year: Int) async -> SlotList
}
