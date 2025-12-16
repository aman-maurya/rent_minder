import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:rent_minder/helpers/validation.dart';
import '../../appwrite/database_api.dart';
import '../../helpers/logger.dart';
import '../../helpers/snackbar.dart';
import '../../utils/app_style.dart';
import '../../utils/circular_loader.dart';
import '../widgets/button.dart';
import '../widgets/text_box.dart';
import 'amenities.dart';

class AddAmenity extends StatefulWidget {
  const AddAmenity({super.key});

  @override
  _AddAmenityState createState() => _AddAmenityState();
}

class _AddAmenityState extends State<AddAmenity> {
  final TextEditingController amenityNameController = TextEditingController();
  final TextEditingController amenityPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final loader = LoadingIndicatorDialog();
  final database = DatabaseAPI();
  bool isSubmitting = false;
  late String action = 'Add';

  @override
  void dispose() {
    amenityNameController.dispose();
    amenityPriceController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if a new amenity was added and reload the list
    final result = ModalRoute.of(context)?.settings.arguments;
    if (result != null && result is Map<String, dynamic>) {
      // Set the name in the text field
      setState(() => action = result['action'] ?? '');
      if(action == 'Update') {
        amenityNameController.text = result['data']['name'] ?? '';
        amenityPriceController.text = result['data']['price'].toString() ?? '';
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarHelper.showError(context, 'Something went wrong.');
      });
    }
  }

  Future<void> _addAmenity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);
    loader.show(context);

    try {
      final price = _parsePrice(amenityPriceController.text);
      await database.addAmenity(
        name: amenityNameController.text.trim(),
        price: price,
      );
      loader.dismiss();
      _navigateToAmenities();
    } catch (e) {
      _handleError(e as Exception);
    } finally {
      _resetState();
    }
  }

  double _parsePrice(String priceText) {
    return priceText.trim().isEmpty ? 0.0 : double.parse(priceText.trim());
  }

  void _navigateToAmenities() {
    if (mounted) {
      //Navigator.of(context).popUntil(ModalRoute.withName('/amenities'));
      Navigator.pop(context, {'added': true});
      SnackbarHelper.showSuccess(context, 'Amenity added successfully!');
    }
  }

  void _handleError(Exception e) {
    if (mounted) {
      SnackbarHelper.showError(context, 'Failed to add amenity.');
    }
    logError(e);
  }

  void _resetState() {
    //loader.dismiss();
    if (mounted) {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: AppBar(
        title: Text('$action Amenity', style: Styles.appBarHeading),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Styles.appBgColor,
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildAmenityNameField(),
                const SizedBox(height: 20),
                _buildAmenityPriceField(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityNameField() {
    return TextBoxWidget(
      controller: amenityNameController,
      hintText: 'Amenity Name*',
      errorMaxLen: 2,
      validator: ValidationBuilder()
          .ignoreSpecialChrExpectHyphen()
          .maxLength(50)
          .minLength(3)
          .build(),
      textInputType: TextInputType.name,
    );
  }

  Widget _buildAmenityPriceField() {
    return TextBoxWidget(
      controller: amenityPriceController,
      hintText: 'Amenity Price (defaulted to 0.0)',
      errorMaxLen: 2,
      validator: ValidationBuilder(optional: true)
          .allowOnlyNumericDotHyphen()
          .build(),
      textInputType: TextInputType.number,
    );
  }

  Widget _buildSubmitButton() {
    return ButtonWidget(
      name: isSubmitting ? 'Processing...' : '$action Amenity',
      onTap: isSubmitting ? null : _addAmenity,
      isDisabled: isSubmitting,
    );
  }
}
