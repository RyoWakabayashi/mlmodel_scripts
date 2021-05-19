# mlmodel_scripts

Execute mlmodel prediction on Swift script.

## Requires

macOS
Swift version 5.4

## Download YOLO model

```bash
./downloadYOLO.sh
```

## Comple YOLO model

### xcrun

```bash
xcrun coremlcompiler compile YOLOv3.mlmodel .
```

### Swift

```bash
swift CompileYOLO.swift
```

## Execute YOLO model

```bash
$ swift DetectObject.swift sample.png
chair 0.99625164 (0.19140625, 0.01318359375, 0.763671875, 0.97265625)
```
