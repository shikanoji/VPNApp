//
//  ArrayExtension.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 09/03/2022.
//

extension Array {
    func getPosition(_ i: Int) -> PositionItemCell {
        let count = self.count
        if count == 0 || count == 1  {
            return .all
        } else if count - 1 == i {
            return .bot
        } else if i == 0 && count > 1 {
            return .top
        } else {
            return .middle
        }
    }
}

func getPosition<T: Equatable>(item: T, arr: [T]) -> PositionItemCell {
    if arr.count > 0, let index = arr.firstIndex(of: item) {
        return arr.getPosition(index)
    }
    return .all
}
