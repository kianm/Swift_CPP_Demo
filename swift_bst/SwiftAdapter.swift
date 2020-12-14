//
//  SAdapter.swift
//  swift_cl
//
//  Created by Kian on 2020-10-26.
//

import Foundation

class Map {

    typealias forEachType = (String, String) -> ()

    struct Callback {
        var listener: forEachType?
    }

    @Protected
    private var safeCallback = Callback()

    let map: UnsafeMutableRawPointer!

    init() {
        map = map_create()
    }

    deinit {
        map_delete(map)
    }

    func add(key: String, value: String) {
        map_add(key.cString(using: .utf8), value.cString(using: .utf8), map)
    }

    func remove(key: String) {
        map_remove(key.cString(using: .utf8), map)
    }

    subscript(key: String) -> String? {
        return String(cString: map_get(key.cString(using: .utf8), map))
    }

    func forEach(callback: @escaping forEachType) {

        $safeCallback.write { state in
            state.listener = callback
        }

        var mps: map_struct =  map_struct(owner: Unmanaged.passUnretained(self).toOpaque(),
                                          p_map: map) {
            (key: UnsafePointer<Int8>?, value: UnsafePointer<Int8>?, owner: UnsafeMutableRawPointer?) in
            guard let owner = owner, let cvalue = value, let ckey = key else {
                return
            }
            let instance = Unmanaged<Map>.fromOpaque(owner).takeUnretainedValue()
            let key = String(cString: ckey)
            let value = String(cString: cvalue)
            instance.notifyListener(key: key, value: value)
        }
        map_iterate(&mps)
    }

    private func notifyListener(key: String, value: String) {

        $safeCallback.read { state in
            let listener = state.listener
            listener?(key, value)
        }
    }
}
