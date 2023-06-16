import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_fast_forms/flutter_fast_forms.dart' as picker;

class CustomFastDateRangePicker extends StatefulWidget {
  final String name;
  final String labelText;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? cancelText;
  final String? fieldStartLabelText;
  final String? fieldEndLabelText;
  final String? helpText;

  const CustomFastDateRangePicker({
    required this.name,
    required this.labelText,
    required this.firstDate,
    required this.lastDate,
    this.cancelText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.helpText,
  });

  @override
  _CustomFastDateRangePickerState createState() =>
      _CustomFastDateRangePickerState();
}

class _CustomFastDateRangePickerState extends State<CustomFastDateRangePicker> {
  final intl.DateFormat _dateFormat = intl.DateFormat('dd/MM/yyyy');
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return picker.FastDateRangePicker(
      name: widget.name,
      labelText: widget.labelText,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      cancelText: widget.cancelText,
      fieldStartLabelText: widget.fieldStartLabelText,
      fieldEndLabelText: widget.fieldEndLabelText,
      helpText: widget.helpText,
      textBuilder: (picker.FastDateRangePickerState field) {
        final value = field.value ?? _selectedRange!;
        final startDate = value.start;
        final endDate = value.end;

        final formattedStartDate =
            startDate != null ? _dateFormat.format(startDate) : '';
        final formattedEndDate =
            endDate != null ? _dateFormat.format(endDate) : '';

        return Text(
          '$formattedStartDate - $formattedEndDate',
          style: field.enabled
              ? field.widget.textStyle
              : field.widget.textStyle?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          textAlign: TextAlign.left,
        );
      },
      onChanged: (DateTimeRange? value) {
        setState(() {
          _selectedRange = value;
        });
      },
    );
  }
}
