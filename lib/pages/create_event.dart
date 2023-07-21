import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:veo_eventos/app_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});
  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Position? _currentPosition;
  String? _currentAddress;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  TextEditingController _ubicacionController = TextEditingController();

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (imagefiles!.isNotEmpty) {
        imagefiles?.addAll(pickedfiles);
        setState(() {});
      } else if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  takePhoto() async {
    List<XFile>? images = [];
    if (imagefiles!.isNotEmpty) {
      images = imagefiles;
    }
    try {
      var photo = await imgpicker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        images?.add(photo);
        imagefiles = images;
        setState(() {});
      } else {
        print("No photo was taken.");
      }
    } catch (e) {
      print("error while taking photo.");
    }
  }

  @override
  void initState() {
    super.initState();
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
        } else {
          // Handle case when placemarks list is empty or null
          setState(() {
            _currentAddress = "No se pudo obtener la dirección.";
          });
        }

        _ubicacionController.text = _currentAddress ?? '';
      } catch (e) {
        print(e);
        // Handle any errors that occurred during the geocoding process
        setState(() {
          _currentAddress = "Error al obtener la dirección.";
        });
      }
    } else {
      // Handle case when _currentPosition is null
      setState(() {
        _currentAddress = "Ubicación desconocida.";
      });
    }
  }

  @override
  void dispose() {
    _ubicacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    String nombreEvento = "",
        nombreOrganizadora = "",
        descripcion = "",
        ubicacion = "",
        fechaInicio = "",
        fechaTermino = "";
    return Column(
      children: [
        Text('Crear Evento'),
        FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                    onSaved: (value) {
                      nombreEvento = value!;
                    },
                    name: 'nombre_evento',
                    decoration:
                        const InputDecoration(labelText: 'Nombre del evento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe incluir nombre del evento';
                      }
                      return null;
                    }),
                FormBuilderTextField(
                    onSaved: (value) {
                      nombreOrganizadora = value!;
                    },
                    name: 'nombre_organizadora',
                    decoration: const InputDecoration(
                        labelText: 'Agrupación organizadora'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe incluir nombre de organizadora';
                      }
                      return null;
                    }),
                FormBuilderTextField(
                    onSaved: (value) {
                      descripcion = value!;
                    },
                    name: 'descripcion',
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe incluir una descripcion';
                      }
                      return null;
                    }),
                FormBuilderTextField(
                    onSaved: (value) {
                      ubicacion = value!;
                    },
                    name: 'ubicacion',
                    onTap: () {
                      _determinePosition();
                    },
                    controller: _ubicacionController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Ubicación',
                        suffixIcon: Icon(Icons.location_on)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe incluir una ubicacion';
                      }
                      return null;
                    }),
                FormBuilderDateTimePicker(
                    onSaved: (value) {
                      fechaInicio = value.toString();
                    },
                    name: 'fecha_inicio',
                    format: DateFormat('dd/MM/yyyy HH:mm'),
                    decoration: InputDecoration(
                      labelText: 'Fecha inicio',
                    ),
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return 'Debe incluir una fecha de inicio';
                      }
                      return null;
                    }),
                FormBuilderDateTimePicker(
                    onSaved: (value) {
                      fechaTermino = value.toString();
                    },
                    name: 'fecha_termino',
                    format: DateFormat('dd/MM/yyyy HH:mm'),
                    decoration: InputDecoration(
                      labelText: 'Fecha termino',
                    ),
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return 'Debe incluir una fecha de termino';
                      }
                      return null;
                    }),
              ],
            )),
        Text('Agregar imagenes'),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: openImages,
                icon: Icon(Icons.upload),
                label: Text('Agregar'),
              ),
              ElevatedButton.icon(
                onPressed: takePhoto,
                icon: Icon(Icons.camera_alt),
                label: Text('Subir foto'),
              ),
            ],
          ),
        ),
        Divider(),
        Text('Imagenes seleccionadas'),
        (imagefiles != null && imagefiles!.isNotEmpty
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
            : Container()),
        ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              appState.createEvent(nombreEvento, nombreOrganizadora,
                  descripcion, ubicacion, fechaInicio, fechaTermino);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guardando evento')),
              );
              _formKey.currentState
                  ?.reset(); // Agregamos esta línea para limpiar el formulario
              // También puedes restablecer las imágenes seleccionadas
              setState(() {
                imagefiles = null;
              });
            }
          },
          icon: Icon(Icons.save),
          label: Text('Guardar'),
        ),
      ],
    );
  }
}
