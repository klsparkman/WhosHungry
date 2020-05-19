//
//  SwipeableCardViewDataSource.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 5/18/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

protocol SwipeableCardViewDataSource: class {
    func numberOfCards() -> Int
    func card(forItemAtIndex indes: Int)
    func viewForEmptyCards() -> UIView?
}
