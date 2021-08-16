import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

InputDecoration inputDecoration (hint, label, clearEvent){
    return InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(),
                labelText: label,
           alignLabelWithHint: true,
                contentPadding: EdgeInsets.only(right: 0, left: 10),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(icon: Icon(Icons.close, size: 15), onPressed: (){
                      clearEvent.clear();
                    }),
                  ),
                )
                
              );
  }
InputDecoration inputDecorationSimple (hint, label , {validate = false}){
    return InputDecoration(   
                errorText:validate ?"required".tr() : null,
                alignLabelWithHint: true,
                hintText: hint,
                border: OutlineInputBorder(),
                labelText: label,
                contentPadding: EdgeInsets.all(10),
              );
  }

TextStyle regSmallTextStyle (Color color){
  return TextStyle(
    fontSize: 12,
    color: color, 
  );}

TextStyle regMedTextStyle (Color color){
  return TextStyle(
    fontSize: 14,
    color: color, 
  );}

TextStyle regLargeTextStyle (Color color){
  return TextStyle(
    fontSize: 16,
    color: color, 
  );}

TextStyle boldSmallTextStyle (Color color){
  return TextStyle(
    fontSize: 12,
    color: color,
    fontWeight: FontWeight.bold 
  );}

TextStyle boldMedTextStyle (Color color){
  return TextStyle(
    fontSize: 14,
    color: color,
    fontWeight: FontWeight.bold 
  );}

TextStyle boldLargeTextStyle (Color color){
  return TextStyle(
    fontSize: 18,
    color: color,
    fontWeight: FontWeight.bold 
  );}