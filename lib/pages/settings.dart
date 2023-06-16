import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import '../widgets/custom_fast_date_range_picker.dart';

class SettingsPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
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
          onPressed: () {},
          icon: Icon(Icons.upload),
          label: Text('Agregar'),
        ),
      ],
    );
  }
}
