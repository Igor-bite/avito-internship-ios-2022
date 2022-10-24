//
//  UserAvatarGenerator.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 21.10.2022.
//

import UIKit

final class UserAvatarGenerator {
    private enum Constants {
        enum Font {
            static let fontSizePart: CGFloat = 2 / 3
            static let font = FontFamily.Lato.semiBold
        }
    }

    static func generateUserImage(userName: String, withSize size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { ctx in
            let imageSize = ctx.currentImage.size

            UIColor.generateColorFor(text: userName).setFill()
            ctx.fill(CGRect(origin: .zero, size: imageSize))

            let font = Constants.Font.font.font(size: size.height * Constants.Font.fontSizePart)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white
            ]

            let attributedString = NSAttributedString(
                string: String(userName.prefix(1)).uppercased(),
                attributes: attrs
            )

            let fontHeight = font.lineHeight
            let yOffset = (imageSize.height - fontHeight) / 2
            let textRect = CGRect(x: 0, y: yOffset, width: imageSize.width, height: fontHeight)

            attributedString.draw(
                with: textRect.integral,
                options: .usesLineFragmentOrigin,
                context: nil
            )
        }
        return image
    }
}
