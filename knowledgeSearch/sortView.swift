import  SwiftUI

struct sortView: View {
    @Binding var isShowMenu: Bool
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        isShowMenu = false
                    }
                }, label: {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                })
            }
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .offset(x: 0, y: isShowMenu ? 0 : 300)
        }
    }
}

struct MenuViewWithinSafeArea: View {
    @EnvironmentObject var communication:Communication
    @Binding var isShowMenu: Bool
    let bottomSafeAreaInsets: CGFloat
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isShowMenu = false
                                }
                            }, label: {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .padding()
                            })
                        }
                        ScrollView{
                            if var facet = communication.facet{
                                Text("業種（大分類）")
                                ForEach(facet.industry_large_facets ?? []) { facet in
                                    HStack{
                                        Button(
                                            action: {
                                                communication.start = 0
                                                communication.selectedlarge.append(facet.name)
                                                communication.get_facet(facetlarge:communication.selectedlarge,facetmed:communication.selectedmed)
                                                communication.searchfacet(facetlarge:communication.selectedlarge,facetmed:communication.selectedmed)
                                            }){
                                            Text(facet.name+"(\(facet.count))")
                                        }
                                        Spacer()
                                    }
                                }
                                Text("業種（中分類）")
                                ForEach(facet.industry_medium_facets ?? []) { facet in
                                    HStack{
                                        Button(
                                            action: {
                                                communication.start = 0
                                                communication.selectedmed.append(facet.name)
                                                communication.get_facet(facetlarge:communication.selectedlarge,facetmed:communication.selectedmed)
                                                communication.searchfacet(facetlarge:communication.selectedlarge,facetmed:communication.selectedmed)
                                            }){
                                            Text(facet.name+"(\(facet.count))")
                                        }
                                        Spacer()
                                    }
                                }
                                }else{
                                    Button(
                                        action: {
                                        }){
                                        Text("on")
                                    }
                            }
                        }
                    }
                }
            }
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .offset(x: 0, y: isShowMenu ? 0 : geometry.size.height)
            // safe area外のコンテンツ
            Rectangle()
                .foregroundColor(Color.red.opacity(0.8))
                .frame(height: bottomSafeAreaInsets)
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: 0, y: isShowMenu ? 0 : geometry.size.height)
        }
    }
}
