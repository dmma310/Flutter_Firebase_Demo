
// Source: https://pub.dev/packages/datetime_picker_formfield/example
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateFieldForm extends StatelessWidget {
  final format = DateFormat.yMMMMd();
  final initialValue = DateTime.now();
  final Function onChanged;
  final Function onSaved;
  MyDateFieldForm(
      {@required this.onChanged,
      @required this.onSaved,});

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      format: format,
      onShowPicker: (context, currentValue) async {
        // Show date picker
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        return date != null ? date :
            currentValue.toString(); // Return currentValue if date is null
      },
      initialValue: initialValue,
      validator: (DateTime value) => value == null ? 'Invalid date' : null,
      onChanged: this.onChanged,
      onSaved: this.onSaved,
    );
  }
}