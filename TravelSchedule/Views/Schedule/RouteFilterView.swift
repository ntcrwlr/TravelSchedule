import SwiftUI

struct RouteFilterView: View {
    let onApply: (ScheduleFilters) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var draft: ScheduleFilters

    init(filters: ScheduleFilters, onApply: @escaping (ScheduleFilters) -> Void) {
        self.onApply = onApply
        _draft = State(initialValue: filters)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            timeSection
            transfersSection
            Spacer()
            applyButton
                .opacity(draft.isActive ? 1 : 0)
                .disabled(!draft.isActive)
                .accessibilityHidden(!draft.isActive)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(AppColor.background)
        .appErrorOverlay()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(AppColor.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(AppColor.text)
    }

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.departureTime)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColor.text)

            ForEach(DepartureTimeSlot.allCases, id: \.self) { slot in
                Button {
                    toggle(slot)
                } label: {
                    HStack {
                        Text(slot.title)
                            .font(.system(size: 17))
                            .foregroundStyle(AppColor.text)
                        Spacer()
                        FilterCheckbox(isOn: draft.departureTimes.contains(slot))
                    }
                    .frame(height: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var transfersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.showTransfers)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColor.text)

            transferRow(title: AppStrings.yes, value: true)
            transferRow(title: AppStrings.no, value: false)
        }
    }

    private func transferRow(title: String, value: Bool) -> some View {
        Button {
            draft.showTransfers = draft.showTransfers == value ? nil : value
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(AppColor.text)
                Spacer()
                FilterRadio(isOn: draft.showTransfers == value)
            }
            .frame(height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var applyButton: some View {
        Button {
            onApply(draft)
            dismiss()
        } label: {
            Text(AppStrings.apply)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(AppColor.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(AppColor.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private func toggle(_ slot: DepartureTimeSlot) {
        if draft.departureTimes.contains(slot) {
            draft.departureTimes.remove(slot)
        } else {
            draft.departureTimes.insert(slot)
        }
    }
}

private struct FilterCheckbox: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(AppColor.text, lineWidth: 2)
                .frame(width: 24, height: 24)
            RoundedRectangle(cornerRadius: 6)
                .fill(AppColor.text)
                .frame(width: 24, height: 24)
                .opacity(isOn ? 1 : 0)
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(AppColor.background)
                .opacity(isOn ? 1 : 0)
        }
    }
}

private struct FilterRadio: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColor.text, lineWidth: 2)
                .frame(width: 24, height: 24)
            Circle()
                .fill(AppColor.text)
                .frame(width: 10, height: 10)
                .opacity(isOn ? 1 : 0)
        }
    }
}

#Preview {
    NavigationStack {
        RouteFilterView(filters: ScheduleFilters()) { _ in }
    }
}
