class Constants {
  static const String emailOrPhoneRegEx =
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))|(^\d{8}(\,\d{8}){0,2}$)$';
  static const String internationalPhoneRegEx = r'^\00(?:[0-9]●?){6,14}[0-9]$';
}
