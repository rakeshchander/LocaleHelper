//
//  LocaleHelper.swift
//
//  Created by Rakesh Chander.
//

import Foundation
import UIKit

public class LocaleHelper: NSObject {
    
    static let appleLanguageKey : String = "AppleLanguages"
    static var defaultAppLanguage : String = "en"
    
    public class func doTheSwizzling() {
        // 1
        methodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedString(forKey:value:table:)))

    }
    
    public class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: appleLanguageKey) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    /// set @lang to be the first in Applelanguages list
    public class func setAppleLanguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: appleLanguageKey)
        userdef.synchronize()
        
        if NSLocale.characterDirection(forLanguage: lang) == .rightToLeft{
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
    }
    
    public class func setDefaultAppLanguageTo(lang: String) {
        defaultAppLanguage = lang
    }
    
    public class func getDefaultAppLanguage() -> String{
        return defaultAppLanguage
    }
    
}

extension Bundle {
    @objc func specialLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let currentLanguage = LocaleHelper.currentAppleLanguage()
        let defaultAppLanguage = LocaleHelper.getDefaultAppLanguage()
        
        let mainBundle : Bundle? = getMainBundlePath(currentLanguage: currentLanguage, defaultLanguage: defaultAppLanguage)
        
        if mainBundle == nil || (mainBundle!.specialLocalizedString(forKey: key, value: value, table: tableName) == key) {
            let callerBundle = getCallerBundlePath(currentLanguage: currentLanguage, defaultLanguage: defaultAppLanguage)
            
            return callerBundle.specialLocalizedString(forKey: key, value: value, table: tableName)
        }
        
        return mainBundle!.specialLocalizedString(forKey: key, value: value, table: tableName);
        
    }
    
    func getMainBundlePath(currentLanguage:String, defaultLanguage:String) -> Bundle?{
        
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else{
            guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj") else{
                
                return nil
            }
            return Bundle(path: path)
        }
        
        return Bundle(path: path)
    }
    
    func getCallerBundlePath(currentLanguage:String, defaultLanguage:String) -> Bundle{
        
        guard let path = self.path(forResource: currentLanguage, ofType: "lproj") else{
            guard let path = self.path(forResource: defaultLanguage, ofType: "lproj") else{
                
                return self
            }
            return Bundle(path: path) ?? self
        }
        
        return Bundle(path: path) ?? self
    }
    
}

public extension String {
    func getLocalisedValue(targetBundle:Bundle, table:String = "Localizable") -> String{
        return targetBundle.localizedString(forKey: self, value: self, table: table)
    }
}
