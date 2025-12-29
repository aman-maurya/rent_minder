import 'dart:async';
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

class Building extends StatefulWidget {
  final String snackbarMessage;

  const Building({super.key, this.snackbarMessage = ''});

  @override
  State<Building> createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  final database = DatabaseAPI();
  late List<Document> buildings = [];
  bool isLoading = false;
  bool isFabVisible = true;
  bool _snackbarShown = false;
  int limit = 25;
  int offset = 0;
  bool hasMoreData = true;

  final loader = LoadingIndicatorDialog();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      final value = await database.buildingsDataList(limit: limit, offset: offset);
      setState(() {
        buildings.addAll(value.documents);
        offset += limit;
        hasMoreData = value.documents.length == limit;
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
      setState(() {
        _snackbarShown = true;
      });
    }

    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: AppBar(
        title: Text('Buildings', style: Styles.appBarHeading),
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

          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            loadData();
          }

          return true;
        },
        child: buildings.isEmpty && !isLoading
            ? Center(
                child: Text('No buildings found.', style: Styles.listTextColor),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    buildings.clear();
                    offset = 0;
                    hasMoreData = true;
                  });
                  await loadData();
                },
                child: ListView.builder(
                  itemCount: buildings.length + (isLoading ? 25 : 0),
                  itemBuilder: (BuildContext context, index) {
                    if (index < buildings.length) {
                      final building = buildings[index];
                      return buildBuilding(context, building);
                    } else {
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
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/add_building',
                  arguments: {'action': 'Add'},
                );

                _showMessage(context, result);
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

  Widget buildBuilding(BuildContext context, Document building) {
    return ListTile(
      title: Text(
        building.data['name'].toString().toTitleCase(),
        style: Styles.listTextColor,
      ),
      leading: _buildBuildingIcon(building),
      trailing: _buildPopupMenu(context, building),
    );
  }

  Widget _buildBuildingIcon(Document building) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 30,
        child: Image.asset(
          building.data.containsKey('img') ? 'assets/icons/${building.data['img']}' : 'assets/icons/building.png',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, Document building) {
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
          _handleEditBuilding(context, building);
        } else if (value == 'delete') {
          _handleDeleteBuilding(context, building);
        }
      },
    );
  }

  void _showMessage(BuildContext context, Object? result){
    if (!mounted) return;

    // handle result returned from AddBuilding
    if (result is Map && result['ok'] == true) {
      // RESET pagination & data FIRST
      setState(() {
        buildings.clear();
        offset = 0;
        hasMoreData = true;
      });

      loadData();

      final action = result['action'] ?? 'Add';
      SnackbarHelper.showSuccess(
        context,
        action == 'Add'
            ? 'Building added successfully.'
            : 'Building updated successfully.',
      );
    }
  }

  void _handleEditBuilding(BuildContext context, Document building) async {
    final result = await Navigator.pushNamed(context, '/add_building', arguments: {
      'action': 'Update',
      'data': building.data
    });

    _showMessage(context, result);
  }

  void _handleDeleteBuilding(BuildContext context, Document building) async {
    final scaffoldContext = context;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          itemName: building.data['name'].toString().toTitleCase(),
          callback: () async {
            Navigator.of(context).pop();
            loader.show(context);

            try {
              bool success = await database.deleteBuilding(documentId: building.$id);

              if (success) {
                setState(() {
                  buildings.removeWhere((element) => element.$id == building.$id);
                });

                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      SnackbarHelper.showSuccess(scaffoldContext, 'Building deleted successfully.');
                    }
                  });
                }
              } else {
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      SnackbarHelper.showError(scaffoldContext, 'Failed to delete building.');
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
              loader.dismiss();
            }
          },
        );
      },
    );
  }
}
