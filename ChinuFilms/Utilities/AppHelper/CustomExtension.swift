//
//  CustomExtension.swift
//  SanskarEP
//
//  Created by Warln on 10/01/22.
//

import UIKit
import SDWebImage

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}

extension CALayer{
    //width should be greater then height other it will be show as circle
    func Capsule(){
        self.cornerRadius = self.frame.height/2
    }
    func Circle(){
        self.cornerRadius = self.frame.height/2
        self.masksToBounds = true
    }
    func topCorner(){
        self.cornerRadius = 10.0
        self.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    func BottomCorner(){
        self.cornerRadius = 10.0
        self.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func cornerView(value:CGFloat){
        self.masksToBounds = true
        self.cornerRadius = value
    }
    
}

extension UIView{
    
    func DashPatternBorder(){
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.lightGray.cgColor
        yourViewBorder.lineDashPattern = [10, 5]
        yourViewBorder.lineDashPhase = 4
        //yourViewBorder.lineCap = .round
        // yourViewBorder.lineJoin = .round
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.cornerRadius = 20.0
        yourViewBorder.path = UIBezierPath(rect:  self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
        
    }
    
    
    
}


extension UIButton{
    func animationZoom() {
        UIView.animate(withDuration: 0.1, animations: {
            // let unlikedScale: CGFloat = 0.7
            let likedScale: CGFloat = 1.05
            self.transform = self.transform.scaledBy(x: likedScale, y: likedScale)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}

extension UITextField {
    
    func colorBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}

extension UIButton {
    
    func colorBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}

extension String {
    
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
    
}


extension UIViewController{
    
    func mainStoryBoard()-> UIStoryboard{
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        return story
    }
    
    func HomeStoryBoard()-> UIStoryboard{
        let story = UIStoryboard.init(name: "Home", bundle: nil)
        return story
    }
    
    func MusicStoryBoard()-> UIStoryboard{
        let story = UIStoryboard.init(name: "Music", bundle: nil)
        return story
    }
    func SeriesStoryBoard()-> UIStoryboard{
        let story = UIStoryboard.init(name: "Series", bundle: nil)
        return story
    }
    func RShowStoryBoard()-> UIStoryboard{
        let story = UIStoryboard.init(name: "RShow", bundle: nil)
        return story
    }
    
    
}

extension Date {
    
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let now = dateFormatter.string(from: self)
        return now
    }
}



extension UIView{
    func circleWithBorder () {
        self.layer.cornerRadius = self.layer.frame.size.width / 2
    //    self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    func circleWithBorder1 () {
        self.layer.cornerRadius = self.layer.frame.size.width / 2
    //    self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    func circleWithBorder2 () {
        self.layer.cornerRadius = self.layer.frame.size.width / 2
    //    self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }
   
}

extension Double {
    
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    func secondsToString() -> String {
        return formatter.string(from: self) ?? ""
    }
    
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

extension UIImageView {
    
    func circleImg(_ border: CGFloat,_ color: UIColor) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = border
    }
}

extension UILabel {
    func circleLbl() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}





class ImageStore: NSObject {
    static let imageCache = NSCache<NSString, UIImage>()
}

extension UIViewController {
    func GetImageWithURL(_ url: String?,completionHandler: @escaping (_ image: UIImage?) -> Void){
        //Use with sdwebimage if already have install
        let image4 = UIImageView()
        
        image4.sd_setImage(with: URL(string: url ?? "")) { (img, err, cache, url) in
            completionHandler(img)
        }
        
    }
    
}



extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}


func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
#endif
}

func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    items.forEach {
        Swift.debugPrint($0, separator: separator, terminator: terminator)
    }
#endif
}

func convertAnythingTOData(dict:Any) -> Data?{
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return jsonData
    } catch {
        print(error.localizedDescription)
    }
    return nil
}


extension String {
    func ValidateEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "^(?:(?:(?:(?: )(?:(?:(?:\\t| )\\r\\n)?(?:\\t| )+))+(?: ))|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: ))|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )[!-Z^-~])*(?: ))|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )(?:(?:(?:\\t| )\\r\\n)?(?:\\t| )+))+(?: ))|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}

extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
}

func shadow (_ cell : UICollectionViewCell) {
    cell.contentView.layer.cornerRadius = 20.0
    cell.contentView.layer.borderWidth = 1.0
    cell.contentView.layer.borderColor = UIColor.clear.cgColor
    cell.contentView.layer.masksToBounds = true
    
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 0.25
    cell.layer.masksToBounds = false
    cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
    
}

extension UIView {
    /// Add Shadow to your view
    /// - Parameters:
    ///   - shadowColor: Shadow Color
    ///   - shadowOffset: Offsets
    ///   - shadowOpacity: Opacity
    ///   - shadowRadius: Radius
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0), shadowOpacity: Float = 0.4, shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
    }
    
