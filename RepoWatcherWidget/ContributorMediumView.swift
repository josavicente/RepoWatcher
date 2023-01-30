//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Josafat Vicente Pérez on 30/1/23.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    let repo: Repository
    var body: some View {
        VStack{
            HStack{
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20, alignment: .leading), count: 2)) {
                ForEach(repo.contributors){ contributor in
                    HStack{
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            //if repo.contributors.count < 3 {
                Spacer()
            //}
        }.padding()
    }
}

struct ContributorMediumView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorMediumView(repo: MockData.repoOne)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
