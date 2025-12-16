import 'dart:async';
import 'dart:convert';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rent_minder/appwrite/database_api.dart';
import 'package:rent_minder/helpers/logger.dart';
import 'package:rent_minder/screen/widgets/confirm_dialog.dart';
import 'package:rent_minder/screen/widgets/shimmer.dart';
import 'package:rent_minder/helpers/string.dart';
import '../../helpers/snackbar.dart';
import '../../utils/app_style.dart';
import '../../utils/circular_loader.dart';

class Amenities extends StatefulWidget {
  final String snackbarMessage;

  const Amenities({super.key, this.snackbarMessage = ''});

  @override
  State<Amenities> createState() => _AmenitiesState();
}

class _AmenitiesState extends State<Amenities> {
  final database = DatabaseAPI();
  late List<Document> amenities = [];
  bool isLoading = false;
  bool isFabVisible = true;
  bool _snackbarShown = false;
  int limit = 25; // Number of items per page
  int offset = 0; // Start from the first page
  bool hasMoreData = true; // To check if there are more records to load

  // Loader instance for showing loading dialog
  final loader = LoadingIndicatorDialog();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if a new amenity was added and reload the list
    final result = ModalRoute.of(context)?.settings.arguments;
    print('aaaa yeh {$result}');
    if (result == true) {
      setState(() {
        amenities.clear();
        offset = 0;
        hasMoreData = true;
      });
      loadData(); // Reload data when returning from Add Amenity
    }
  }

  // Fetch the data with pagination
  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return; // Prevent multiple calls or unnecessary calls

    setState(() {
      isLoading = true;
    });

    try {
      final value = await database.amenitiesDataList(limit: limit, offset: offset);
      setState(() {
        amenities.addAll(value.documents); // Add the fetched amenities to the list
        offset += limit; // Increment the offset for the next fetch
        hasMoreData = value.documents.length == limit; // If the fetched data is less than the limit, there are no more records
      });
    } catch (e) {
      logError(e as Exception);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show snackbar if message exists
    if (widget.snackbarMessage.isNotEmpty && !_snackbarShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          SnackbarHelper.showSuccess(context, widget.snackbarMessage);
        }
      });

      // Set the flag to true to prevent the snackbar from showing again
      setState(() {
        _snackbarShown = true;
      });
    }

    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: AppBar(
        title: Text(
          'Amenities',
          style: Styles.appBarHeading,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Styles.appBgColor,
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!isFabVisible) setState(() => isFabVisible = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            if (isFabVisible) setState(() => isFabVisible = false);
          }

          // Check if the user reached the end of the list to load more data
          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            loadData(); // Load more data when reaching the bottom
          }

          return true;
        },
        child: amenities.isEmpty && !isLoading
            ? Center(
          child: Text(
            'No amenities found.',
            style: Styles.listTextColor,
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            setState(() {
              amenities.clear();
              offset = 0;
              hasMoreData = true;
            });
            await loadData();
          },
          child: ListView.builder(
            itemCount: amenities.length + (isLoading ? 25 : 0), // Show 25 shimmer items when loading
            itemBuilder: (BuildContext context, index) {
              if (index < amenities.length) {
                // Show actual data
                final amenity = amenities[index];
                return buildAmenities(context, amenity);
              } else {
                // Show shimmer effect for loading items
                return buildShimmer();
              }
            },
          ),
        ),
      ),
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
        backgroundColor: Styles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () {
          Navigator.pushNamed(context, '/add_amenity', arguments: {
            'action':'Add'
          });
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget buildShimmer() {
    return const ListTile(
      leading: ShimmerWidget.circular(width: 45, height: 45),
      title: ShimmerWidget.rectangular(height: 16),
    );
  }

  Widget buildAmenities(BuildContext context, Document amenity) {
    return ListTile(
      title: Text(
        amenity.data['name'].toString().toTitleCase(),
        style: Styles.listTextColor,
      ),
      leading: _buildAmenityIcon(amenity),
      trailing: _buildPopupMenu(context, amenity),
    );
  }

  Widget _buildAmenityIcon(Document amenity) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 30,
        child: Image.asset(
          'assets/icons/${amenity.data['img']}',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, Document amenity) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
            value: 'edit',
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.edit),
              title: Text('Edit', style: Styles.popUpMenuTextColor),
            ),
          ),
          PopupMenuItem(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
            value: 'delete',
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.delete),
              title: Text('Delete', style: Styles.popUpMenuTextColor),
            ),
          ),
        ];
      },
      onSelected: (value) async {
        if (value == 'edit') {
          _handleEditAmenity(context, amenity);
        } else if (value == 'delete') {
          _handleDeleteAmenity(context, amenity);
        }
      },
    );
  }

  void _handleEditAmenity(BuildContext context, Document amenity) {
    // Handle edit action
    Navigator.pushNamed(context, '/add_amenity', arguments: {
      'action':'Update',
      'data': amenity.data
    });
  }

  void _handleDeleteAmenity(BuildContext context, Document amenity) async {
    // Common prefix for print statements to identify the operation
    // final String prefix = "[Delete Amenity]";
    final scaffoldContext = context;

    // Show the confirmation dialog before deleting
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          itemName: amenity.data['name'].toString().toTitleCase(), // Pass the amenity name
          callback: () async {
            Navigator.of(context).pop(); // Close the dialog
            loader.show(context); // Show loading indicator

            try {
              bool success = await database.deleteAmenity(documentId: amenity.$id);

              if (success) {
                setState(() {
                  amenities.removeWhere((element) => element.$id == amenity.$id); // Remove amenity from the list
                });

                // Show success Snackbar after the frame is rendered
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      SnackbarHelper.showSuccess(scaffoldContext, 'Amenity deleted successfully.');
                    }
                  });
                }

              } else {
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      SnackbarHelper.showError(scaffoldContext, 'Failed to delete amenity.');
                    }
                  });
                }
              }
            } catch (e) {
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    SnackbarHelper.showError(scaffoldContext, 'Error occurred while deleting.');
                  }
                });
              }
              logError(e as Exception);
            } finally {
              // Ensure loader is dismissed
              loader.dismiss();
            }
          },
        );
      },
    );
  }
}