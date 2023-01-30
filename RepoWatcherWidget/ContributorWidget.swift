//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Josafat Vicente Pérez on 30/1/23.
//

import WidgetKit
import SwiftUI


struct ContributorProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorEntry {
        <#code#>
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        <#code#>
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        <#code#>
    }
}

struct ContributorEntry: TimelineEntry{
    var date: Date
}

