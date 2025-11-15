//
//  CalendarView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()

    var body: some View {
        NavigationStack {
            VStack {
                header
                dayLabels
                monthGrid
                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
        }
    }

    // MARK: - Header with month + arrows
    private var header: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(currentDate.formatted(.dateTime.year().month()))
                .font(.title2.bold())

            Spacer()

            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Weekday labels
    private var dayLabels: some View {
        let weekdays = Calendar.current.shortWeekdaySymbols

        return HStack {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Grid of days
    private var monthGrid: some View {
        let days = generateDays(for: currentDate)

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(days, id: \.self) { date in
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.body)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .padding(6)
                    .background(isToday(date) ? Color.blue.opacity(0.2) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }

    // MARK: - Date Helpers
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    private func generateDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }
        
        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: date)
        let weeks = weekRange?.count ?? 5   // most months fit in 5 rows
        
        return (0..<(weeks * 7)).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: firstWeek.start)
        }
    }

}
