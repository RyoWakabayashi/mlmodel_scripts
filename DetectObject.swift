import AppKit
import Vision

struct Args {
    let modelPath: String
    let imagePath: String
}

func parseArgs() -> Args? {
    guard let modelPath = CommandLine.arguments.dropFirst().first,
          let imagePath = CommandLine.arguments.dropFirst().dropFirst().first else { return nil }
    return Args(modelPath: modelPath, imagePath: imagePath)
}

func detect(modelPath: String, imagePath: String) {
    let detector = Detector(modelPath: modelPath)
    let imageUrl = URL(fileURLWithPath: imagePath)
    let nsImage = NSImage(byReferencing: imageUrl)
    detector.detect(nsImage)
}

func main() {
    guard let args = parseArgs() else {
        print("Please specify the path to the mlmodelc directory and the target image file")
        return
    }
    detect(modelPath: args.modelPath, imagePath: args.imagePath)
}

class Detector: NSObject {
    var yoloRequest: VNCoreMLRequest?

    init(modelPath: String) {
        super.init()
        self.prepareModel(modelPath: modelPath)
    }

    func prepareModel(modelPath: String) {
        let modelUrl = URL(fileURLWithPath: modelPath)
        guard let yoloModel = try? MLModel(contentsOf: modelUrl),
              let yoloMLModel = try? VNCoreMLModel(for: yoloModel) else { return }
        self.yoloRequest = VNCoreMLRequest(model: yoloMLModel) { [weak self] request, error in
            self?.detected(request: request, error: error)
        }
        self.yoloRequest?.imageCropAndScaleOption = .scaleFill
    }

    func detect(_ image: NSImage) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let yoloRequest = self.yoloRequest else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([yoloRequest])
    }

    func detected(request: VNRequest, error: Error?) {
        if error != nil { print("YOLO error: \(String(describing: error)).") }
        guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }
        observations.forEach { observation in
            if let topLabel = observation.topLabel {
                print(topLabel.identifier, topLabel.confidence,
                      observation.boundingBox.flipVertical())
            }
        }
    }
}

extension VNRecognizedObjectObservation {
    var topLabel: VNClassificationObservation? {
        self.labels.max { $0.confidence < $1.confidence }
    }
}

extension CGRect {
    func flipVertical(size: CGSize = CGSize(width: 1.0, height: 1.0)) -> CGRect {
        CGRect(x: self.minX, y: size.height - self.maxY,
               width: self.width, height: self.height)
    }
}

main()
