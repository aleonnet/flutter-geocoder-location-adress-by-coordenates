import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  final Function(List<Address> adresses) onPlotMarker;

  const MyMap({Key key, this.onPlotMarker}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  static const LatLng _center =
      const LatLng(-15.800334421510447, -47.880870178341866);

  bool _normalMap = true;

  LatLng _lastMapPosition = _center;

  void _onMapTypeButtonPressed() => setState(() => _normalMap = !_normalMap);

  void _onAddMarkerButtonPressed() async {
    var adresses = await _getLocation(_lastMapPosition);

    if (adresses != null && adresses.isNotEmpty) {
      var adress = adresses.first;
      setState(() {
        _markers
          ..clear()
          ..add(_plotMarker(
              title:
                  'COD. POSTAL: ${(adress != null) ? adress.postalCode : 'Erro ao buscar'}',
              snipet:
                  '${(adress != null) ? adress.addressLine : 'Erro ao buscar'}'));
      });
    }

    widget.onPlotMarker(adresses);
  }

  Marker _plotMarker(
      {String title,
      String snipet = '',
      BitmapDescriptor bitmapDescriptor = BitmapDescriptor.defaultMarker}) {
    return Marker(
      markerId: MarkerId(_lastMapPosition.toString() + title + snipet),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: title,
        snippet: snipet,
      ),
      icon: bitmapDescriptor,
    );
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    setState(() {
      _markers
        ..clear()
        ..add(_plotMarker(
            title: 'Buscando Posição',
            bitmapDescriptor: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue)));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    try {
      if (!_controller.isCompleted)
        _controller.complete(controller);
      setState(() {
        _markers
          ..clear()
          ..add(_plotMarker(
              title: 'Buscando Posição',
              bitmapDescriptor: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue)));
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void _goToMyPositon() async {
    try {
      LocationData myLocation = await Location().getLocation();
      if (myLocation != null) {
        var latlong = LatLng(myLocation.latitude, myLocation.longitude);
        var positon = CameraPosition(target: latlong, zoom: 15);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(positon));
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Address>> _getLocation(LatLng latLng) async {
    try {
      final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      return addresses;
    } on PlatformException catch (e) {
      print(e.code);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
          height: 400,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: Colors.grey[800],
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 10.0,
                  ),
                  //Aparently Satellite, hybrid or terrain type maps will be not suported in future releases
                  mapType: _normalMap ? MapType.normal : MapType.satellite,
                  markers: _markers,
                  onCameraMove: _onCameraMove,
                  gestureRecognizers: Set()
                    ..add(Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer()))
                    ..add(Factory<ScaleGestureRecognizer>(
                        () => ScaleGestureRecognizer()))
                    ..add(Factory<TapGestureRecognizer>(
                        () => TapGestureRecognizer()))
                    ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
                  myLocationEnabled: true,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: _floatingActionButtons(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _floatingActionButtons()
  {
    return <Widget>[
                FloatingActionButton(
                  mini: true,
                  tooltip: 'Tipo de Mapa',
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.black87,
                  child: const Icon(Icons.map, size: 30.0),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  mini: true,
                  tooltip: 'Fixar Marker',
                  onPressed: _onAddMarkerButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.red[900],
                  child: const Icon(Icons.add_location, size: 30.0),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  mini: true,
                  tooltip: 'Minha Posição',
                  onPressed: _goToMyPositon,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green[900],
                  child: const Icon(Icons.location_searching, size: 30.0),
                ),
              ];
  }

}
