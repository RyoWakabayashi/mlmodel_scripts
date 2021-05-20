import AppKit
import Vision

func parseArgs() -> String? {
    CommandLine.arguments.dropFirst().first
}

func compile(modelUrl: URL) -> URL? {
    return try? MLModel.compileModel(at: modelUrl)
}

func getOutputURL(modelUrl: URL, compiledUrl: URL) -> URL {
    let outputDirectory = URL(fileURLWithPath: "./")
    let inputExtension = modelUrl.pathExtension
    let outputExtension = compiledUrl.pathExtension
    let outputFileName = modelUrl.lastPathComponent
        .replacingOccurrences(of: inputExtension, with: outputExtension)
    return outputDirectory.appendingPathComponent(outputFileName)
}

func copyOrReplace(inputUrl: URL, outputUrl: URL) {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: outputUrl.absoluteString) {
        _ = try? fileManager.replaceItemAt(outputUrl, withItemAt: inputUrl)
    } else {
        try? fileManager.copyItem(at: inputUrl, to: outputUrl)
    }
}

func main() {
    guard let modelPath = parseArgs() else {
        print("Please specify the path to the .mlmodel file")
        return
    }
    let modelUrl = URL(fileURLWithPath: modelPath)
    guard let compiledUrl = compile(modelUrl: modelUrl) else {
        print("Compile error occured.")
        return
    }
    let outputUrl = getOutputURL(modelUrl: modelUrl, compiledUrl: compiledUrl)
    copyOrReplace(inputUrl: compiledUrl, outputUrl: outputUrl)
}

main()
