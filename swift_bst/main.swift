//
//  main.swift
//  swift_cl
//
//  Created by Kian on 2020-10-26.
//

import Foundation

class BinarySearchTreeTest {

    private let smap = Map()
    private var count = 0
    @Protected
    private var keyValuePairs: [(String, String)] = []

    func generateKeyValuePairs() {
        let N = 100_000
        keyValuePairs.removeAll()
        DispatchQueue.global().sync {
            DispatchQueue.concurrentPerform(iterations: N) { index in
                $keyValuePairs.write { pairs in
                    pairs.append((UUID().uuidString, UUID().uuidString))
                }
            }
        }
    }

    func addKeyValuesToMap() {
        DispatchQueue.global().sync {
            DispatchQueue.concurrentPerform(iterations: keyValuePairs.count) { index in
                $keyValuePairs.read { pairs in
                    self.smap.add(key: pairs[index].0, value: pairs[index].1)
                }
            }
        }
    }
    func countRetrievedPairs() -> Int {
        smap.forEach { [unowned self] (key: String, value: String)  in
            self.count += 1
        }
        return count
    }
}

autoreleasepool{
    let bstTest = BinarySearchTreeTest()
    bstTest.generateKeyValuePairs()
    bstTest.addKeyValuesToMap()
    let count = bstTest.countRetrievedPairs()
    print("number of pairs \(count)")
}
