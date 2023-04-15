import UIKit

protocol MarkupScreenViewInput: AnyObject {

}

protocol MarkupScreenViewOutput: AnyObject {
  func viewDidLoad()
  var listOfPhotos: [String] { get }
}

var goodArea = 0.0
var badArea = 0.0
var polygonGoodAreaLabel = UILabel()
var polygonBadAreaLabel = UILabel()
var percentBadFromGood = UILabel()
var goodBadModuleSwitch = UISwitch()

func rewritePolygonGoodAreaLabel(newArea: Double) {
    goodArea = Double(round(newArea) / 100)
    polygonGoodAreaLabel.text = "Sg = \(goodArea) (см^2)"
}

func rewritePolygonBadAreaLabel(newArea: Double) {
    badArea = Double(round(newArea) / 100)
    polygonBadAreaLabel.text = "Sr = \(badArea) (см^2)"
}

func rewritePercentAreaLabel() {
    if goodArea <= 0.0 || badArea <= 0.0 {
        percentBadFromGood.text = ""
    } else {
        percentBadFromGood.text = "% = \(badArea / goodArea * 100)"
    }
}

final class Canvas: UIView {
    var lines = [[CGPoint]]()
    var pointsInPolygon = [CGPoint]()
    var polygonsColors = [[Double]]()
    var startPointOfNewPolygon = CGPoint()
    
    var randRed = Double.random(in: 0.0000...1.0000)
    var randGreen = Double.random(in: 0.0000...1.0000)
    var randBlue = Double.random(in: 0.0000...1.0000)
    
    func undo() {
        _ = lines.popLast()
        polygonsColors.removeLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        polygonsColors.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        UIGraphicsBeginImageContext(self.frame.size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            self.backgroundColor = UIColor(patternImage: image)
        }
        
        if polygonsColors.count == 0 {
            polygonsColors.append([randRed, randGreen, randBlue])
        }
        
        var numberOfPolygon = 0
        context.setLineWidth(3)
        context.setLineCap(.butt)
        
        lines.forEach { (line) in
            context.setStrokeColor(
                red: polygonsColors[max(0, numberOfPolygon)][0],
                green: polygonsColors[max(0, numberOfPolygon)][1],
                blue: polygonsColors[max(0, numberOfPolygon)][2],
                alpha: 1.0
            )
            
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            
            numberOfPolygon += 1
            
            context.strokePath()
        }
        
        numberOfPolygon -= 1
//        context.setStrokeColor(
//            red: polygonsColors[max(0, numberOfPolygon)][0],
//            green: polygonsColors[max(0, numberOfPolygon)][1],
//            blue: polygonsColors[max(0, numberOfPolygon)][2],
//            alpha: 1.0
//        )
        
        context.setStrokeColor(
            red: 0.0,
            green: 1.0,
            blue: 0.0,
            alpha: 1.0
        )
        context.setLineWidth(3)
        context.setLineCap(.butt)
        
        for i in pointsInPolygon {
            context.move(to: i)
            context.addEllipse(in: CGRect(origin: i, size: CGSize(width: 1.0, height: 1.5)))
        }
        
        context.strokePath()
        
        pointsInPolygon = [CGPoint]()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Changing colors
        randRed = Double.random(in: 0.0000...1.0000)
        randGreen = Double.random(in: 0.0000...1.0000)
        randBlue = Double.random(in: 0.0000...1.0000)
        
        polygonsColors.append([randRed, randGreen, randBlue])
        
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        
        let newPoint = CGPoint(x: point.x, y: point.y - 100.0)
        
        guard var lastLine = lines.popLast() else { return }
        
        if !lastLine.isEmpty {
            startPointOfNewPolygon = lastLine[0]
        }
        
        lastLine.append(newPoint)
        
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Adding start point for polygon
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(startPointOfNewPolygon)
        lines.append(lastLine)
        
        // Adding fill for polygon
        for xCoordinate in stride(from: 0.0, through: 395.0, by: 10.0) {
            for yCoordinate in stride(from: 0.0, through: 674.0, by: 10.0) {
                if contains(polygon: lines.last ?? [CGPoint](), test: CGPoint(x: xCoordinate, y: yCoordinate)) {
                    pointsInPolygon.append(CGPoint(x: xCoordinate, y: yCoordinate))
                }
            }
        }
        
        // Adding area counting
        if (pointsInPolygon.count > 2) {
            if goodBadModuleSwitch.isOn {
                rewritePolygonGoodAreaLabel(newArea: getNewArea(polygon: lines.last ?? [CGPoint]()))
            } else {
                
            }
        }
        
        setNeedsDisplay()
    }
    
