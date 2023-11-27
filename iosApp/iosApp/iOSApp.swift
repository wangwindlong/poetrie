import SwiftUI
import shared

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var trafficModel = TrafficDataModel()
    @StateObject var viewModel = ViewModel()
    @StateObject var dataModel = GalleryModel()
    @State private var dragAmount: CGPoint?
    
    init() {
        AppModuleKt.doInitKoin(enableNetworkLogs: true, appDeclaration: {_ in })
//        ViewModel().getOrderInfo()
    }
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometryProxy in // just to center initial
                NavigationStack {
                    ZStack {
                        ContentView()
//                        TrafficButton(dragAmount: $dragAmount, area: CGPoint(x: geometryProxy.size.width, y: geometryProxy.size.height))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // full space
                }
            }
            .environmentObject(trafficModel)
            .environmentObject(viewModel)
            .environmentObject(dataModel)
            .onAppear {
                delegate.initQCloud()
            }
        }
    }
    
}

