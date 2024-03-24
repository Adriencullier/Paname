import SwiftUI

public struct PText: View {
    var text: String
    var font: Font
    var textColor: PColor
    var lineLimit: Int
    
    public init(text: String,
                font: Font,
                textColor: PColor = .black, lineLimit: Int = 0) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.lineLimit = lineLimit
    }
    
    public var body: some View {
        Text(self.text)
            .font(font)
            .foregroundStyle(textColor.color)
            .lineLimit(lineLimit)
    }
}
