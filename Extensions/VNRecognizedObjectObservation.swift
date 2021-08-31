extension VNRecognizedObjectObservation {
    var topLabel: VNClassificationObservation? {
        self.labels.max { $0.confidence < $1.confidence }
    }
}
