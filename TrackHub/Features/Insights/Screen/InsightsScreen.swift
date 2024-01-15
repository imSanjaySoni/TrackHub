//
//  InsightsScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import Charts
import SwiftUI

enum FilterType: String, Identifiable, CaseIterable {
    var id: Self { self }
    case week, month, year
}

struct InsightData {}

struct InsightDataSeries: Identifiable {
    let type: String
    let data: [InsightData]
    var id: String { type }
}

struct InsightsScreen: View {
    @State var selectedFilter: FilterType = .week

    var insights: [InsightDataSeries] = [.init(type: "New Followers", data: [])]

    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(FilterType.allCases) { filter in
                        Text(filter.rawValue.capitalized)
                    }
                }
                .listSectionSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .padding()
            .pickerStyle(.segmented)
            .navigationTitle("Insights")
        }
    }
}

#Preview {
    InsightsScreen()
}
