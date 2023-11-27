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
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            NavigationLink(destination: ScannerView(isBarCode: true).navigationBarTitle("扫码"),
                           isActive: $viewModel.showScan,
                           label: { Text("扫描条码").font(.title).padding()}
            )
            NavigationLink(destination: TestContent(), isActive: $viewModel.hasBarcode, label: {
                EmptyView()
            })
        }
    }
}
