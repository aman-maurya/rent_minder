import 'package:flutter/material.dart';
import 'package:rent_minder/helpers/logger.dart';
import 'app_style.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton = LoadingIndicatorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  show(BuildContext context, {String text = ''}) {
    if(isDisplayed) {
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
            child:
              Container(
                //width: text.isNotEmpty ? 120 : 0,
                //height: text.isNotEmpty ? 120 : 0,
                decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      )
                    ]
                ),
                child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
                            child: CircularProgressIndicator(
                              color: Styles.primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(text,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.grey.shade800,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 1.2,
                              )
                            ),
                          )
                        ],
                      ),
                    ),
              )
            ),
          );
        }
    );
  }

  dismiss() {
    if (isDisplayed && _context.mounted) {
      try {
        Navigator.of(_context, rootNavigator: true).pop();
        isDisplayed = false;
      } catch (e) {
        logError(e as Exception);
      }
    }
  }
}