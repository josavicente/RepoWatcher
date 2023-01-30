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
        ContributorEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, repo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        Task{
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            do {
                let repoToShow = RepoURL.repoMidu
               
                // get Repo
                var repo = try await NetworkManager.shared.getRepo(atURL: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                // get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atURL: repoToShow + "/contributors")
                //Filter just the top 4
                var topFour = Array(contributors.prefix(6))
                // download topfour Avatars
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                repo.contributors = topFour
                // Create entry & timeline
                let entry = ContributorEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate) )
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
            
        }
    }
}

struct ContributorEntry: TimelineEntry{
    var date: Date
    let repo: Repository
}

struct ContributorEntryView : View {
    var entry: ContributorEntry

    var body: some View {
        VStack{
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
        }

    }
    
}

struct ContributorWidget: Widget {
    let kind: String = "ContributorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            ContributorEntryView(entry: entry)
        }
        .configurationDisplayName("Contributors")
        .description("Keep track of repositories top contributors")
        .supportedFamilies([ .systemLarge])
    }
}

struct ContributorWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContributorEntryView(entry: ContributorEntry(date: Date(), repo: MockData.repoOne))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
