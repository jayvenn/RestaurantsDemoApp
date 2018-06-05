//
//  Platform.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import Foundation

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
