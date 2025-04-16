import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

class LabeledTextField extends StatefulWidget {
final String label;
final String hint;
final String? defaultValue;
final TextEditingController? controller;

const LabeledTextField({
  required this.label, required this.hint, super.key,
  this.defaultValue,
  this.controller,
});

@override
State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
late final TextEditingController _controller;

@override
void initState() {
  super.initState();
  _controller = widget.controller ?? TextEditingController(text: widget.defaultValue ?? '');
}

@override
void dispose() {
  if (widget.controller == null) {
    _controller.dispose();
  }
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style:const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: _controller,
        decoration: 
        
        InputDecoration(
        fillColor: kSecondColor3,
        filled: true,
          hintText: widget.hint,
          border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide.none,
),      
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
      
        ),
    ],
  );
}
}




// TextFormField(
// controller: controller,
// decoration: InputDecoration(
//   fillColor: kSecondColor3,
//   filled: true,
//   hintText: hint,
  // border: const OutlineInputBorder(
  // borderRadius: BorderRadius.all(Radius.circular(8.0)),
  // borderSide: BorderSide.none,

// ),
//   contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// ),
// ),
