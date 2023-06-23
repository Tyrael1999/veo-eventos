import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreateEventPage extends StatefulWidget {
  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  Position? _currentPosition;
  String? _currentAddress;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  TextEditingController _ubicacionController = TextEditingController();

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // Los permisos de ubicación han sido concedidos
      // Puedes usar Geolocator.getCurrentPosition() aquí
    } else {
      // Los permisos de ubicación no han sido concedidos
      // Puedes mostrar un mensaje o realizar alguna otra acción
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _currentPosition = await Geolocator.getCurrentPosition();
    _openMap(_currentPosition!.latitude, _currentPosition!.longitude);
    _getAddressFromCoordinates();
  }

  Future<void> _openMap(double lat, double long) async {
    print(long);
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await launchUrlString(googleUrl);
  }

  _getAddressFromCoordinates() async {
    if (_currentPosition != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String formattedAddress =
              '${placemark.street}, ${placemark.locality}';
          setState(() {
            _currentAddress = formattedAddress;
          });
        }

        _ubicacionController.text = _currentAddress ?? '';
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Crear Evento'),
        FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'nombre_evento',
                  decoration:
                      const InputDecoration(labelText: 'Nombre del evento'),
                ),
                FormBuilderTextField(
                  name: 'nombre_organizadora',
                  decoration: const InputDecoration(
                      labelText: 'Agrupación organizadora'),
                ),
                FormBuilderTextField(
                  name: 'descripcion',
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                FormBuilderTextField(
                  name: 'ubicacion',
                  onTap: () {
                    _determinePosition();
                  },
                  controller: _ubicacionController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Ubicación',
                      suffixIcon: Icon(Icons.location_on)),
                ),
                FormBuilderDateTimePicker(
                    name: 'fecha_inicio',
                    format: DateFormat('dd/MM/yyyy HH:mm'),
                    decoration: InputDecoration(
                      labelText: 'Fecha inicio',
                    )),
                FormBuilderDateTimePicker(
                    name: 'fecha_termino',
                    format: DateFormat('dd/MM/yyyy HH:mm'),
                    decoration: InputDecoration(
                      labelText: 'Fecha termino (opcional)',
                    )),
              ],
            )),
        Text('Agregar imagenes'),
        ElevatedButton.icon(
          onPressed: openImages,
          icon: Icon(Icons.upload),
          label: Text('Agregar'),
        ),
        Divider(),
        Text('Imagenes seleccionadas'),
        imagefiles != null
            ? Wrap(
                children: imagefiles!.map((imageone) {
                  return Card(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.file(File(imageone.path)),
                    ),
                  );
                }).toList(),
              )
            : Container()
      ],
    );
  }
}
