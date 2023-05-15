import 'package:flutter/material.dart';

class TextInputFormFieldsPassword extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final Function onTapsuffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  const TextInputFormFieldsPassword(
      {super.key,
      this.labelText,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      required this.controller,
      this.keyboardType,
      required this.validator,
      this.textInputAction,
      required this.obscureText,
      required this.onTapsuffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.blue),
      cursorColor: Colors.blue,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.blue),
          suffixIconColor: Colors.blue,
          suffixIcon: GestureDetector(
              onTap: () => onTapsuffixIcon(), child: suffixIcon),
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}

class TextInputFormFields extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final bool autofocus;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  const TextInputFormFields(
      {super.key,
      this.labelText,
      this.hintText,
      this.prefixIcon,
      required this.controller,
      this.keyboardType,
      required this.validator,
      this.textInputAction,
      required this.autofocus});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      textInputAction: textInputAction,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      style: TextStyle(color: Colors.blue),
      cursorColor: Colors.blue,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.blue),
          suffixIconColor: Colors.blue,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}

class TextInputFormFieldsDefault extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final bool autofocus;
  final Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final String? initialValue;
  const TextInputFormFieldsDefault(
      {super.key,
      this.labelText,
      this.hintText,
      this.prefixIcon,
      this.keyboardType,
      required this.validator,
      this.textInputAction,
      required this.autofocus,
      required this.onSaved,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      autofocus: autofocus,
      textInputAction: textInputAction,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.blue),
      cursorColor: Colors.blue,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.blue),
          suffixIconColor: Colors.blue,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
