class InputValidation {

  bool validateEmail(input) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);

    return emailValid;
  }

  validateName(input) {
    var nameValid = input.length;
    if (nameValid > 5) {
      return true;
    }
    return false;
  }

  bool validatePhoneNumber(input) {
    bool phoneNumber = RegExp(r'(^(?:[+][0-9]{1,3})?[0-9]{8,15}$)').hasMatch(input);
 
    return phoneNumber;
  }
}
