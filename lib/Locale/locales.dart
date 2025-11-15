import 'dart:async';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String getTranslationOf(String key) {
    return AppConfig.languagesSupported[locale.languageCode]?.values[key] !=
            null
        ? AppConfig.languagesSupported[locale.languageCode]!.values[key]!
        : AppConfig.languagesSupported[AppConfig.languageDefault]
                    ?.values[key] !=
                null
            ? AppConfig
                .languagesSupported[AppConfig.languageDefault]!.values[key]!
            : key;
  }

  static List<Locale> getSupportedLocales() {
    List<Locale> toReturn = [];
    for (String langCode in AppConfig.languagesSupported.keys)
      toReturn.add(Locale(langCode));
    return toReturn;
  }

  String get invalidNumber {
    return getTranslationOf('invalidNumber');
  }

  String get networkError {
    return getTranslationOf('networkError');
  }

  String get register {
    return getTranslationOf('register');
  }

  String get invalidName {
    return getTranslationOf('invalidName');
  }

  String get invalidEmail {
    return getTranslationOf('invalidEmail');
  }

  String get invalidNameAndEmail {
    return getTranslationOf('invalidNameAndEmail');
  }

  String get fullName {
    return getTranslationOf('fullName');
  }

  String get emailAddress {
    return getTranslationOf('emailAddress');
  }

  String get mobileNumber {
    return getTranslationOf('mobileNumber');
  }

  String get verificationText {
    return getTranslationOf('verificationText');
  }

  String get verification {
    return getTranslationOf('verification');
  }

  String get checkNetwork {
    return getTranslationOf('checkNetwork');
  }

  String get invalidOTP {
    return getTranslationOf('invalidOTP');
  }

  String get enterVerification {
    return getTranslationOf('enterVerification');
  }

  String get verificationCode {
    return getTranslationOf('verificationCode');
  }

  String get resend {
    return getTranslationOf('resend');
  }

  String get offlineText {
    return getTranslationOf('resend');
  }

  String get onlineText {
    return getTranslationOf('resend');
  }

  String get goOnline {
    return getTranslationOf('resend');
  }

  String get goOffline {
    return getTranslationOf('resend');
  }

  String get orders {
    return getTranslationOf('orders');
  }

  String get itemSold {
    return getTranslationOf('itemSold');
  }

  String get earnings {
    return getTranslationOf('earnings');
  }

  String get location {
    return getTranslationOf('earnings');
  }

  String get grant {
    return getTranslationOf('earnings');
  }

  String get bodyText1 {
    return getTranslationOf('bodyText1');
  }

  String get bodyText2 {
    return getTranslationOf('bodyText2');
  }

  String get mobileText {
    return getTranslationOf('mobileText');
  }

  String get continueText {
    return getTranslationOf('continueText');
  }

  String get homeText {
    return getTranslationOf('homeText');
  }

  String get account {
    return getTranslationOf('account');
  }

  String get orderText {
    return getTranslationOf('orderText');
  }

  String get tnc {
    return getTranslationOf('tnc');
  }

  String get insight {
    return getTranslationOf('insight');
  }

  String get wallet {
    return getTranslationOf('wallet');
  }

  String get support {
    return getTranslationOf('support');
  }

  String get aboutUs {
    return getTranslationOf('aboutUs');
  }

  String get login {
    return getTranslationOf('login');
  }

  String get logout {
    return getTranslationOf('logout');
  }

  String get loggingOut {
    return getTranslationOf('loggingOut');
  }

  String get areYouSure {
    return getTranslationOf('areYouSure');
  }

  String get yes {
    return getTranslationOf('yes');
  }

  String get no {
    return getTranslationOf('no');
  }

  String get sendToBank {
    return getTranslationOf('sendToBank');
  }

  String get availableBalance {
    return getTranslationOf('availableBalance');
  }

  String get accountHolderName {
    return getTranslationOf('accountHolderName');
  }

  String get bankName {
    return getTranslationOf('bankName');
  }

  String get branchCode {
    return getTranslationOf('branchCode');
  }

  String get accountNumber {
    return getTranslationOf('accountNumber');
  }

  String get enterAmountToTransfer {
    return getTranslationOf('enterAmountToTransfer');
  }

  String get bankInfo {
    return getTranslationOf('bankInfo');
  }

  String get companyPolicy {
    return getTranslationOf('companyPolicy');
  }

  String get termsOfUse {
    return getTranslationOf('termsOfUse');
  }

  String get message {
    return getTranslationOf('message');
  }

  String get enterMessage {
    return getTranslationOf('enterMessage');
  }

  String get orWrite {
    return getTranslationOf('orWrite');
  }

  String get yourWords {
    return getTranslationOf('yourWords');
  }

  String get online {
    return getTranslationOf('online');
  }

  String get recent {
    return getTranslationOf('recent');
  }

  String get vegetable {
    return getTranslationOf('vegetable');
  }

  String get today {
    return getTranslationOf('today');
  }

  String get viewAll {
    return getTranslationOf('viewAll');
  }

  String get editProfile {
    return getTranslationOf('editProfile');
  }

  String get featureImage {
    return getTranslationOf('featureImage');
  }

  String get uploadPhoto {
    return getTranslationOf('uploadPhoto');
  }

  String get profileInfo {
    return getTranslationOf('profileInfo');
  }

  String get gender {
    return getTranslationOf('gender');
  }

  String get documentation {
    return getTranslationOf('documentation');
  }

  String get govtID {
    return getTranslationOf('govtID');
  }

  String get upload {
    return getTranslationOf('upload');
  }

  String get updateInfo {
    return getTranslationOf('updateInfo');
  }

  String get instruction {
    return getTranslationOf('instruction');
  }

  String get cod {
    return getTranslationOf('cod');
  }

  String get store {
    return getTranslationOf('store');
  }

  String get ready {
    return getTranslationOf('ready');
  }

  String get storeText {
    return getTranslationOf('storeText');
  }

  String get storeProfile {
    return getTranslationOf('storeProfile');
  }

  String get top {
    return getTranslationOf('top');
  }

  String get payment {
    return getTranslationOf('payment');
  }

  String get service {
    return getTranslationOf('service');
  }

  String get sub {
    return getTranslationOf('sub');
  }

  String get total {
    return getTranslationOf('total');
  }

  String get sales {
    return getTranslationOf('sales');
  }

  String get tomato {
    return getTranslationOf('tomato');
  }

  String get onion {
    return getTranslationOf('onion');
  }

  String get fingers {
    return getTranslationOf('fingers');
  }

  String get closingTime {
    return getTranslationOf('closingTime');
  }

  String get openingTime {
    return getTranslationOf('openingTime');
  }

  String get storeTimings {
    return getTranslationOf('storeTimings');
  }

  String get storeAddress {
    return getTranslationOf('storeAddress');
  }

  String get address {
    return getTranslationOf('address');
  }

  String get category {
    return getTranslationOf('category');
  }

  String get product {
    return getTranslationOf('product');
  }

  String get pending {
    return getTranslationOf('pending');
  }

  String get item {
    return getTranslationOf('item');
  }

  String get add {
    return getTranslationOf('add');
  }

  String get edit {
    return getTranslationOf('edit');
  }

  String get info {
    return getTranslationOf('info');
  }

  String get title {
    return getTranslationOf('title');
  }

  String get enterTitle {
    return getTranslationOf('enterTitle');
  }

  String get itemCategory {
    return getTranslationOf('itemCategory');
  }

  String get selectCategory {
    return getTranslationOf('selectCategory');
  }

  String get price {
    return getTranslationOf('price');
  }

  String get enterPrice {
    return getTranslationOf('enterPrice');
  }

  String get quantity {
    return getTranslationOf('quantity');
  }

  String get enterQuantity {
    return getTranslationOf('enterQuantity');
  }

  String get addMore {
    return getTranslationOf('addMore');
  }

  String get image {
    return getTranslationOf('image');
  }

  String get newOrder {
    return getTranslationOf('newOrder');
  }

  String get pastOrder {
    return getTranslationOf('pastOrder');
  }

  String get vegetables {
    return getTranslationOf('vegetables');
  }

  String get fruits {
    return getTranslationOf('fruits');
  }

  String get herbs {
    return getTranslationOf('herbs');
  }

  String get dairy {
    return getTranslationOf('dairy');
  }

  String get items {
    return getTranslationOf('items');
  }

  String get heyThere {
    return getTranslationOf('heyThere');
  }

  String get onMyWay {
    return getTranslationOf('onMyWay');
  }

  String get deliveryPartner {
    return getTranslationOf('deliveryPartner');
  }

  String get orderNumber {
    return getTranslationOf('orderNumber');
  }

  String get display {
    return getTranslationOf('display');
  }

  String get darkMode {
    return getTranslationOf('darkMode');
  }

  String get darkText {
    return getTranslationOf('darkText');
  }

  String get selectLanguage {
    return getTranslationOf('language');
  }

  String get name1 {
    return getTranslationOf('name1');
  }

  String get name2 {
    return getTranslationOf('name2');
  }

  String get content1 {
    return getTranslationOf('content1');
  }

  String get content2 {
    return getTranslationOf('content2');
  }

  String get hey {
    return getTranslationOf('hey');
  }

  String get or {
    return getTranslationOf('or');
  }

  String get continueWith {
    return getTranslationOf('continueWith');
  }

  String get facebook {
    return getTranslationOf('facebook');
  }

  String get google {
    return getTranslationOf('google');
  }

  String get apple {
    return getTranslationOf('apple');
  }

  String get settings {
    return getTranslationOf('settings');
  }

  String get review {
    return getTranslationOf('review');
  }

  String get setLocation {
    return getTranslationOf('setLocation');
  }

  String get enterLocation {
    return getTranslationOf('enterLocation');
  }

  String get submit {
    return getTranslationOf('submit');
  }

  String get accepted {
    return getTranslationOf('accepted');
  }

  String get lightText {
    return getTranslationOf('lightText');
  }

  String get lightMode {
    return getTranslationOf('lightMode');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppConfig.languagesSupported.keys.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
