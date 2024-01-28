import 'package:form_validator/form_validator.dart';

extension CustomValidationBuilder on ValidationBuilder {
  isValidEmail() => add((value) {
    final emailRegExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if(value != null){
      if(emailRegExp.hasMatch(value)){
        return null;
      }
      return 'Enter valid email address';
    }
    return null;
  });

  isValidMobNo() => add((value) {
    final emailRegExp = RegExp(r'^[0-9]{10}$');
    if(value != null){
      if(emailRegExp.hasMatch(value)){
        return null;
      }
      return 'Enter valid phone number. '
          'It should be 10 digit without country code';
    }
    return null;
  });

  ignoreSpecialChr() => add((value) {
    final emailRegExp = RegExp(r'[~!@#$%^&*()_+`{}|<>?;:./,=\\\[\]]');
    if(value != null){
      if(emailRegExp.hasMatch(value)){
        return 'Special character are not allowed except hyphen(-).';
      }
    }
    return null;
  });
}