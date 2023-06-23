import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEventPage extends StatefulWidget {
  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  Position? _currentPosition;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;

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

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
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
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: Icon(Icons.location_on),
                  label: Text(''),
                ),
                if (_currentPosition != null)
                  Text(
                      "LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}"),
                FormBuilderDateTimePicker(
                    name: 'date_established',
                    format: DateFormat('dd/MM/yyyy'),
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
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