    func getNewArea(polygon: [CGPoint]) -> Double {
        var newArea: Double = 0.0
        var pointInPolygon = pointsInPolygon[pointsInPolygon.count / 2]
        
        for i in 0..<polygon.count - 1 {
            newArea += getAreaOfTriangle(
                pt1: polygon[i],
                pt2: polygon[i + 1],
                pt3: pointInPolygon
            )
        }
        
        return newArea
    }
    
    func getAreaOfTriangle(pt1: CGPoint, pt2: CGPoint, pt3: CGPoint) -> Double {
        let firstVector = getVector(pt1: pt3, pt2: pt1)
        let secondVector = getVector(pt1: pt3, pt2: pt2)
        
        return abs(vectorProduct(v1: firstVector, v2: secondVector)) / 2
    }
    
    func getVector(pt1: CGPoint, pt2: CGPoint) -> CGPoint {
        return CGPoint(x: pt2.x - pt1.x, y: pt2.y - pt1.y)
    }
    
    func vectorProduct(v1: CGPoint, v2: CGPoint) -> Double {
        return v1.x * v2.y - v1.y * v2.x
    }
    
    func contains(polygon: [CGPoint], test: CGPoint) -> Bool {
        if polygon.count <= 1 {
            return false //or if first point = test -> return true
        }

        var p = UIBezierPath()
        let firstPoint = polygon[0] as CGPoint

        p.move(to: firstPoint)

        for index in 1...polygon.count-1 {
            p.addLine(to: polygon[index] as CGPoint)
        }

        p.close()

        return p.contains(test)
    }
}

final class MarkupScreenViewController: UIViewController, UIScrollViewDelegate {

  // MARK: - Outlets


  // MARK: - Properties

  var output: MarkupScreenViewOutput?
    
    private var imageScrollView = UIScrollView()
    private var canvasView = Canvas()
    private var imageView: UIImageView!
    private var sliderForPhoto = UISlider()
    
    private var undoButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func undoButtonTapped() {
        print("undo button pressed")
        canvasView.undo()
    }
    
    private var clearButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Очистить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func clearButtonTapped() {
        print("clear button pressed")
        canvasView.clear()
    }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    
      self.navigationController?.navigationBar.backgroundColor = .black
      self.navigationController?.navigationBar.barTintColor = UIColor.black

    view.backgroundColor = .black
      
