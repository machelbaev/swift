//
//  Enums.swift
//  TaskTracker
//
//  Created by Mikhail on 02.02.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

enum TaskType {
    case new, existed
}

enum TaskStatus: String {
    case inProgress = "В процессе"
    case new = "Новые"
    case completed = "Выполнено"
}
