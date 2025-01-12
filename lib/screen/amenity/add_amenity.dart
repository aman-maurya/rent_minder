import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:rent_minder/utils/extensions/validation.dart';
import '../../appwrite/database_api.dart';
import '../../utils/app_style.dart';
import '../../utils/circular_loader.dart';
import '../widgets/button.dart';
import '../widgets/text_box.dart';

class AddAmenity extends StatefulWidget {
  const AddAmenity({Key? key}) : super(key: key);

  @override
  State<AddAmenity> createState() => _AddAmenityState();
}

class _AddAmenityState extends State<AddAmenity> {

  final TextEditingController amenityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final loader = LoadingIndicatorDialog();
  final database = DatabaseAPI();

  @override
  void dispose() {
    amenityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: AppBar(
        title: Text(
          'Add Amenity',
          style: Styles.appBarHeading,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Styles.appBgColor,
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                TextBoxWidget(
                  controller: amenityController,
                  hintText: 'Amenity Name*',
                  errorMaxLen: 2,
                  validator: ValidationBuilder()
                      .ignoreSpecialChr()
                      .maxLength(50)
                      .build(),
                  textInputType: TextInputType.name,
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                  name: 'Add Amenity',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      loader.show(context);
                      await database.addAmenity(
                          name: amenityController.text.trim()
                      );
                      loader.dismiss();
                      Navigator.of(context).pushNamed('/menu');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
