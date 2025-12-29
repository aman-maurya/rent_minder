import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:rent_minder/appwrite/database_api.dart';
import 'package:rent_minder/helpers/validation.dart';
import '../../helpers/snackbar.dart';
import '../../utils/app_style.dart';
import '../../utils/circular_loader.dart';
import '../widgets/button.dart';
import '../widgets/text_box.dart';

class AddBuilding extends StatefulWidget {
  const AddBuilding({super.key});

  @override
  State<AddBuilding> createState() => _AddBuildingState();
}

class _AddBuildingState extends State<AddBuilding> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final aliasController = TextEditingController();
  final addressController = TextEditingController();

  final loader = LoadingIndicatorDialog();
  final database = DatabaseAPI();

  bool isSubmitting = false;
  String action = 'Add';
  String? originalId;

  String? _nameExistsError;
  bool _initialized = false;

  // --------------------------------------------
  // INIT
  // --------------------------------------------
  @override
  void initState() {
    super.initState();

    // FIX clear async error while typing
    nameController.addListener(() {
      if (_nameExistsError != null) {
        setState(() => _nameExistsError = null);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(_loadArguments);
  }

  void _loadArguments(_) {
    if (_initialized || !mounted) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      action = args['action'] ?? 'Add';

      if (action == 'Update') {
        final data = args['data'];
        if (data != null) {
          nameController.text = data['name'] ?? '';
          aliasController.text = data['alias'] ?? '';
          addressController.text = data['address'] ?? '';
          originalId = data[r'$id'] ?? data['id'];
        }
      }
    }

    if (mounted) setState(() {});
  }

  // --------------------------------------------
  // DISPOSE
  // --------------------------------------------
  @override
  void dispose() {
    nameController.dispose();
    aliasController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // --------------------------------------------
  // SUBMIT
  // --------------------------------------------
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    if (mounted) {
      loader.show(context); // FIX only show if mounted
    }

    try {
      final name = nameController.text.trim();
      final alias = aliasController.text.trim();
      final address = addressController.text.trim();

      final exists = await database.buildingExistsByName(
        name: name,
        excludeId: action == 'Update' ? originalId : null,
      );

      if (exists) {
        _safeDismissLoader();

        setState(() {
          _nameExistsError = 'Building name already exists';
          isSubmitting = false;
        });

        _formKey.currentState!.validate();
        return;
      }

      if (action == 'Add') {
        await database.addBuilding(
          name: name,
          alias: alias,
          address: address,
        );
      } else {
        await database.updateBuilding(
          documentId: originalId!,
          data: {
            'name': name,
            'alias': alias,
            'address': address,
          },
        );
      }

      _safeDismissLoader();

      if (mounted) {
        Navigator.pop(context, {'ok': true, 'action': action});
      }
    } catch (_) {
      _safeDismissLoader();
      if (mounted) {
        SnackbarHelper.showError(context, 'Failed to save building.');
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _safeDismissLoader() {
    try {
      loader.dismiss();
    } catch (_) {}
  }

  // --------------------------------------------
  // UI
  // --------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: AppBar(
        title: Text('$action Building', style: Styles.appBarHeading),
        centerTitle: true,
        backgroundColor: Styles.appBgColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 15),

                // ---------- NAME ----------
                TextBoxWidget(
                  controller: nameController,
                  hintText: 'Name*',
                  errorMaxLen: 2,
                  validator: (value) {
                    final baseValidator = ValidationBuilder()
                        .ignoreSpecialChrExpectHyphen()
                        .maxLength(50)
                        .minLength(1)
                        .required()
                        .build();

                    final baseError = baseValidator(value);
                    if (baseError != null) return baseError;

                    return _nameExistsError;
                  },
                  textInputType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                // ---------- ALIAS ----------
                TextBoxWidget(
                  controller: aliasController,
                  hintText: 'Alias*',
                  errorMaxLen: 2,
                  validator: ValidationBuilder()
                      .maxLength(20)
                      .minLength(1)
                      .required()
                      .add((value) {
                    final reg = RegExp(r'^[a-z0-9_]+$');
                    if (value != null && !reg.hasMatch(value)) {
                      return 'Only lowercase letters, numbers & underscores allowed';
                    }
                    return null;
                  })
                      .build(),
                  textInputType: TextInputType.text,
                ),

                const SizedBox(height: 20),

                // ---------- ADDRESS ----------
                TextBoxWidget(
                  controller: addressController,
                  hintText: 'Address (optional)',
                  errorMaxLen: 2,
                  validator: ValidationBuilder(optional: true)
                      .maxLength(200)
                      .build(),
                  textInputType: TextInputType.text,
                ),

                const SizedBox(height: 25),

                ButtonWidget(
                  name: isSubmitting ? 'Processing...' : '$action Building',
                  isDisabled: isSubmitting,
                  onTap: isSubmitting ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