    setupUI()
  }

  // MARK: - Actions


  // MARK: - Setup

  private func setupUI() {
      createScrollView()
      addTestImage()
      setupCanvasView()
      setupSlider()
      setupButtons()
      setupPolygonLabel()
      setupSwitch()
  }

    private func createScrollView() {
        imageScrollView = UIScrollView(frame: view.bounds)
        
        imageScrollView.delegate = self
        
        self.view.addSubview(imageScrollView)
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.equalToSuperview().inset(7)
            make.right.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(100)
        }

        imageScrollView.isPagingEnabled = true
        imageScrollView.layer.cornerRadius = 15
        imageScrollView.backgroundColor = .black
        imageScrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = true
        imageScrollView.flashScrollIndicators()
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 5.0
        imageScrollView.layer.borderColor = CGColor(red: 0.1, green: 0.1, blue: 0.55, alpha: 1)
        imageScrollView.layer.borderWidth = 2.5
    }
    
    private func setupCanvasView() {
        self.imageView.addSubview(canvasView)
        self.imageView.bringSubviewToFront(canvasView)
        
        canvasView.backgroundColor = .black
        canvasView.contentMode = .scaleAspectFit
        canvasView.isUserInteractionEnabled = true
        canvasView.clipsToBounds = false
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        canvasView.draw(CGRect())
    }
    
    private func addTestImage() {
        imageView?.removeFromSuperview()
        imageView = nil
        
        print((output?.listOfPhotos[0])!)
        
        var testImage = UIImage()
        
        if (output?.listOfPhotos[0])!.count == 2 {
            testImage = UIImage(named: (output?.listOfPhotos[0])!)!
        } else {
            let urlImage = URL(string: (output?.listOfPhotos[0])!)!
            
            urlImage.startAccessingSecurityScopedResource()
            let imageData = try! Data(contentsOf: URL(string: (output?.listOfPhotos[0])!)!)
            testImage = UIImage(data: imageData)!
            urlImage.stopAccessingSecurityScopedResource()
        }
        
        imageView = UIImageView()
        
        self.imageScrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.top.left.right.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 11.0
        imageView.clipsToBounds = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        testImage = drawOnImage(testImage)
        imageView.image = testImage
        imageView.center = imageScrollView.center
    }
    
    private func setupButtons() {
        self.view.addSubview(undoButton)
        self.view.addSubview(clearButton)
        
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(35)
        }
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(35)
        }
    }
    
    func drawOnImage(_ image: UIImage) -> UIImage {
         // Create a context of the starting image size and set it as the current one
         UIGraphicsBeginImageContext(image.size)
        
         // Draw the starting image in the current context as background
         image.draw(at: CGPoint.zero)
        
         // Get the current context
         let context = UIGraphicsGetCurrentContext()!
        
         // Draw a red line
        context.setLineWidth(0.2)
         context.setStrokeColor(UIColor.red.cgColor)

        for i in 1...10 {
            let xCoordinate = CGFloat(i) * (image.size.width / 10), yCoordinate = image.size.height
            
            context.move(to: CGPoint(x: xCoordinate, y: 0))
            context.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
            
            context.strokePath()
        }
        
        for i in 1...10 {
            let xCoordinate = image.size.width, yCoordinate = CGFloat(i) * (image.size.height / 10)
            
            context.move(to: CGPoint(x: 0, y: yCoordinate))
            context.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
            
            context.strokePath()
        }
        
         // Save the context as a new UIImage
         let myImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
        
         // Return modified image
         return myImage!
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        return self.imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }

    private func setupSlider() {
        self.view.addSubview(sliderForPhoto)
        
        sliderForPhoto.translatesAutoresizingMaskIntoConstraints = false
        sliderForPhoto.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(60)
        }
        
        sliderForPhoto.thumbTintColor = UIColor(red: 47, green: 47, blue: 50)
        sliderForPhoto.tintColor = UIColor(red: 25, green: 25, blue: 140)
        sliderForPhoto.minimumValue = 0
        sliderForPhoto.maximumValue = Float((output?.listOfPhotos.count)! - 1)
        sliderForPhoto.value = 0
        sliderForPhoto.tag = 1
        
        if (Int((output?.listOfPhotos.count)!) == 1) {
            sliderForPhoto.isHidden = true
        }
        
        sliderForPhoto.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
    }
    
    @objc func sliderValueChange(sender: UISlider) {
        var currentValue = Int(sender.value)
        
        print((output?.listOfPhotos[currentValue])!)
        
        var testImage = UIImage()
        
        if (output?.listOfPhotos[currentValue])!.count == 2 {
            testImage = UIImage(named: (output?.listOfPhotos[currentValue])!)!
        } else {
            let urlImage = URL(string: (output?.listOfPhotos[currentValue])!)!
            
            urlImage.startAccessingSecurityScopedResource()
            let imageData = try! Data(contentsOf: URL(string: (output?.listOfPhotos[currentValue])!)!)
            testImage = UIImage(data: imageData)!
            urlImage.stopAccessingSecurityScopedResource()
        }
        
        testImage = drawOnImage(testImage)
        
        self.imageView.image = testImage
    }
    
    private func setupPolygonLabel() {
        self.view.addSubview(polygonGoodAreaLabel)
        self.view.addSubview(polygonBadAreaLabel)
        self.view.addSubview(percentBadFromGood)
        
        polygonGoodAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        polygonGoodAreaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(35)
        }
        
        polygonBadAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        polygonBadAreaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
        }
        
        percentBadFromGood.translatesAutoresizingMaskIntoConstraints = false
        percentBadFromGood.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        polygonGoodAreaLabel.text = ""
        polygonGoodAreaLabel.textColor = UIColor.green
        polygonGoodAreaLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        polygonBadAreaLabel.text = ""
        polygonBadAreaLabel.textColor = UIColor.red
        polygonBadAreaLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        
        percentBadFromGood.text = ""
        percentBadFromGood.textColor = UIColor.blue
        percentBadFromGood.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
    }
    
    private func setupSwitch() {
        self.view.addSubview(goodBadModuleSwitch)
        
        goodBadModuleSwitch.translatesAutoresizingMaskIntoConstraints = false
        goodBadModuleSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(35)
        }
    }
    
  private func setupLocalization() {

  }
}

// MARK: - TroikaServiceViewInput

extension MarkupScreenViewController: MarkupScreenViewInput {

}
