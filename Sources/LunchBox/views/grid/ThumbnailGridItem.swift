//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 2/8/24.
//

import SwiftUI

public enum GridItemAction {
    case Route(any Hashable)
    case Action(()-> Void)
}

public struct ThumbnailGridData {
    
    public let title: String
    public let action: GridItemAction
    public let image: ParselableImage
    public let tagDatas: [TagData]
    public let buttonData: ParselableButtonData
    public let menuButtons: [ParselableButtonData]
}

#if DEBUG
public extension ThumbnailGridData {
    static func testGrid() -> ThumbnailGridData {
        return ThumbnailGridData(title: GenericFaker.words(15),
                                 action: GridItemAction.Action({
            
        }),
                                 image: ParselableImage(systemImage: ParselableSystemImage("", color: nil)),
                                 tagDatas: [TagData.Audio],
                                 buttonData: ParselableButtonData(text: "Favorite", systemImage: "star", mainColor: .white, activatedColor: .yellow, activatedSystemImage: "star.fill", action: {
            return Bool.random()
        }),
                                 menuButtons: [
                                    ParselableButtonData(text: "Delete", systemImage: "trash", mainColor: .red, action: {
                                        return false
                                    })
                                 ])
    }
}

struct TestBuilder : GridItemBuilder {
    func gridItem() async -> ThumbnailGridData {
//        try? await Task.sleep(nanoseconds: 2.nano())
        return ThumbnailGridData.testGrid()
    }
}

struct LoadingTestBuilder : GridItemBuilder {
    func gridItem() async -> ThumbnailGridData {
        try? await Task.sleep(nanoseconds: 300.nano())
        return ThumbnailGridData.testGrid()
    }
}
#endif

public struct TagData {
    public let tagName: LocalizedStringKey
    public let image: String
    public let color: Color
    public var textColor: Color = .white
    
    public static var Audio = TagData(tagName: "Audio", image: "headphones", color: .red)
    public static var Video = TagData(tagName: "Video", image: "video", color: .blue)
    public static var Link = TagData(tagName: "Link", image: "globe", color: .green)
    
    public var toView: some View {
        Label(tagName, systemImage: image)
            .foregroundStyle(textColor)
            .font(.system(size: 12, weight: .bold))
            .lineLimit(1)
            .horPadding(8)
            .vertPadding(2)
            .background(RoundedRectangle(cornerRadius: 4).fill(color.gradient))
    }
}

protocol GridItemBuilder {
    func gridItem() async -> ThumbnailGridData
}

public struct ThumbnailGridItem: View {
    
    let itemBuilder: any GridItemBuilder
    
    @State private var gridData: ThumbnailGridData? = nil
    @State private var buttonActivated = false
    
    
    public var body: some View {
        actionableBody
            .buttonStyle(.plain)
            .safeAreaInset(edge: .bottom, spacing: 0, content: {
                HStack(spacing: 0){
                    Button(action: {
                        guard let _gridData = gridData else { return }
                        Task {
                            let activated = await _gridData.buttonData.action()
                            
                            await MainActor.run {
                                buttonActivated = activated
                            }
                        }
                    }, label: {
                            Image(systemName: buttonActivated ? gridData?.buttonData.activatedSystemImage ?? "star" : gridData?.buttonData.systemImage ?? "star")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(buttonActivated ? gridData?.buttonData.activatedColor  ?? .white : gridData?.buttonData.mainColor ?? .white)
                                .squareFrame(length: 30)
                                .redacted(reason: gridData == nil ? .placeholder : [])
                                .fullWidth()
                              
                    })
                    .buttonStyle(.plain)
                    .padding()
                    .disabled(gridData == nil)
                    
                    Divider().frame(height: 30)
                    
                    Menu(content: {
                        if let _gridData = gridData {
                            ForEach(_gridData.menuButtons, id: \.systemImage) { button in
                                button.menuButton
                            }
                        }
                    }, label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .squareFrame(length: 30)
                            .redacted(reason: gridData == nil ? .placeholder : [])
                            .fullWidth()
                  
                    })
                    .buttonStyle(.plain)
                    .disabled(gridData?.menuButtons.isEmpty == true || gridData == nil)
                    .padding()
                }
            })
            .full()
            .lunchboxGlassEffect()
            .task {
                let data = await itemBuilder.gridItem()
                withAnimation(.easeIn(duration: 3.0)) {
                    gridData = data
                }
            }
    }
    
    @ViewBuilder
    var actionableBody: some View {
        switch gridData?.action {
        case .Route(let hashable):
            NavigationLink(value: hashable, label: {
                bodyContent
            })
        case .Action(let action):
            Button(action: {
                action()
            }, label: {
                bodyContent
            })
        case .none:
            bodyContent
        }
    }
    
    var bodyContent: some View {
        VStack(spacing: 0){
            RoundedRectangle(cornerRadius: 36)
                .fill(gridData?.image.backgroundColor ?? .secondary)
                .frame(height: 120)
                .padding(.top)
            
            HStack {
                TagData.Video.toView
                
                Spacer()
            }.vertPadding(8)
                .redacted(reason: gridData == nil ? .placeholder : [])
            
            Text(gridData?.title ?? GenericFaker.words(30))
                .font(.footnote)
                .lineLimit(4, reservesSpace: true)
                .frame(width: .infinity, height: 100)
                .redacted(reason: .placeholder)

            Spacer()
        }
        .horPadding()
        .contentShape(RoundedRectangle(cornerRadius: 24))
        .hoverEffect()
    }
}

#Preview {
    let data = TestBuilder()
    
    return ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250, maximum: 250))], content: {
            ForEach(0...100, id: \.self) { _ in
                ThumbnailGridItem(itemBuilder: data)
            }
        })
    }.padding()
}

#Preview {
    return ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250, maximum: 250))], content: {
            ThumbnailGridItem(itemBuilder: TestBuilder())
            ThumbnailGridItem(itemBuilder: LoadingTestBuilder())
        })
    }.padding()
}
