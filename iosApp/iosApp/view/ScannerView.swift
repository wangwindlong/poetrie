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
    @StateObject private var viewModel = ViewModel()
    static let cancelScanLabel = "返回"
    static let stopScanLabel = "Stop Scan"
    var isBarCode: Bool = false
    @State var isExit = false
    
    @available(iOS 16.0, *)
    static let textDataType: DataScannerViewController.RecognizedDataType = .text(
        languages: [
            "en-US",
            "zh-Hans",
            "ja_JP"
        ]
    )
    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [ScannerView.textDataType, .barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
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
        print("updateUIViewController isExit=\(isExit) barCode=\(viewModel.barCode)")
        if isExit {
            scannerViewController.stopScanning()
            uiViewController.navigationController?.popViewController(animated: true)
        } else if let order = viewModel.orderResponse {
            scannerViewController.stopScanning()
            guard let navController = uiViewController.navigationController else { return }
//            let vc = UIHostingController(rootView: CameraView(viewModel))
            let vc = UIHostingController(rootView: GridView().environmentObject(viewModel).environmentObject(GalleryModel()))
            navController.popViewController(animated: true)
            navController.pushViewController(vc, animated: true)
        }  else {
            try? scannerViewController.startScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, isExit: $isExit)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScannerView
        @Binding var isExit: Bool
        var roundBoxMappings: [UUID: UIView] = [:]
        
        init(_ parent: ScannerView, isExit: Binding<Bool>) {
            self.parent = parent
            self._isExit = isExit
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
            parent.scannerViewController.overlayContainerView.addSubview(roundedRectView)
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
                    parent.viewModel.getOrderInfo(barCode)
//                    parent.viewModel.barCode = barCode
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
            parent.scannerViewController.stopScanning()
            popUp()
        }
        
        func popUp() {
            parent.isExit = true
        }
    }
}
