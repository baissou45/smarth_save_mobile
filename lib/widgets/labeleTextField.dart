import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:intl/intl.dart';

class LabeledTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String? defaultValue;
  final TextEditingController? controller;
  final bool isDate;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.hint,
    this.defaultValue,
    this.controller,
    this.isDate = false,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.defaultValue ?? '');
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_controller.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: widget.isDate ? () => _selectDate(context) : null,
          child: AbsorbPointer(
            absorbing: widget.isDate,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                fillColor: kSecondColor3,
                filled: true,
                hintText: widget.hint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                suffixIcon: widget.isDate
                    ? const Icon(Icons.calendar_today, size: 18)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
