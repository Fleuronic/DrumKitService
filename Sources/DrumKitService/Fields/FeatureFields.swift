// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Feature
import struct Catena.IDFields
import protocol Catena.Fields

public protocol FeatureFields: Fields where Model == Feature.Identified {}

// MARK: -
extension IDFields: FeatureFields where Model == Feature.Identified {}
