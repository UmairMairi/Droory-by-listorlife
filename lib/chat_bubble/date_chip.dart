import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChip extends StatelessWidget {
  final DateTime date;
  final Color color;

  const DateChip({
    super.key,
    required this.date,
    this.color = const Color(0x558AD3D5),
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 7,
          bottom: 7,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              Algo.dateChipText(date),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class Algo {
  Algo._();

  static String dateChipText(final DateTime date) {
    final dateChipText = DateChipText(date);
    return dateChipText.getText();
  }
}

class DateChipText {
  final DateTime date;

  DateChipText(this.date);

  ///generate and return [DateChip] string
  ///
  ///
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  String getText() {
    final now = DateTime.now();
    if (_formatter.format(now) == _formatter.format(date)) {
      return 'Today';
    } else if (_formatter.format(DateTime(now.year, now.month, now.day - 1)) ==
        _formatter.format(date)) {
      return 'Yesterday';
    } else {
      return '${DateFormat('d').format(date)} ${DateFormat('MMMM').format(date)} ${DateFormat('y').format(date)}';
    }
  }
}
