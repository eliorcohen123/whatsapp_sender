class Validations {
  static final Validations _singleton = Validations._internal();

  factory Validations() {
    return _singleton;
  }

  Validations._internal();

  bool validatePhone(String value) {
    RegExp regex = RegExp("[0-9]+");
    return regex.hasMatch(value);
  }
}
