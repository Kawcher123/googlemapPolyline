import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_mao/app/data/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class HomeController extends GetxController {
  //TODO: Implement HomeController
  final Completer<GoogleMapController> gController = Completer();
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  late LocationData currentLocation;
   RxBool flag = false.obs;
     Rx<LatLng> sourceLocation = const LatLng(23.794,90.4043).obs;
     Rx<LatLng> destination = const LatLng(23.763494 ,90.432226).obs;

  BitmapDescriptor currentLocationIcon=BitmapDescriptor.defaultMarker;
  BitmapDescriptor sourceIcon=BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon=BitmapDescriptor.defaultMarker;

  @override
  void onInit() {
    getCurrentLocation();
    setIcon();
    getPolyPoints();
    super.onInit();
  }


  void setIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,"assets/Pin_current_location.png")
        .then((icon)
    {
      currentLocationIcon=icon;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,"assets/Pin_source.png")
        .then((icon)
    {
      sourceIcon=icon;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,"assets/Pin_destination.png")
        .then((icon)
    {
      destinationIcon=icon;
    });
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

     location.getLocation().then((loc) async {
      currentLocation = loc;

      flag.value = true;
    });


    final GoogleMapController googleMapController = await gController.future;


    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLoc.latitude!, newLoc.longitude!),zoom: 13.5)));
    });

  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key, PointLatLng(sourceLocation.value.latitude, sourceLocation.value.longitude), PointLatLng(destination.value.latitude, destination.value.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      print('polycoordinates: $polylineCoordinates');
    }
  }

}
