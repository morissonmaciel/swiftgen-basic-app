//
//  ReaderScene.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 10/01/23.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ReaderScene: View {
    private let defaultSpacing = 24.0
    var readerData: ReaderDataModel
    
    @StateObject var viewModel = ReaderViewModel.shared
    @State var textContents = ""
    @State var previewImage = UIImage()
    @State var isLoadingImage = true
    @State var isLoadingContents = true
    
    var body: some View {
        ScrollView {
            if let imageSource = URL(string: readerData.previewImage ?? "") {
                GeometryReader { geo in
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.frame(in: .global).width, height: 220)
                        .clipped()
                        .background(Color.secondary.opacity(0.8))
                        .overlay(
                            VStack {
                                if isLoadingImage {
                                    ActivityIndicator(isAnimating: $isLoadingImage, style: .large)
                                }
                            }
                        )
                        .onAppear {
                            URLSession.shared.dataTask(with: URLRequest(url: imageSource)) { data, _, _ in
                                guard let data = data, let image = UIImage(data: data) else {
                                    isLoadingImage = false
                                    return
                                }
                                
                                previewImage = image
                                isLoadingImage = false
                            }.resume()
                        }
                }
            }
            
            VStack(alignment: .leading, spacing: defaultSpacing) {
                Text(readerData.title)
                    .font(.system(.title, design: .serif))
                    .fixedSize(horizontal: false, vertical:true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, readerData.previewImage != nil ? 220 : 0)
                
                if isLoadingContents {
                    HStack {
                        ActivityIndicator(isAnimating: $isLoadingContents, style: .large)
                    }.frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text(textContents)
                        .font(.system(.body, design: .serif))
                        .fixedSize(horizontal: false, vertical:true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, defaultSpacing)
            .padding(.vertical, defaultSpacing / 2)
        }
        .onAppear {
            viewModel.extractArticleContents(for: readerData.sourceURL) { result in
                guard case .success(let contents) = result else {
                    isLoadingContents = false
                    return
                }
                
                textContents = contents
                isLoadingContents = false
            }
        }
        .navigationBarItems(trailing: Group {
            if viewModel.isSpeeching  {
                Button {
                    viewModel.stopSpeech()
                } label: {
                    Image(systemName: "stop.fill")
                        .imageScale(.medium)
                }
            } else {
                Button {
                    viewModel.reproduceSpeech([readerData.title, textContents])
                } label: {
                    Image(systemName: "speaker.wave.3")
                        .imageScale(.medium)
                }
            }
        })
    }
}

#if DEBUG

struct ReaderScene_Previews: PreviewProvider {
    static let model = ReaderDataModel(title: "China’s Tianwen-1 Mars orbiter and rover appear to be in trouble - SpaceNews", sourceURL: URL(string: "https://spacenews.com/chinas-tianwen-1-mars-orbiter-and-rover-appear-to-be-in-trouble/")!, publishedAt: "2023-01-09T12:10:18Z", previewImage: "https://spacenews.com/wp-content/uploads/2021/07/zhurong-backshell-parachute-inspection-CNSA-PEC-15july2021-1.jpg")
    
    static var previews: some View {
        ReaderScene(readerData: Self.model)
    }
}

#endif
