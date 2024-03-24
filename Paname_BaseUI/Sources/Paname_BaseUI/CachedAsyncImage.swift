import SwiftUI
import CacheManager

public struct CachedAsyncImage: View {
    @State private var cacheImage: Image?
    private unowned var imageCache: ViewCache<Image>
    private var urlStr: String
    
    public init(imageCache: ViewCache<Image>,
                urlStr: String) {
        self.imageCache = imageCache
        self.urlStr = urlStr
    }
    
    public var body: some View {
        Group {
            if let image = self.cacheImage {
                image
            } else {
                AsyncImage(url: URL(string: self.urlStr)) { phase in
                    switch phase {
                    case .success(let image):
                        setInCache(image)
                    default: EmptyView()
                    }
                }
            }
        }
        .task {
            if let cachImage = try? await self.imageCache.getValue(for: self.urlStr) {
                self.cacheImage = cachImage
            }
        }
    }
    
    @MainActor
    private func setInCache(_ image: Image) -> Image {
        Task {
            await self.imageCache.setValue(data: image.resizable(), for: self.urlStr)
        }
        return image.resizable()
    }
}
