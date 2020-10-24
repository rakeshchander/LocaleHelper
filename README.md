# LocaleHelper

Localization is present in most of the iOS apps now a days. This file helps to cover specific scenario where —

- App has “Localization” option in itself
- And App Content should be updated instantly without asking user to Re-Launch manually
- If you are developing a framework and want to allow app developers to override strings used in framework

Add this class into your project and move to AppDelegate class. Add below code in “func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool” —

```
LocaleHelper.doTheSwizzling()
```

And Thats it, you are done.

Now, when user changes app from inside of your app screen — You can update your app language by adding below line —

```
LocaleHelper.setAppleLanguageTo(lang:<LANGUAGE_CODE>)
```

Now, to reflect changes in app, WITHOUT MANUAL RELAUNCH, just reset your app window to your App’s initial ViewController —

```
appDelegate.window?.rootViewController = targetVC
```

You will see that App Language has got updated and its LTR / RTL has also been updated.

LocaleHelper class has Stirng Extension which you can use to get Localised Values of Any String. If that String has been declared in lproj files, then respective value will be returned otherwise that String itself will be returned.

```
<STRING>.getLocalisedValue()
```

If you are using this inside any framework and you want to give your framework consumers a feature that if they want to override framework strings, then they just declare those string keys in their app and give required values. In that scenario, framework will start picking up strings from consumer app. In framework, you just need to make sure that you specify framework bundle in method call “getLocalisedValue”.

```
<STRING>.getLocalisedValue(targetBundle: Constants.sdkBundle)
```

Thats It!! Now you can have Multi-Lingual App, which doesn’t need to be re-launched manually after changing language from app listing screen.
