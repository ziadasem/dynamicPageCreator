import 'package:DynamicFormCreator/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import './form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('ar'),
      startLocale: Locale('ar'),
      useOnlyLangCode: true,
      child: MyApp(),
    ));}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"dynamic form creator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home : Builder(
        builder: (context) =>
              Scaffold(appBar: AppBar(
          centerTitle: true,
          title: Text("dynamic form creator".tr(),),
        ),
        body: Container(child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("add new".tr()),
                onPressed: (){
              nextScreen(context, FormCreator(false));
              }),
              SizedBox(height: 30,),
              RaisedButton(
                child: Text("edit".tr()),
                onPressed: (){
                 nextScreen(context, FormCreator(true));
              }),
               SizedBox(height: 30,),
              RaisedButton(
                child: Text("langauge".tr()),
                onPressed: (){
                 if (context.locale == Locale('en')){
                          context.locale = Locale('ar');
                      }else{
                          context.locale = Locale('en');
                      }
              }),
            ],
          ),
        ),),
        ),
      )
      //home: FormCreator(),
    );
  }
}