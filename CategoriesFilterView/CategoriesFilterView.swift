import SwiftUI

struct CategoriesFilterView: View {
    @Binding var categories: [Category]
    let onValidatePressed: () -> Void
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100))
                ]) {
                    ForEach(Category.allCases.filter({ $0 != .gratuit }), id: \.id) { category in
                        CategoryView(category: category, categoryMode: .clickable(isAlreadyPressed: categories.contains(category), onPressed: { isPressed in
                            if isPressed {
                                if !categories.contains(category) {
                                    categories.append(category)
                                }
                            } else {
                                if let index = categories.firstIndex(where: { $0 == category }) {
                                    categories.remove(at: index)
                                }
                            }
                        }))
                    }
                }
                .padding(.top, 32)
            }
            .scrollDisabled(true)
            Spacer()
            Text("Valider")
                .font(.system(size: 14, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color("Wwhite"))
                .padding(.vertical, 12)
                .background(content: {
                    Color("AccentColor")
                })
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                
                .onTapGesture {
                    self.onValidatePressed()
                }
        }
                .background {
            Color("Wwhite")
                .ignoresSafeArea()
        }
    }
}
