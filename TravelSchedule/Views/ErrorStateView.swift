import SwiftUI

struct ErrorStateView: View {
    let error: AppLoadError?

    var body: some View {
        VStack(spacing: 16) {
            Image(error?.imageName ?? "Server Error")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)

            Text(error?.title ?? AppStrings.serverError)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColor.text)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .hiddenWhen(error == nil)
        .allowsHitTesting(error != nil)
    }
}

#Preview("Нет интернета") {
    ErrorStateView(error: .noInternet)
}

#Preview("Ошибка сервера") {
    ErrorStateView(error: .server)
}
