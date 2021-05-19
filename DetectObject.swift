import AppKit
import Vision

func parseArgs() -> String? {
    CommandLine.arguments.dropFirst().first
}

func detect(filePath: String) {
    let detector = Detector()
    let fileUrl = URL(fileURLWithPath: filePath)
    let nsImage = NSImage(byReferencing: fileUrl)
    detector.detect(nsImage)
}

func main() {
    guard let filePath = parseArgs() else {
        print("Plese enter the path to the target image file")
        return
    }
    detect(filePath: filePath)
}

class Detector: NSObject {
    var yoloRequest: VNCoreMLRequest?

    override init() {
        super.init()
        self.prepareModel()
    }

    func prepareModel() {
        let modelUrl = URL(fileURLWithPath: "./YOLOv3.mlmodelc")
        guard let yoloModel = try? MLModel(contentsOf: modelUrl),
              let yoloMLModel = try? VNCoreMLModel(for: yoloModel) else { return }
        self.yoloRequest = VNCoreMLRequest(model: yoloMLModel) { [weak self] request, error in
            self?.detected(request: request, error: error)
        }
        self.yoloRequest?.imageCropAndScaleOption = .scaleFill
    }

    func detect(_ image: NSImage) {
        guard let ciImage = image.ciImage,
              let yoloRequest = self.yoloRequest else { return }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try? handler.perform([yoloRequest])
    }

    func detected(request: VNRequest, error: Error?) {
        if error != nil { print("YOLO error: \(String(describing: error)).") }
        guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }
        observations.forEach { observation in
            if let topLabel = observation.topLabel {
                print(topLabel.identifier, topLabel.confidence, observation.boundingBox)
            }
        }
    }
}

extension NSImage {
    var ciImage: CIImage? {
        guard let imageData = self.tiffRepresentation else { return nil }
        return CIImage(data: imageData)
    }
}

extension VNRecognizedObjectObservation {
    var topLabel: VNClassificationObservation? {
        self.labels.max { $0.confidence < $1.confidence }
    }
}

main()
