import SwiftUI

struct CarrierDetailsView: View {
    var body: some View {
        Text(AppStrings.carrierInfo)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(AppColor.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .appErrorOverlay()
            .navigationTitle(AppStrings.carrierInfo)
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
