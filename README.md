# mlmodel_scripts

Execute mlmodel prediction on Swift script.

## Requires

- macOS
- Swift version 5.4

## Download YOLO model

Download the YOLOv3 model from Apple's official website.

```bash
./downloadYOLO.sh
```

## Comple YOLO model

Compile the model with either coremlcompiler or Swift script

### with coremlcompiler

```bash
xcrun coremlcompiler compile YOLOv3.mlmodel .
```

### with Swift script

```bash
swift CompileMLModel.swift YOLOv3.mlmodel
```

## Execute YOLO model

Execute object detection by specifying the path of the compiled model and the image file.

Label, score, and coordinate information will be displayed.

```bash
$ ./DetectObject.sh YOLOv3.mlmodelc chair.png
chair 0.99625164 (0.19140625, 0.01318359375, 0.763671875, 0.97265625)
```
