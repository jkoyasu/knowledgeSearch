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
    @ObservedObject var communication = Communication()
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
                            Text("メーカー")
                            ForEach(communication.facet?.industry_large_facets ?? []) { facet in
                                HStack{
                                    Button(
                                        action: {
                                            communication.get_facet()
                                            communication.searchfacet(facetname: "industry_large_facets", facetvalue: facet.name)
                                            print(facet)
                                        }){
                                        Text(facet.name+"(\(facet.count))")
                                    }
                                    Spacer()
                                }
                            }
                            Text("部品")
                            ForEach(communication.facet?.industry_large_facets ?? []) { facet in
                                HStack{
                                    Button(
                                        action: {
                                            communication.get_facet()
                                            communication.searchfacet(facetname: "industry_large_facets", facetvalue: facet.name)
                                        }){
                                        Text(facet.name+"(\(facet.count))")
                                    }
                                    Spacer()
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
