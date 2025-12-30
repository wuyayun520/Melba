
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let serviceFatalKey:String = "else auto importNet E"
fileprivate let kChemicalAgentName:String = "application server kitrror, "
fileprivate let mainStudState:String = "gain system receive off magnitude size"
fileprivate let serviceVisibleAppearanceAppearVersion:String = "foundationater"

/*: "data" :*/
fileprivate let kFullToken:String = "danarrowa"

/*: ":null" :*/
fileprivate let servicePointerSecret:[Character] = [":","n","u","l","l"]

/*: "json error" :*/
fileprivate let routerCancelValue:String = "json errosystem version version third"
fileprivate let appGlobalFlag:String = "presentation"

/*: "platform=iphone&version= :*/
fileprivate let noti_beltThirdSecret:String = "plstopf"
fileprivate let data_barWhiteMessage:String = "orm=iprint progress white text"
fileprivate let appColorList:String = "make layer zone import&ver"

/*: &packageId= :*/
fileprivate let dataTotalChallengeResult:[Character] = ["&","p","a","c","k","a","g","e","I","d","="]

/*: &bundleId= :*/
fileprivate let constSpinnbarCaptureUrl:String = "import delay&bundl"

/*: &lang= :*/
fileprivate let serviceLabelToken:String = "remove decide&lang="

/*: ; build: :*/
fileprivate let notiKitKey:String = "; bupass progress"

/*: ; iOS  :*/
fileprivate let routerAgentError:String = "; iOS due narrow network element"

//: Declare String End

//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit

//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: PlainFindPublisher?) -> Void

//: @objc class AppRequestTool: NSObject {
@objc class ResultPlain: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func solicitation(model: OkModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.all(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.actionMagnitude(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                group(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)

            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, PlainFindPublisher(errorCode: GeneticFingerprintingIdentity.NetError.rawValue, errorMsg: (String(serviceFatalKey.suffix(5)) + String(kChemicalAgentName.suffix(6)) + "Try a" + String(mainStudState.prefix(5)) + serviceVisibleAppearanceAppearVersion.replacingOccurrences(of: "foundation", with: "l"))))
            }
        }
    }

    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func group(model: OkModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (kFullToken.replacingOccurrences(of: "narrow", with: "t")) + "\"" + (String(servicePointerSecret)), with: "" + "\"" + (kFullToken.replacingOccurrences(of: "narrow", with: "t")) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<OnUpEvery>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == GeneticFingerprintingIdentity.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
                //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, PlainFindPublisher(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case GeneticFingerprintingIdentity.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
            //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, PlainFindPublisher(errorCode: GeneticFingerprintingIdentity.NetError.rawValue, errorMsg: (String(routerCancelValue.prefix(9)) + appGlobalFlag.replacingOccurrences(of: "presentation", with: "r"))))
        }
    }

    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func all(model: OkModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (noti_beltThirdSecret.replacingOccurrences(of: "stop", with: "at") + String(data_barWhiteMessage.prefix(5)) + "phone" + String(appColorList.suffix(4)) + "sion=") + "\(const_itemRequireURL)" + (String(dataTotalChallengeResult)) + "\(constConsentList)" + (String(constSpinnbarCaptureUrl.suffix(6)) + "eId=") + "\(main_meUserList)" + (String(serviceLabelToken.suffix(6))) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")

        //: return serverUrl
        return serverUrl
    }

    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func actionMagnitude(model: OkModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(serviceExcludeMessage)/\(k_deviceFlag) (\(main_meUserList)" + (String(notiKitKey.prefix(4)) + "ild:") + "\(serviceZoneInstallFlag)" + (String(routerAgentError.prefix(6))) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
