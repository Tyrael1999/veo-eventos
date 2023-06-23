import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

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
                  decoration: const InputDecoration(labelText: 'Ubicacion'),
                ),
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
