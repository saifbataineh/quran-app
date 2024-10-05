import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final  TextEditingController? controller;
  final bool isobsecureText;
  final bool readOnly;
  final  VoidCallback? onTap;
  const CustomField({super.key, required this.hintText, required this.controller, this.isobsecureText=false,this.readOnly=false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      
decoration: InputDecoration(
  hintText: hintText
),
controller: controller,
validator: (value){
  if(value!.trim().isEmpty){
    return ' $hintText is missing !';
  }
  return null;
},
obscureText: isobsecureText,
obscuringCharacter: '*',
    );
  }
}