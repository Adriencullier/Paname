import SwiftUI

public struct PlainRoundedButtonStyle: ButtonStyle {
    var verticalPadding: CGFloat
    var bgColor: PColor
    var borderColor: PColor
    var borderSize: CGFloat
    
    public init(bgColor: PColor = .accentColor,
                borderColor: PColor = .accentColor,
                borderSize: CGFloat = 0,
                verticalPadding: CGFloat = 12) {
        self.bgColor = bgColor
        self.borderColor = borderColor
        self.borderSize = borderSize
        self.verticalPadding = verticalPadding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .padding(.vertical, self.verticalPadding)
            Spacer()
        }
        .background(self.bgColor.color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(self.borderColor.color, lineWidth: self.borderSize)
        }
    }
}
