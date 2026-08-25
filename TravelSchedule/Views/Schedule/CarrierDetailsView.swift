import SwiftUI
import UIKit

struct CarrierDetailsView: View {
    @StateObject private var viewModel: CarrierDetailsViewModel

    init(carrierCode: String) {
        _viewModel = StateObject(wrappedValue: CarrierDetailsViewModel(carrierCode: carrierCode))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.details == nil {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let details = viewModel.details {
                detailsContent(details)
            } else {
                Color.clear
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .appErrorOverlay()
        .navigationTitle(AppStrings.carrierInfo)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(AppColor.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(AppColor.text)
        .task {
            await viewModel.load()
        }
    }

    private func detailsContent(_ details: CarrierDetails) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CarrierDetailsLogo(url: details.logoURL, name: details.title)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                Text(details.title)
                    .font(AppTypography.screenTitle)
                    .foregroundStyle(AppColor.text)
                    .padding(.top, 8)

                if let email = details.email, let emailURL = details.emailURL {
                    contactBlock(
                        title: AppStrings.email,
                        value: email,
                        destination: emailURL
                    )
                } else if let website = details.website, let websiteURL = details.websiteURL {
                    contactBlock(
                        title: AppStrings.website,
                        value: website,
                        destination: websiteURL
                    )
                }

                if let phone = details.phone, let phoneURL = details.phoneURL {
                    contactBlock(
                        title: AppStrings.phone,
                        value: phone,
                        destination: phoneURL
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    private func contactBlock(title: String, value: String, destination: URL) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(AppColor.text)
            Link(value, destination: destination)
                .font(AppTypography.body)
                .foregroundStyle(AppColor.blue)
                .padding(.top, 8)
        }
        .padding(.top, 8)
    }
}

private struct CarrierDetailsLogo: View {
    let url: URL?
    let name: String
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text(String(name.prefix(1)).uppercased())
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(AppColor.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColor.card)
            }
        }
        .frame(height: 104)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .task(id: url) {
            guard let url else {
                image = nil
                return
            }
            if let cached = CarrierImageCache.shared.image(for: url) {
                image = cached
                return
            }
            image = await CarrierImageCache.shared.image(from: url)
        }
    }
}

#Preview {
    NavigationStack {
        CarrierDetailsView(carrierCode: "112")
    }
}
