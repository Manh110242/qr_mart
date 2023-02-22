//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/validators/enum.dart';

//*--App Colors : Replace with your own colours---
//----------- WHATSAPP Color Theme: -------------------------
final fiberchatBlack = new Color(0xFF1E1E1E);
final fiberchatBlue = new Color(0xFF25D366);
final fiberchatDeepGreen = new Color(0xFF075E54);
final fiberchatLightGreen = new Color(0xFF23c86e);
final fiberchatgreen = new Color(0xFF128C7E);
final fiberchatteagreen = new Color(0xFFDCF8C6);
final fiberchatWhite = Colors.white;
final fiberchatGrey = Colors.grey;
final fiberchatChatbackground = new Color(0xffe5ddd5);
const IsSplashOnlySolidColor = false;
const SplashBackgroundSolidColor = Color(
    0xFF005f56); //applies this colors if "IsSplashOnlySolidColor" is set to true. Color Code: 0xFF005f56 for Whatsapp theme & 0xFFFFFFFF for messenger theme.
const DESIGN_TYPE = Themetype.whatsapp;

/// Whatsapp design uses all the above colors with a deep theme whereas Messenger design is a simple white design that uses only these colors: fiberchatgreen, fiberchatlightgreen, fiberchatteagreen,fiberchatblack, fiberchatgrey. Kindly choose your prefered theme & colors accordingly.

///--------
///--------
///--------- MESSENGER Color Theme: --------------- Remove below comments for Messenger theme ------------
// final fiberchatBlack = new Color(0xFF353f58);
// final fiberchatBlue = new Color(0xFF3d9df5);
// final fiberchatDeepGreen = new Color(0xFF296ac6);
// final fiberchatLightGreen = new Color(0xFF036eff);
// final fiberchatgreen = new Color(0xFF06a2ff);
// final fiberchatteagreen = new Color(0xFFe0eaff);
// final fiberchatWhite = Colors.white;
// final fiberchatGrey = Colors.grey;
// final fiberchatChatbackground = new Color(0xffdde6ea);
// const IsSplashOnlySolidColor = false;
// const SplashBackgroundSolidColor = Color(
//     0xFFFFFFFF); //applies this colors if "IsSplashOnlySolidColor" is set to true. Color Code: 0xFF005f56 for Whatsapp theme & 0xFFFFFFFF for messenger theme.
// const DESIGN_TYPE = Themetype.messenger;

//*--Admob Configurations- (By default Test Ad Units pasted)----------
const IsBannerAdShow =
    false; // Set this to 'true' if you want to show Banner ads throughout the app
const Admob_BannerAdUnitID_Android = 'ca-app-pub-3940256099942544/6300978111';
const Admob_BannerAdUnitID_Ios = 'ca-app-pub-3940256099942544/2934735716';
const IsInterstitialAdShow =
    false; // Set this to 'true' if you want to show Interstitial ads throughout the app
const Admob_InterstitialAdUnitID_Android =
    'ca-app-pub-3940256099942544/1033173712';
const Admob_InterstitialAdUnitID_Ios = 'ca-app-pub-3940256099942544/4411468910';
const IsVideoAdShow =
    false; // Set this to 'false' if you want to show Video ads throughout the app
const Admob_RewardedAdUnitID_Android = 'ca-app-pub-3940256099942544/5224354917';
const Admob_RewardedAdUnitID_Ios = 'ca-app-pub-3940256099942544/1712485313';

//*--Agora Configurations---
const Agora_APP_IDD =
    'a35803aaf588423bb865927aad7ace25'; //Grab it from: https://www.agora.io/en/
const dynamic Agora_TOKEN =
    null; // not required until you have planned to setup high level of authentication of users in Agora.

//*--Giphy Configurations---
const GiphyAPIKey =
    'wV4fYXYXP33ArZCBkiokRj8RC4OpiycG'; //Grab it from: https://developers.giphy.com/

//*--App Configurations---
const Appname =
    'QR Mart'; //app name shown evrywhere with the app where required
const DEFAULT_COUNTTRYCODE_ISO =
    'US'; //default country ISO 2 letter for login screen
const DEFAULT_COUNTTRYCODE_NUMBER =
    '+1'; //default country code number for login screen
const FONTFAMILY_NAME =
    null; // make sure you have registered the font in pubspec.yaml

//--WARNING----- PLEASE DONT EDIT THE BELOW LINES UNLESS YOU ARE A DEVELOPER -------
const SplashPath = 'assets/images/splash.jpeg';
const AppLogoPath = 'assets/images/applogo.png';
