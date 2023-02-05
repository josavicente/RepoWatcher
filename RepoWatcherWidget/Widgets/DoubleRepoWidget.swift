//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Sean Allen on 8/11/22.
//

import WidgetKit
import SwiftUI

struct DoubleRepoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DoubleRepoEntry {
        DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping (DoubleRepoEntry) -> Void) {
        let entry = DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    func getTimeline(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping (Timeline<DoubleRepoEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

            do {
                // Get Top Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.prefix + configuration.topRepo!)
                let topAvatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = topAvatarImageData ?? Data()

                // Get Bottom Repo
                var bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.prefix + configuration.bottomRepo!)
                let bottomAvatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                bottomRepo.avatarData = bottomAvatarImageData ?? Data()

                // Create Entry & Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct DoubleRepoEntry: TimelineEntry {
    let date: Date
    let topRepo: Repository
    let bottomRepo: Repository
}

struct DoubleRepoEntryView : View {
    var entry: DoubleRepoEntry

    var body: some View {
        VStack(spacing: 36) {
            RepoMediumView(repo: entry.topRepo)
            RepoMediumView(repo: entry.bottomRepo)
        }
    }
}

struct DoubleRepoWidget: Widget {
    let kind: String = "DoubleRepoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectTwoReposIntent.self, provider: DoubleRepoProvider()) { entry in
            DoubleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye two GitHub repositories.")
        .supportedFamilies([.systemLarge])
    }
}

struct CompactRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        DoubleRepoEntryView(entry: DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
