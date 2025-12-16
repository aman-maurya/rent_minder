import 'package:form_validator/form_validator.dart';

extension CustomValidationBuilder on ValidationBuilder {
  // Email validation
  ValidationBuilder isValidEmail() {
    return add((value) {
      final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (value != null) {
        if (emailRegExp.hasMatch(value)) {
          return null;
        }
        return 'Enter valid email address';
      }
      return null;
    });
  }

  // Mobile number validation (10 digits)
  ValidationBuilder isValidMobNo() {
    return add((value) {
      final mobNoRegExp = RegExp(r'^[0-9]{10}$');
      if (value != null) {
        if (mobNoRegExp.hasMatch(value)) {
          return null;
        }
        return 'Enter valid phone number. It should be 10 digits without country code';
      }
      return null;
    });
  }

  // Ignore special characters except hyphen
  ValidationBuilder ignoreSpecialChrExpectHyphen() {
    return add((value) {
      final regExp = RegExp(r'[~!@#$%^&*()_+`{}|<>?;:./,=\\\[\]]');
      if (value != null) {
        if (regExp.hasMatch(value)) {
          return 'Special characters are not allowed except hyphen(-).';
        }
      }
      return null;
    });
  }

  // Allow only numeric values, dot (.) and hyphen (-)
  ValidationBuilder allowOnlyNumericDotHyphen() {
    return add((value) {
      final regExp = RegExp(r'^[0-9.-]+$');
      if (value != null && !regExp.hasMatch(value)) {
        return 'Only numeric values, dot (.) and minus (-) are allowed.';
      }
      return null;
    });
  }
}
