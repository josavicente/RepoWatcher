//
//  WidgetBundle.swift
//  RepoWatcherWidgetExtension
//
//  Created by Sean Allen on 8/16/22.
//

import SwiftUI
import WidgetKit

@main
struct RepoWatcherWidgets: WidgetBundle {
    var body: some Widget {
        SingleRepoWidget()
        DoubleRepoWidget()
    }
}
