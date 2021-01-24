import UIKit
import Flutter
import  AMapSearchKit
import Contacts
import AddressBook
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,FlutterStreamHandler,AMapSearchDelegate {
    var search :AMapSearchAPI=AMapSearchAPI.init()
    var myResult :FlutterResult?
    var navigationTool :NavigationTool = NavigationTool.init();
    private var speakerUtil :SpeakerUtil?
    private var shareTool :ShareTool?
    private var flutterEventSink :FlutterEventSink?
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.flutterEventSink = events
           initJMLink()
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
     return nil
    }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    AMapServices.init().apiKey="30451939c0a123dfb05d9ae6b7c00b1f"
    self.shareTool = ShareTool.init()
    initEventChannel();
    initChannel();
    initSpeaker();
    //initJMLink();
    search.delegate=self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        JMLinkService.routeMLink(url)
        return true
    }
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        JMLinkService.continue(userActivity)
        return true
    }
    func initEventChannel(){
        let parm = self.window.rootViewController
        let controller = parm as! FlutterViewController ;
        controller.pushRoute("App")
        let eventChannel=FlutterEventChannel.init(name:"mc",binaryMessenger:controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
        
    }
    func  initJMLink(){
        let config = JMLinkConfig.init()
        config.appKey="F3TGD41LEQDUFZ5FE4611OFK966J259B"
        JMLinkService.setup(with: config)
        JMLinkService.registerHandler{(reponse)in
          let params = reponse?.params
          let strResult=params?["id"]
          print("==jmlink\(strResult)")
          self.flutterEventSink!(strResult)
        }
        print("==jmlink")
        
    }
    //实例化原生发事件到flutter
//    func initEvetntChannel(){
//        let flutterviewController = FlutterViewController.init()
//        flutterviewController.setInitialRoute("App")
//        let eventChannel = FlutterEventChannel(name: "mc", binaryMessenger:flutterviewController.binaryMessenger)
//        eventChannel.setStreamHandler(self)
//    }
    
    func initChannel(){
        let controller:FlutterViewController = window.rootViewController as!  FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "jidier", binaryMessenger: controller as! FlutterBinaryMessenger)
        batteryChannel.setMethodCallHandler{(call,result) in
            self.myResult=result;
            if "searchNearBy" == call.method{
                let arguments=call.arguments as! NSArray
                let one :String = arguments.firstObject as! String
                let two = arguments.object(at:1) as! String
                let lat = CGFloat(Double(one) ?? 0)
                let lng = CGFloat(Double(two) ?? 0)
                let request :AMapPOIAroundSearchRequest = AMapPOIAroundSearchRequest.init()
                request.location = AMapGeoPoint.location(withLatitude:lat, longitude:lng)
                request.types="150904";
                request.radius=1000;
                request.sortrule=0;
                request.requireExtension=true;
                self.search.aMapPOIAroundSearch(request);
            }else if "search" == call.method{ //搜索地址
                let arguments = call.arguments as! NSArray
                let content = arguments.object(at:0) as! String
                let city = arguments.object(at: 1) as! String
                let myLng =  arguments.object(at:2) as! String
                let myLat = arguments.object(at:3);
                
                var tipsRequest : AMapInputTipsSearchRequest = AMapInputTipsSearchRequest.init()
                tipsRequest.keywords = content
                tipsRequest.city = city
                if myLng != ""{
                    tipsRequest.location = "\(myLng),\(myLat)"
                }
                tipsRequest.cityLimit=false
            
                self.search.aMapInputTipsSearch(tipsRequest)

            }
            
            
            else if "installGaoDe" == call.method { //判断是否安装了高德地图
                self.myResult!(self.navigationTool.isInstallGaode())
            }else if "installTenXun" == call.method { //判断是否安装了腾讯地图
                self.myResult!(self.navigationTool.isInstallTenxun())
            }else if "installGoogle" == call.method { //判断是否安装了map
                self.myResult!(self.navigationTool.isInstallMap())
            }else if "openGaode" == call.method { //打开高德地图
                let argements =  call.arguments as! NSArray ;
                let strWay = argements.object(at:0) as! NSNumber;
                let strAddressname = argements.object(at:1) as! String;
                let  strStartLat = argements.object(at:2)  ;
                let flStartLat = Float("\(strStartLat)");
                let  strStartLng = argements.object(at: 3) ;
                let flStartLng = Float("\(strStartLng)");
                let  strEndLat = argements.object(at:4) ;
                let flEndLat = Float("\(strEndLat)");
                let  strEndLng = argements.object(at:5) ;
                let flEndLng = Float("\(strEndLng)");
                self.navigationTool.openGaode(Int32(strWay), toStartLat:flStartLat!, toStartLng:flStartLng!, toEndLat:flEndLat!, toEndLng:flEndLng!, toEndName: strAddressname);
                self.myResult!("0");
            }else if "openTenxun" == call.method { //调用腾讯地图
                let argements =  call.arguments as! NSArray ;
                let strWay = argements.object(at:0) as! NSNumber;
                let strAddressname = argements.object(at:1) as! String;
                let  strStartLat = argements.object(at:2)  ;
                let flStartLat = Float("\(strStartLat)");
                let  strStartLng = argements.object(at: 3) ;
                let flStartLng = Float("\(strStartLng)");
                let  strEndLat = argements.object(at:4) ;
                let flEndLat = Float("\(strEndLat)");
                let  strEndLng = argements.object(at:5) ;
                let flEndLng = Float("\(strEndLng)");

                self.navigationTool.openTenxun(Int32(strWay), toStarLat:flStartLat!,toStartLng:flStartLng!, toAddressName:strAddressname, toEndLat:flEndLat!, toEndLng:flEndLng!)
                self.myResult!("0");
            }else if "openMap" == call.method { //调用苹果地图
                let argements =  call.arguments as! NSArray ;
                let strWay = argements.object(at:0) as! NSNumber;
                let strAddressname = argements.object(at:1) as! String;
                let  strStartLat = argements.object(at:2)  ;
                let flStartLat = Float("\(strStartLat)");
                let  strStartLng = argements.object(at: 3) ;
                let flStartLng = Float("\(strStartLng)");
                let  strEndLat = argements.object(at:4) ;
                let flEndLat = Float("\(strEndLat)");
                let  strEndLng = argements.object(at:5) ;
                let flEndLng = Float("\(strEndLng)");
                self.navigationTool.openIos(Int32(strWay), toAddressName: strAddressname, toStarLat: flStartLat!, toStarLng: flStartLng!, toEndLat: flEndLat!, toEndLng: flEndLng!)
                self.myResult!("0");
            }else if "speaker" == call.method {
                self.speakerUtil!.startSpeaker(self.myResult!);
            }else if "stopSpeaker" == call.method {
                self.speakerUtil!.stopSpeaker();
            } else if "getContacts" == call.method {
                if #available(iOS 9.0, *) {
                    self.getAddressBookAction()
                } else {
                    // Fallback on earlier versions
                }
            }else if "callPhone" == call.method{
                let argment = call.arguments as! String
                SystemUtil.callNum(argment)
                self.myResult!(0)
            }else if "shareWx" == call.method{ //分享到微信
                let argument = call.arguments as! String
                self.shareTool!.initShareWx(argument, toResult: self.myResult!)
            }else if "shareQQ" == call.method{
                let argumnts = call.arguments as! Array<String>
                let url = argumnts[0]
                let addressName = argumnts[1]
                self.shareTool!.initShareQQ(url, toContent: addressName, toResult: self.myResult!)
            }else if "shareAlipay" ==  call.method {
                let argument = call.arguments as! String
                self.shareTool!.initShareAlipay(argument, toResult: self.myResult!)
            }else if "getPhoneModel" == call.method {
                let mode =  UIDevice.current.model
                self.myResult!(mode)
                
            }else if "getCity" == call.method{ // 获取城市名称
                let argements =  call.arguments as! NSArray ;
                let  strStartLat = argements.object(at:0)  ;
                let flStartLat = Double("\(strStartLat)");
                let  strStartLng = argements.object(at: 1) ;
                let flStartLng = Double("\(strStartLng)");
                let location = CLLocation.init(latitude: flStartLat!, longitude: flStartLng!)
                let clGeocoder = CLGeocoder.init()
                clGeocoder.reverseGeocodeLocation(location){
                    (placemark,error) -> Void in
                    if(error == nil){
                        let array = placemark! as Array
                        let mark  = array[0]  as! CLPlacemark
                        let city :String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                        self.myResult!(city)
                    }
                    
                    
                }
                
                
            }
        }
 
        
    }
   
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if(response.count != 0){
            let pois = response.pois ;
            var array :Array = Array<Dictionary<String,String>>();
          for amapPoi in pois!
          {
            let lat = amapPoi.location.latitude ;
            let lng = amapPoi.location.longitude ;
            let distance = String.init(amapPoi.distance);
            let description = amapPoi.address;
            let cityDescrible = amapPoi.city + "-" + amapPoi.district ;
            var dic: [String: String] = [:];
            dic["name"] = amapPoi.name;
            dic["lat"] = "\(lat)";
            dic["lng"] = "\(lng)";
            dic["distance"] = distance;
            dic["describle"] = description;
            dic["typeDes"] = amapPoi.type;
            dic["packingType"] = amapPoi.parkingType;
            dic["city"] = cityDescrible;
            array.append(dic);
          }
            let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData
                let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
            let jsonResult = JSONString! as String;
            self.myResult!(jsonResult);
        }else{
            self.myResult!("");
        }
        self.myResult!("");
    }
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        if response.count != 0 {
            var tips = response.tips
            var poiMaps: Array = Array<Dictionary<String,String>>()
            
            for amapTip in tips!{
                let tip = amapTip as! AMapTip
                if tip.location == nil {
                    break
                }
                let lat = tip.location!.latitude
                let strLat = "\(lat)"
                let  lng = tip.location!.longitude
                let strLng = "\(lng)"
                let description = tip.address
                let cityDescrible = tip.district
                var dic: [String: String] = [:];
                dic["name"] = tip.name;
                dic["lat"] = strLat;
                dic["lng"] =  strLng;
                dic["describle"] = description;
                dic["city"] = cityDescrible;
                poiMaps.append(dic)
            }
            let data : NSData! = try? JSONSerialization.data(withJSONObject: poiMaps, options: []) as NSData
                let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
            let jsonResult = JSONString! as String;
            self.myResult!(jsonResult);
        }else {
            self.myResult!("")
            
        }
        

    }
    func initSpeaker() {
        if speakerUtil == nil{
            speakerUtil=SpeakerUtil.init()}
        speakerUtil?.initSpeaker();
    }
    @available(iOS 9.0, *)
    func getAddressBookAction(){
        let status = CNContactStore.authorizationStatus(for:CNEntityType.contacts)
        var contactStore = CNContactStore()
        if status == .notDetermined{
            //请求授权
            contactStore.requestAccess(for: .contacts, completionHandler: { (isRight : Bool,error : Error?) in
                            if isRight {
                                print("授权成功")
                            } else {
                                print("授权失败")
                            }
                        })
                        
        }
        
//        guard status == .authorized else {
//            let contacts = Array<Any>()
//            self.myResult!(contacts)
//            return
//        }
        
       
        if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == CNAuthorizationStatus.notDetermined{// 首次访问通讯录
            
            let contacts = self.fetchContactWithContactSote(contactStore: contactStore)
            
            self.myResult!(contacts)
            
        }else { //非首次访问通讯录
            
            let contacts = self.fetchContactWithContactSote(contactStore: contactStore)
            
            self.myResult!(contacts)
            
        }
                                        
           
        }
    
    @available(iOS 9.0, *)
    func fetchContactWithContactSote(contactStore : CNContactStore) -> Array<Any>?{
        var results = Array<Any>()
        
        if CNContactStore.authorizationStatus(for:CNEntityType.contacts) == CNAuthorizationStatus.authorized{ //有权限
            let keysTofech = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]
            
             let contacts = CNContactFetchRequest(keysToFetch: keysTofech as [CNKeyDescriptor])
            
            
            do {
                try contactStore.enumerateContacts(with: contacts, usingBlock: {(contact :CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    let givenName = contact.givenName
                    let familyName = contact.familyName
                    let phoneNumbers = contact.phoneNumbers
                    
                    for item in phoneNumbers{
                        let phoneNumber = item.value.stringValue
                        var dic: [String:String] = [:]
                        if phoneNumber != nil{
                          dic["name"]="\(givenName)\(familyName)"
                           dic ["phoneNumber"] = phoneNumber
                        }else{
                            
                            dic["name"]="\(givenName)\(familyName)"
                             dic ["phoneNumber"] = ""
                        }
                        
                        results.append(dic)
                    }
                });
                
                
            }catch{
                
                print(error)
                
                
            }
            
            
            
        }else { // 没有权限
            
            print("无权限访问通讯录")
            
            return nil
            
        }
        
        
        
        
        
        return results
    }
    

        
        
    }
    


