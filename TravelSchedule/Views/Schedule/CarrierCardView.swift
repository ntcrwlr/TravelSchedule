import SwiftUI
import UIKit

struct CarrierCardView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 8) {
                CarrierAvatar(url: trip.logoURL, name: trip.carrierName)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(trip.carrierName)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(AppColor.black)
                            .lineLimit(1)
                        Spacer(minLength: 8)
                        Text(trip.dateText)
                            .font(.system(size: 12))
                            .foregroundStyle(AppColor.black)
                    }

                    if let transferText = trip.transferText {
                        Text(transferText)
                            .font(.system(size: 12))
                            .foregroundStyle(AppColor.red)
                            .lineLimit(2)
                    }
                }
            }

            HStack(alignment: .center, spacing: 8) {
                Text(trip.departureTime)
                    .font(.system(size: 17))
                    .foregroundStyle(AppColor.black)

                ZStack {
                    Rectangle()
                        .fill(AppColor.gray.opacity(0.5))
                        .frame(height: 1)
                    Text(trip.durationText)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColor.gray)
                        .padding(.horizontal, 8)
                        .background(AppColor.card)
                }

                Text(trip.arrivalTime)
                    .font(.system(size: 17))
                    .foregroundStyle(AppColor.black)
            }
        }
        .padding(14)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

private struct CarrierAvatar: View {
    let url: URL?
    let name: String
    @State private var image: UIImage?

    var body: some View {
        let currentImage = image
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.white)
            Text(String(name.prefix(1)).uppercased())
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppColor.blue)
                .hiddenWhen(currentImage != nil)
            Image(uiImage: currentImage ?? UIImage())
                .resizable()
                .scaledToFit()
                .padding(4)
                .hiddenWhen(currentImage == nil)
        }
        .frame(width: 38, height: 38)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .task(id: url) {
            guard let url else {
                image = nil
                return
            }
            image = await CarrierImageCache.shared.loadImage(from: url)
        }
    }
}
