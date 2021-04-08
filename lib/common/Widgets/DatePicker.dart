import '../Config/Localization/Localize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef void OnDateChange(DateTime dateTime);
typedef void OnTimeChange(TimeOfDay dateTime);
enum CustomeDatePickerMode { date, dateTime }

class DatePicker {
  DatePicker();

  var selectedDate = DateTime.now();
  OnDateChange? onDateChange;
  OnTimeChange? onTimeChange;
  CustomeDatePickerMode? datePickerMode;

  show({
    required BuildContext context,
    required OnDateChange onDateChange,
    required OnTimeChange onTimeChange,
    required CustomeDatePickerMode datePickerMode,
    DateTime? minimumDate,
    DateTime? maximumDate,
    DateTime? selectedDate,
  }) async {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _buildMaterialDatePicker(
            context: context,
            onDateChange: onDateChange,
            onTimeChange: onTimeChange,
            datePickerMode: datePickerMode,
            maximumDate: maximumDate,
            minimumDate: minimumDate,
            selectedDate: selectedDate);

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return _buildCupertinoDatePicker(
          context: context,
          onDateChange: onDateChange,
          selectedDate: selectedDate,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          datePickerMode: datePickerMode,
        );
    }
  }

  /// This builds material date picker in Android
  _buildMaterialDatePicker({
    required BuildContext context,
    required OnDateChange onDateChange,
    required OnTimeChange onTimeChange,
    required CustomeDatePickerMode datePickerMode,
    DateTime? minimumDate,
    DateTime? maximumDate,
    DateTime? selectedDate,
  }) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? this.selectedDate,
      firstDate: minimumDate ?? DateTime(2000),
      lastDate: maximumDate ?? DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null) {
      this.selectedDate = picked;
      if (datePickerMode == CustomeDatePickerMode.dateTime) {
        onDateChange(picked);
        _buildTimePicker(context: context, onTimeChange: onTimeChange);
      } else {
        onDateChange(picked);
      }
    }
  }

  _buildTimePicker(
      {required BuildContext context,
      required OnTimeChange onTimeChange}) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()) ??
            TimeOfDay.now();
    onTimeChange(picked);
  }

  /// This builds cupertion date picker in iOS
  _buildCupertinoDatePicker({
    required BuildContext context,
    required OnDateChange onDateChange,
    required CustomeDatePickerMode datePickerMode,
    DateTime? minimumDate,
    DateTime? maximumDate,
    DateTime? selectedDate,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          onDateChange(this.selectedDate);
                          Navigator.pop(context);
                        },
                        child: Text(Localize.done.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(Localize.cancel.tr),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: datePickerMode == CustomeDatePickerMode.dateTime
                      ? CupertinoDatePickerMode.dateAndTime
                      : CupertinoDatePickerMode.date,
                  onDateTimeChanged: (picked) {
                    this.selectedDate = picked;
                    onDateChange(picked);
                  },
                  initialDateTime: selectedDate ?? this.selectedDate,
                  minimumDate: minimumDate ?? DateTime(2000),
                  maximumDate: maximumDate ?? DateTime(2050),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
