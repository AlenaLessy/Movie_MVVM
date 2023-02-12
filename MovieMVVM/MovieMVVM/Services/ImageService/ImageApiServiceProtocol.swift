// ImageApiServiceProtocol.swift
// Copyright © KarpovaAV. All rights reserved.

import UIKit

/// Протокол для скачивания фото из интернета
protocol ImageApiServiceProtocol {
    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?)
}
