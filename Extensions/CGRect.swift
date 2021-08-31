extension CGRect {
    func flipVertical(size: CGSize = CGSize(width: 1.0, height: 1.0)) -> CGRect {
        CGRect(x: self.minX, y: size.height - self.maxY,
               width: self.width, height: self.height)
    }
}
