import SwiftUI

struct CarrierDetailsView: View {
    var body: some View {
        Text("Информация о перевозчике")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(AppColor.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .appErrorOverlay()
            .navigationTitle("Информация о перевозчике")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(AppColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColor.text)
    }
}

#Preview {
    NavigationStack {
        CarrierDetailsView()
    }
}
