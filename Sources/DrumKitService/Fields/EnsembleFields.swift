// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Ensemble
import struct Catena.IDFields
import protocol Catena.Fields

public protocol EnsembleFields: Fields where Model == Ensemble.Identified {}

// MARK: -
extension IDFields: EnsembleFields where Model == Ensemble.Identified {}
