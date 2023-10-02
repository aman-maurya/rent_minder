import 'dart:async';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rent_minder/appwrite/database_api.dart';
import 'package:rent_minder/screen/widgets/shimmer.dart';
import '../utils/app_style.dart';
import 'widgets/app_bar.dart';

class Amenities extends StatefulWidget {
  const Amenities({Key? key}) : super(key: key);

  @override
  State<Amenities> createState() => _AmenitiesState();
}

class _AmenitiesState extends State<Amenities> {
  final database = DatabaseAPI();
  late List<Document>? amenities = [];
  late bool isLoading;
  bool isFabVisible = true;

  @override
  void initState(){
    isLoading = true;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => isLoading = false);
    });
    super.initState();
    loadData();
  }

  loadData() async{
    try {
      final value = await database.amenitiesDataList();
      setState(() {
        amenities = value.documents;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings?.arguments as Map<String, String>;
    final title = routeArgs['title'].toString();
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: MyAppBar(title: title),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification){
          if(notification.direction == ScrollDirection.forward){
            if(!isFabVisible) setState(() => isFabVisible = true);
          }else if(notification.direction == ScrollDirection.reverse){
            if(isFabVisible) setState(() => isFabVisible = false);
          }
          return true;
        },
        child: Center(
          child: ListView.builder(
            itemCount: amenities?.length ?? 0,
            itemBuilder: (BuildContext context, index) {
              if (isLoading){
                return buildShimmer();
              } else {
                final amenity = amenities![index];
                return buildAmenities(amenity);
              }
            }
          ),
        ),
      ),
      floatingActionButton: isFabVisible ? FloatingActionButton(
        backgroundColor: Styles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () {
          // Respond to button press
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}

Widget buildShimmer(){
  return const ListTile(
    leading: ShimmerWidget.circular(
        width: 45,
        height: 45
    ),
    title: ShimmerWidget.rectangular(height: 16),
  );
}

Widget buildAmenities(amenity){
  return ListTile(
    title:  Text(amenity.data['name'], style: Styles.listTextColor,),
    leading: Container(
      decoration:BoxDecoration(
          color: Styles.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(25))
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 30,
        child: Image.asset('assets/icons/${amenity.data['img']}', color: Colors.white,),
      ),
    ),
  );
}