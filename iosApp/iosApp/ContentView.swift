import SwiftUI
import shared
import UIKit

//struct ContentView: View {
//	let greet = Greeting().greet()
//
//	var body: some View {
//		Text(greet)
//	}
//}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
struct ComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Platform_iosKt.MainViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

//struct ContentView: View {
//    var body: some View {
//        ComposeView()
//                .ignoresSafeArea(.all, edges: .bottom) // Compose has own keyboard handler
//    }
//}


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    ScannerView(isBarCode: true)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                } label: {
                    Text("扫描条码").font(.title).padding()
                }
            }
        }.environmentObject(viewModel)
    }
}