    func roundCornersView(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundedView(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension String {
    func isNumeric() -> Bool{
        if Int(self) == nil{
            return false
        }else{
            return true
        }
    }
}

public enum Model : String {
    
    //Simulator
    case simulator     = "simulator/sandbox",
         
         //iPod
         iPod1              = "iPod 1",
         iPod2              = "iPod 2",
         iPod3              = "iPod 3",
         iPod4              = "iPod 4",
         iPod5              = "iPod 5",
         iPod6              = "iPod 6",
         iPod7              = "iPod 7",
         
         //iPad
         iPad2              = "iPad 2",
         iPad3              = "iPad 3",
         iPad4              = "iPad 4",
         iPadAir            = "iPad Air ",
         iPadAir2           = "iPad Air 2",
         iPadAir3           = "iPad Air 3",
         iPadAir4           = "iPad Air 4",
         iPad5              = "iPad 5", //iPad 2017
         iPad6              = "iPad 6", //iPad 2018
         iPad7              = "iPad 7", //iPad 2019
         iPad8              = "iPad 8", //iPad 2020
         iPad9              = "iPad 9", //iPad 2021
         
         //iPad Mini
         iPadMini           = "iPad Mini",
         iPadMini2          = "iPad Mini 2",
         iPadMini3          = "iPad Mini 3",
         iPadMini4          = "iPad Mini 4",
         iPadMini5          = "iPad Mini 5",
         iPadMini6          = "iPad Mini 6",
         
         //iPad Pro
         iPadPro9_7         = "iPad Pro 9.7\"",
         iPadPro10_5        = "iPad Pro 10.5\"",
         iPadPro11          = "iPad Pro 11\"",
         iPadPro2_11        = "iPad Pro 11\" 2nd gen",
         iPadPro3_11        = "iPad Pro 11\" 3rd gen",
         iPadPro12_9        = "iPad Pro 12.9\"",
         iPadPro2_12_9      = "iPad Pro 2 12.9\"",
         iPadPro3_12_9      = "iPad Pro 3 12.9\"",
         iPadPro4_12_9      = "iPad Pro 4 12.9\"",
         iPadPro5_12_9      = "iPad Pro 5 12.9\"",
         
         //iPhone
         iPhone4            = "iPhone 4",
         iPhone4S           = "iPhone 4S",
         iPhone5            = "iPhone 5",
         iPhone5S           = "iPhone 5S",
         iPhone5C           = "iPhone 5C",
         iPhone6            = "iPhone 6",
         iPhone6Plus        = "iPhone 6 Plus",
         iPhone6S           = "iPhone 6S",
         iPhone6SPlus       = "iPhone 6S Plus",
         iPhoneSE           = "iPhone SE",
         iPhone7            = "iPhone 7",
         iPhone7Plus        = "iPhone 7 Plus",
         iPhone8            = "iPhone 8",
         iPhone8Plus        = "iPhone 8 Plus",
         iPhoneX            = "iPhone X",
         iPhoneXS           = "iPhone XS",
         iPhoneXSMax        = "iPhone XS Max",
         iPhoneXR           = "iPhone XR",
         iPhone11           = "iPhone 11",
         iPhone11Pro        = "iPhone 11 Pro",
         iPhone11ProMax     = "iPhone 11 Pro Max",
         iPhoneSE2          = "iPhone SE 2nd gen",
         iPhone12Mini       = "iPhone 12 Mini",
         iPhone12           = "iPhone 12",
         iPhone12Pro        = "iPhone 12 Pro",
         iPhone12ProMax     = "iPhone 12 Pro Max",
         iPhone13Mini       = "iPhone 13 Mini",
         iPhone13           = "iPhone 13",
         iPhone13Pro        = "iPhone 13 Pro",
         iPhone13ProMax     = "iPhone 13 Pro Max",
         
         // Apple Watch
         AppleWatch1         = "Apple Watch 1gen",
         AppleWatchS1        = "Apple Watch Series 1",
         AppleWatchS2        = "Apple Watch Series 2",
         AppleWatchS3        = "Apple Watch Series 3",
         AppleWatchS4        = "Apple Watch Series 4",
         AppleWatchS5        = "Apple Watch Series 5",
         AppleWatchSE        = "Apple Watch Special Edition",
         AppleWatchS6        = "Apple Watch Series 6",
         AppleWatchS7        = "Apple Watch Series 7",
         
         //Apple TV
         AppleTV1           = "Apple TV 1gen",
         AppleTV2           = "Apple TV 2gen",
         AppleTV3           = "Apple TV 3gen",
         AppleTV4           = "Apple TV 4gen",
         AppleTV_4K         = "Apple TV 4K",
         AppleTV2_4K        = "Apple TV 4K 2gen",
         
         unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        let modelMap : [String: Model] = [
            
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPod7,1"   : .iPod6,
            "iPod9,1"   : .iPod7,
            
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            "iPad7,11"  : .iPad7, //iPad 2019
            "iPad7,12"  : .iPad7,
            "iPad11,6"  : .iPad8, //iPad 2020
            "iPad11,7"  : .iPad8,
            "iPad12,1"  : .iPad9, //iPad 2021
            "iPad12,2"  : .iPad9,
            
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            "iPad14,1"  : .iPadMini6,
            "iPad14,2"  : .iPadMini6,
            
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,9"   : .iPadPro2_11,
            "iPad8,10"  : .iPadPro2_11,
            "iPad13,4"  : .iPadPro3_11,
            "iPad13,5"  : .iPadPro3_11,
            "iPad13,6"  : .iPadPro3_11,
            "iPad13,7"  : .iPadPro3_11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            "iPad8,11"  : .iPadPro4_12_9,
            "iPad8,12"  : .iPadPro4_12_9,
            "iPad13,8"  : .iPadPro5_12_9,
            "iPad13,9"  : .iPadPro5_12_9,
            "iPad13,10" : .iPadPro5_12_9,
            "iPad13,11" : .iPadPro5_12_9,
            
            //iPad Air
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            "iPad13,1"  : .iPadAir4,
            "iPad13,2"  : .iPadAir4,
            
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2,
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            "iPhone14,4" : .iPhone13Mini,
            "iPhone14,5" : .iPhone13,
            "iPhone14,2" : .iPhone13Pro,
            "iPhone14,3" : .iPhone13ProMax,
            
            // Apple Watch
            "Watch1,1" : .AppleWatch1,
            "Watch1,2" : .AppleWatch1,
            "Watch2,6" : .AppleWatchS1,
            "Watch2,7" : .AppleWatchS1,
            "Watch2,3" : .AppleWatchS2,
            "Watch2,4" : .AppleWatchS2,
            "Watch3,1" : .AppleWatchS3,
            "Watch3,2" : .AppleWatchS3,
            "Watch3,3" : .AppleWatchS3,
            "Watch3,4" : .AppleWatchS3,
            "Watch4,1" : .AppleWatchS4,
            "Watch4,2" : .AppleWatchS4,
            "Watch4,3" : .AppleWatchS4,
            "Watch4,4" : .AppleWatchS4,
            "Watch5,1" : .AppleWatchS5,
            "Watch5,2" : .AppleWatchS5,
            "Watch5,3" : .AppleWatchS5,
            "Watch5,4" : .AppleWatchS5,
            "Watch5,9" : .AppleWatchSE,
            "Watch5,10" : .AppleWatchSE,
            "Watch5,11" : .AppleWatchSE,
            "Watch5,12" : .AppleWatchSE,
            "Watch6,1" : .AppleWatchS6,
            "Watch6,2" : .AppleWatchS6,
            "Watch6,3" : .AppleWatchS6,
            "Watch6,4" : .AppleWatchS6,
            "Watch6,6" : .AppleWatchS7,
            "Watch6,7" : .AppleWatchS7,
            "Watch6,8" : .AppleWatchS7,
            "Watch6,9" : .AppleWatchS7,
            
            //Apple TV
            "AppleTV1,1" : .AppleTV1,
            "AppleTV2,1" : .AppleTV2,
            "AppleTV3,1" : .AppleTV3,
            "AppleTV3,2" : .AppleTV3,
            "AppleTV5,3" : .AppleTV4,
            "AppleTV6,2" : .AppleTV_4K,
            "AppleTV11,1" : .AppleTV2_4K
        ]
        
        guard let mcode = modelCode, let map = String(validatingUTF8: mcode), let model = modelMap[map] else { return Model.unrecognized }
        if model == .simulator {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                if let simMap = String(validatingUTF8: simModelCode), let simModel = modelMap[simMap] {
                    return simModel
                }
            }
        }
        return model
    }
}

