import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: unused_import
import 'package:location/location.dart' as location;

import '../model/location.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  PlaceLocation initialLocation;
  final bool isSelecting;
  final bool isEnable;

  MapScreen(
      {this.initialLocation = const PlaceLocation(latitude: -6.235918, longitude: 106.782708),
      this.isSelecting = false,
      this.isEnable = true});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  List<Placemark> placemarks;
  String namaAlamat;
  // ignore: unused_field
  Position _currentPosition;
  GoogleMapController mapController;
  void _selectLocation(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _currentPosition = null;

      _pickedLocation = position;
      namaAlamat = placemarks[0].street;
    });
  }

  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // Store the position in the variable
      _currentPosition = position;

      // For moving the camera to current location
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              var hasil = [_pickedLocation, namaAlamat];
              if (_pickedLocation != null) {
                Navigator.of(context).pop(hasil);
              }
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isEnable == false ? null : _selectLocation,
        markers: (_pickedLocation == null && widget.isSelecting == false)
            // ignore: sdk_version_set_literal
            ? {}
            // ignore: sdk_version_set_literal
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
