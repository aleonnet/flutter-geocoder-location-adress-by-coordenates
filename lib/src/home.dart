import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'map.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Address> adresses = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
          body: ListView(
        children: <Widget>[
          MyMap(
            onPlotMarker: _onPlotMarker,
          ),
          SizedBox(height: 20,),
          Card(
            color: Colors.grey,
            child: ExpansionTile(
              leading: Icon(FontAwesomeIcons.map, size: 50,),
              title: Text('Possíveis Endereços para as cordenadas', style: TextStyle(fontWeight: FontWeight.bold), ),
              children: List.generate(this.adresses.length,
                  (index) => _buildExpansionTiles(index + 1, this.adresses[index]))),
          ),
        ],
      )),
    );
  }

  void _onPlotMarker(List<Address> adresses) {
    if (adresses != null && adresses.isNotEmpty) {
      setState(() {
        this.adresses
          ..clear()
          ..addAll(adresses);
      });
    }
  }

  Widget _getListTile(String title, String content, {IconData icon = Icons.not_listed_location }) {
    return Card(
      borderOnForeground: true,
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, size: 50,),
        title: Text('$title'),
        subtitle: Text('$content'),
      ),
    );
  }

  Widget _buildExpansionTiles(
    int index,
    Address address,
  ) {
    return Card(
      borderOnForeground: true,
      elevation: 1,
      color: Colors.black12,
      child: ExpansionTile(
        leading: Icon(FontAwesomeIcons.mapMarked, size: 40,),
        key: PageStorageKey<Address>(address),
        title: Text('Address | Endereço - $index', style: TextStyle(fontWeight: FontWeight.bold), ),
        children: [
          _getListTile('Coordinates | Coordenadas', address.coordinates.toString(), icon: FontAwesomeIcons.mapMarkedAlt),
          _getListTile('Country Code | Código País', address.countryCode, icon: FontAwesomeIcons.globe),
          _getListTile('Country Name | Nome País', address.countryName, icon: FontAwesomeIcons.atlas),
          _getListTile('Admin Area | Estado', address.adminArea, icon: FontAwesomeIcons.mapMarkerAlt),
          _getListTile('Sub Admin Area | Município ? Distrito?', address.subAdminArea, icon: Icons.location_on),
          _getListTile('Locality | Localidade ?', address.locality, ),
          _getListTile('Sub Locality | Bairro', address.subLocality, icon: FontAwesomeIcons.mapPin),
          _getListTile('Adress Line | Endereço', address.addressLine, icon: FontAwesomeIcons.mapSigns),
          _getListTile('Feature Name | Nº?', address.featureName,),
          _getListTile('Postal Code | CEP', address.postalCode, icon: FontAwesomeIcons.mailBulk),
          _getListTile('Thoroughfare | Rua', address.thoroughfare, icon: FontAwesomeIcons.road),
          _getListTile('Sub Thoroughfare | Nº?', address.subThoroughfare,),
        ],
      ),
    );
  }
}
