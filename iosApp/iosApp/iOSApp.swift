import SwiftUI
import shared

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var trafficModel = TrafficDataModel()
    @State private var dragAmount: CGPoint?
    
    init() {
        AppModuleKt.doInitKoin(enableNetworkLogs: true, appDeclaration: {_ in })
//        ViewModel().getOrderInfo()
    }
    
	var body: some Scene {
		WindowGroup {
            GeometryReader { geometryProxy in // just to center initial
                ZStack {
                    ContentView()
//                    TrafficButton(dragAmount: $dragAmount, area: CGPoint(x: geometryProxy.size.width, y: geometryProxy.size.height))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // full space
            }
            .environmentObject(trafficModel)
            .onAppear {
                delegate.initQCloud()
            }
        }
	}
}

