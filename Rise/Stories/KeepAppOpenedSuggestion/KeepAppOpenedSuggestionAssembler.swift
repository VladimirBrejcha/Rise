//  
//  KeepAppOpenedSuggestionAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 23.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class KeepAppOpenedSuggestionAssembler {
    func assemble(completion: (() -> Void)?) -> KeepAppOpenedSuggestionViewController {
        KeepAppOpenedSuggestionViewController(
            completion: completion
        )
    }
}
