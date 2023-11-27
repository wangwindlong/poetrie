//
//  ScannerView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import VisionKit

/// 扫描条码的页面
@available(iOS 16.0, *)
@MainActor
struct ScannerView: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var dataModel: GalleryModel
    static let cancelScanLabel = "返回"
    static let stopScanLabel = "Stop Scan"
    var isBarCode: Bool = false
    
    @available(iOS 16.0, *)
    static let textDataType: DataScannerViewController.RecognizedDataType = .text(
        languages: [
            "en-US",
            "zh-Hans",
            "ja_JP"
        ]
    )
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    var scannerViewController = DataScannerViewController(
        recognizedDataTypes: [ScannerView.textDataType, .barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        scannerViewController.delegate = context.coordinator
        
        // Add a button to start scanning
        let scanButton = UIButton(type: .system)
        scanButton.backgroundColor = UIColor.systemBlue
        scanButton.setTitle(ScannerView.cancelScanLabel, for: .normal)
        scanButton.setTitleColor(UIColor.white, for: .normal)
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        scanButton.configuration = config
        //let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50), configuration: config)
        
        //scanButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        scanButton.addTarget(context.coordinator, action: #selector(Coordinator.cancelScanning(_:)), for: .touchUpInside)
        scanButton.layer.cornerRadius = 5.0
        scannerViewController.view.addSubview(scanButton)
        // Set up button constraints
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: scannerViewController.view.centerXAnchor),
            scanButton.bottomAnchor.constraint(equalTo: scannerViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // Update any view controller settings here
        print("updateUIViewController showScan=\(viewModel.showScan)")
        if !viewModel.showScan {
            uiViewController.stopScanning()
            uiViewController.navigationController?.popViewController(animated: false)
        } else if let error = viewModel.responseText {
            ZLProgressHUD.show(toast: .custome("条码信息获取失败：\(error)"), timeout: 1)
            viewModel.responseText = nil
            viewModel.orderResponse = nil
            try? uiViewController.startScanning()
        } else if let response = viewModel.orderResponse {
            try? uiViewController.stopScanning()
            popUp()
        } else {
            try? uiViewController.startScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScannerView
        var roundBoxMappings: [UUID: UIView] = [:]
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            print("dataScanner addedItems=\(addedItems)")
            processAddedItems(items: addedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            print("dataScanner removedItems=\(removedItems)")
            processRemovedItems(items: removedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            print("dataScanner updatedItems=\(updatedItems)")
            processUpdatedItems(items: updatedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("dataScanner item=\(item)")
            processItem(item: item)
        }
        
        
        func processAddedItems(items: [RecognizedItem]) {
            for item in items {
                processItem(item: item)
                //addRoundBoxToItem(item: item)
            }
        }
        
        func processRemovedItems(items: [RecognizedItem]) {
            for item in items {
                //processItem(item: item)
                removeRoundBoxFromItem(item: item)
            }
        }
        
        func processUpdatedItems(items: [RecognizedItem]) {
            for item in items {
                //processItem(item: item)
                updateRoundBoxToItem(item: item)
            }
        }
        
        func addRoundBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
            //let roundedRectView = RoundRectView(frame: frame)
            let roundedRectView = RoundedRectLabel(frame: frame)
            roundedRectView.setText(text: text)
//            parent.overlayContainerView.addSubview(roundedRectView)
            roundBoxMappings[item.id] = roundedRectView
        }
        
        func removeRoundBoxFromItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    roundBoxView.removeFromSuperview()
                    roundBoxMappings.removeValue(forKey: item.id)
                }
            }
        }
        
        func updateRoundBoxToItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    let frame = getRoundBoxFrame(item: item)
                    roundBoxView.frame = frame
                }
            }
        }
        
        func getRoundBoxFrame(item: RecognizedItem) -> CGRect {
            let frame = CGRect(
                x: item.bounds.topLeft.x,
                y: item.bounds.topLeft.y,
                width: abs(item.bounds.topRight.x - item.bounds.topLeft.x) + 15,
                height: abs(item.bounds.topLeft.y - item.bounds.bottomLeft.y) + 15
            )
            return frame
        }
        
        func processItem(item: RecognizedItem) {
            switch item {
            case .text(let text):
                print("Text Observation - \(text.observation)")
                print("Text transcript - \(text.transcript)")
                let frame = getRoundBoxFrame(item: item)
                addRoundBoxToItem(frame: frame, text: text.transcript, item: item)
            case .barcode(let barCodeResult):
                let barCode = barCodeResult.observation.payloadStringValue
                print("processItem barCode=\(barCode)")
                if let barCode {
                    parent.scannerViewController.stopScanning()
                    parent.viewModel.getOrderInfo(barCode)
                }
                break
            @unknown default:
                print("Should not happen")
            }
        }
        
        // Add this method to start scanning
        @objc func cancelScanning(_ sender: UIButton) {
//            if sender.title(for: .normal) == cancelScanLabel {
//                try? parent.scannerViewController.startScanning()
//                sender.setTitle(stopScanLabel, for: .normal)
//            } else {
//                parent.scannerViewController.stopScanning()
//                sender.setTitle(cancelScanLabel, for: .normal)
//            }
//            parent.scannerViewController.stopScanning()
            parent.popUp()
        }
    }
    
    func popUp() {
        viewModel.showScan = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.viewModel.hasBarcode = true
        })
       
    }
}

class MyHostingController: UIHostingController<TestContent> {
        
    override init(rootView: TestContent) {
        super.init(rootView: rootView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismisss))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func dismisss() {
        print("dismisss clicked navigationController=\(navigationController) self=\(self)")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
//        self.navigationController?.popToRootViewController(animated: false)
    }
}

//https://juejin.cn/post/6984026677161099294
extension UIViewController {
    public func present<Content: View>(presentationStyle: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, animated: Bool = true, completion: @escaping () -> Void = {}, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = presentationStyle
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, ViewControllerHolder(toPresent))
        )
        if presentationStyle == .overCurrentContext {
            toPresent.view.backgroundColor = .clear
        }
        self.present(toPresent, animated: animated, completion: completion)
    }
}

public struct ViewControllerHolder {
    public weak var value: UIViewController?
    init(_ value: UIViewController?) {
        self.value = value
    }
}

public struct ViewControllerKey: EnvironmentKey {
    public static var defaultValue: ViewControllerHolder { return ViewControllerHolder(nil) }
}

extension EnvironmentValues {
    public var viewController: ViewControllerHolder {
        get { return self[ViewControllerKey.self] }
        set { self[ViewControllerKey.self] = newValue }
    }
}
