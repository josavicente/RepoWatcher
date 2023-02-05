//
//  SingleRepoWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Sean Allen on 8/16/22.
//

import WidgetKit
import SwiftUI

struct SingleRepoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }

    func getSnapshot(for configuration: SelectSingleRepoIntent, in context: Context, completion: @escaping (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }

    func getTimeline(for configuration: SelectSingleRepoIntent, in context: Context, completion: @escaping (Timeline<SingleRepoEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

            do {
                // Get Repo
                let repoToShow = RepoURL.prefix + configuration.repo!
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()

                if context.family == .systemLarge {
                    // Get Contributors
                    let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")

                    // Filter to just the top 4
                    var topFour = Array(contributors.prefix(4))

                    // Download top four avatars
                    for i in topFour.indices {
                        let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                        topFour[i].avatarData = avatarData ?? Data()
                    }

                    repo.contributors = topFour
                }

                // Create Entry & Timeline
                let entry = SingleRepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct SingleRepoEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                ContributorMediumView(repo: entry.repo)
            }
        case .accessoryInline:
            Text("\(entry.repo.name) - \(entry.repo.daysSinceLastActivity) days")
        case .accessoryCircular:
            ZStack{
                AccessoryWidgetBackground()
                VStack{
                    Text("\(entry.repo.daysSinceLastActivity)")
                        .font(.headline)
                    Text("days")
                        .font(.caption)
                }
            }
            
        case .accessoryRectangular:
            VStack(alignment: .leading){
                Text("\(entry.repo.name)")
                    .font(.headline)
                Text("\(entry.repo.daysSinceLastActivity) days")
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    Text("\(entry.repo.watchers)")
                    
                    Image(systemName: "tuningfork")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    Text("\(entry.repo.forks)")
                    
                    if entry.repo.hasIssues {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .aspectRatio(contentMode: .fit)
                        Text("\(entry.repo.openIssues)")
                    }
                }.font(.caption)
            }
        case .systemSmall, .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct SingleRepoWidget: Widget {
    let kind: String = "SingleRepoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectSingleRepoIntent.self, provider: SingleRepoProvider()) { entry in
            SingleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single repository")
        .supportedFamilies([.systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct SingleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        SingleRepoEntryView(entry: SingleRepoEntry(date: Date(), repo: MockData.repoOne))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
