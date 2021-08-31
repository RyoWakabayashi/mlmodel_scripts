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

main()
