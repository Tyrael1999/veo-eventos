import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import '../widgets/custom_fast_date_range_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final formKey = GlobalKey<FormState>();
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Crear Evento'),
        FastForm(
          formKey: formKey,
          children: [
            FastTextField(
              name: 'nombre_evento',
              labelText: 'Nombre del evento',
            ),
            FastTextField(
              name: 'nombre_organizacion',
              labelText: 'Agrupación organizadora',
            ),
            FastTextField(
              name: 'descripcion_evento',
              labelText: 'Descripción',
            ),
            FastTextField(
              name: 'ubicacion_evento',
              labelText: 'Ubicación',
            ),
            CustomFastDateRangePicker(
              name: 'hora_evento',
              labelText: 'Inicio - Termino',
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              cancelText: 'Cancelar',
              fieldStartLabelText: 'Fecha inicio',
              fieldEndLabelText: 'Fecha termino',
              helpText: 'Escoge el rango de fechas del evento',
            ),
          ],
        ),
        Text('Agregar imagenes'),
        ElevatedButton.icon(
          onPressed: pickImage,
          icon: Icon(Icons.upload),
          label: Text('Agregar'),
        ),
        Container(
          margin: EdgeInsets.only(top: 16.0),
          child: selectedImage != null
              ? Image.file(selectedImage!)
              : Text('No se ha seleccionado una imagen'),
        ),
      ],
    );
  }
}
