abstract class LoginInteractor {
  void loginWithMobile(PhoneNumberData phoneNumberData);
}

class PhoneNumberData {
  String? countryText, isoCode, dialCode, phoneNumber, phoneNumberNormalised;

  PhoneNumberData(this.countryText, this.isoCode, this.dialCode,
      this.phoneNumber, this.phoneNumberNormalised);
}
