//
//  CalendarView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.dateCreated, ascending: true)],
        animation: .default
    ) private var allNotes: FetchedResults<Note>

    @State private var selectedDate: Date? = nil
    @State private var showingNotesSheet = false

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
        .sheet(isPresented: $showingNotesSheet) {
            if let selectedDate {
                DayNotesListView(
                    date: selectedDate,
                    notes: notesFor(date: selectedDate)
                )
            }
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

    private var monthGrid: some View {
        let days = generateDays(for: currentDate)
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(days, id: \.self) { date in
                let today = isToday(date)
                let notes = notesFor(date: date)
                let hasNotes = !notes.isEmpty

                VStack(spacing: 4) {
                    // Day number
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(today ? Color.blue.opacity(0.25) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    // Notes indicator (dot)
                    if hasNotes {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                    } else {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 6, height: 6)
                    }
                }
                .onTapGesture {
                    if hasNotes {
                        selectedDate = date
                        showingNotesSheet = true
                    }
                }
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
    
    private func notesFor(date: Date) -> [Note] {
        let calendar = Calendar.current
        return allNotes.filter { note in
            if let created = note.dateCreated {
                return calendar.isDate(created, inSameDayAs: date)
            }
            return false
        }
    }
}

