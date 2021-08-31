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
