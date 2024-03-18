// import 'package:flutter/material.dart';

// enum ColorLabel {
//   blue('Blue', Colors.blue),
//   red('Red', Colors.red);

//   const ColorLabel(this.label, this.color);
//   final String label;
//   final Color color;
// }

// class DropdownMenu extends StatefulWidget {
//   const DropdownMenu({super.key});

//   @override
//   _DropdownMenuState createState() => _DropdownMenuState();
// }

// class _DropdownMenuState extends State<DropdownMenu> {
//   final TextEditingController controller = TextEditingController();
//   ColorLabel? selectedColor;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<ColorLabel>(
//         initialSelection: ColorLabel.blue,
//         controller: controller,
//         label: const Text("Color"),
//         onSelected: (ColorLabel? color) {
//           serState(() {
//             selectedColor = color;
//           });
//         },
//         dropdownMenuEntries: ColorLabel.values
//             .map<DropdownMenuEntry<ColorLabel>>((ColorLabel color) {
//           return DropdownMenuEntry<ColorLabel>(
//               value: color,
//               label: color.label,
//               style: MenuItemButton.styleFrom(
//                 foregroundColor: color.color,
//               ));
//         }).toList());
//   }
// }
