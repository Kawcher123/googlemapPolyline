import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     "",
      //     style: TextStyle(color: Colors.black, fontSize: 16),
      //   ),
      // ),
      body: Obx(()
      {
        if(controller.flag.value==false)
          {
            return const Center(child: CircularProgressIndicator());
          }
        else
          {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(controller.currentLocation.latitude!, controller.currentLocation.longitude!),
                  zoom: 13.5,),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: controller.polylineCoordinates,
                  color: Colors.purpleAccent,
                )
              },
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: controller.currentLocationIcon,
                  position: LatLng(controller.currentLocation.latitude!, controller.currentLocation.longitude!),
                ),
                Marker(markerId: const MarkerId('source'),
                    icon: controller.sourceIcon,
                    position:controller.sourceLocation.value),
                Marker(markerId: const MarkerId('destination'),
                    icon: controller.destinationIcon,
                    position: controller.destination.value),
              },
              onMapCreated: (GoogleMapController c) {
                controller.gController.complete(c);
              },
            );
          }
      }),
    );
  }
}
