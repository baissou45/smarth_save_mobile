import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SelectInput extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? initialValue;

  const SelectInput({
    Key? key,
    required this.label,
    required this.items,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _SelectInputState createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          child: Theme(
            data: Theme.of(context).copyWith(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // Add more decoration..
              ),
              items: widget.items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select gender.';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  selectedValue = value; // ✅ Assignation correcte
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(value); // ✅ Appelle le callback
                }
              },
              onSaved: (value) {
                selectedValue = value;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
