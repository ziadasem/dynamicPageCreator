import 'dart:convert';
import 'package:DynamicFormCreator/snacbar.dart';
import 'package:DynamicFormCreator/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class FormCreator extends StatefulWidget {
  final bool isEdit ;
  FormCreator(this.isEdit);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<FormCreator> {
//List<TextEditingController> _controllers = <TextEditingController>[];
int controllersAttached = -1;


List<TextEditingController> controllers;
List<String> choices = [] ;
List<String> heads = [] ;
List<List> lists = [];
List<List<int>> radioButtons = [];
List<bool> radioChecks = [];
List<int> unPopulatedFileds = [] ;
bool isLoading = true ;
var connectivityResult ;
int numberOfTextField =  0;
List forms = [] ;
Key key ;
int flag = -1 ;
bool _validate = false ;
int dropDpwnMenuNumber = 0 ;

 Future<List> readJson() async {
    final String response = await DefaultAssetBundle.of(context).loadString(!widget.isEdit ?'assets/data.json' : 'assets/values.json');
    final data = await json.decode(response);
    setState(() {
      forms = data["fields"];
      forms.forEach((element) { 
          if (element['ctrlType'] == 2 || element['ctrlType'] == 1 || element['ctrlType'] == 6  || element['ctrlType'] == 5 ){
              numberOfTextField ++ ;
          }else if (element['ctrlType'] == 4){
              dropDpwnMenuNumber ++ ;
          }
        });
    });
    return data["fields"];
  }

  @override
  void initState() {
    
    readJson().then((forms) async{

    heads = List.generate(forms.length, (i) => "") ;
    choices = List.generate(forms.length , (i) => "") ;
    radioButtons  = List.generate(forms.length , (i) =>  List.generate(5 , (j) => 0)) ;
    widget.isEdit ?initVals(forms , numberOfTextField ,) :null;
    setState(() {
     
     isLoading = false ;
    
    });
    super.initState();
  });}

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();

  }

  int txtFieldCounter = 0 ;
  int val = 0 ;
  void initVals(List arr , int txtFieldLength ){
 txtFieldCounter = 0 ;
if (controllers != null){
    if (controllers.every((element) => element == null)){
      controllers = List.generate(txtFieldLength, (i) => TextEditingController());
    }
  }else{
      controllers = List.generate(txtFieldLength, (i) => TextEditingController());
  }

      for (int i = 0 ; i <arr.length ; i++){
           switch (arr[i]['ctrlType']) {  
            case 1 :
            if (arr[i]['value'] != null && arr[i]['value'] != ""){
            controllers[txtFieldCounter].text =  arr[i]['value'].toString();
               final controller = controllers[txtFieldCounter];
                   heads[i] = arr[i]['arLabel'].toString() ;
                   choices[i] = arr[i]['value'].toString() ;
            }
              txtFieldCounter = txtFieldCounter + 1 ;
            break ;

            case 2  :         
            if (arr[i]['value'] != null && arr[i]['value'] != ""){
            controllers[txtFieldCounter].text =  arr[i]['value'].toString();
               final controller = controllers[txtFieldCounter];
                   heads[i] = arr[i]['arLabel'].toString() ;
                   choices[i] = arr[i]['value'].toString() ;
            } 
              txtFieldCounter = txtFieldCounter + 1 ;
            break ;

           case 3 :
            if (arr[i]['value'] != null && arr[i]['value'] != ""){
               heads[i] =  arr[i]['arLabel']  ;     
               choices[i] = arr[i]['value'] ;
            }
            break ; 

            case 4 :
            
             if (arr[i]['value'] != null && arr[i]['value'] != ""){
               heads[i] =  arr[i]['arLabel']  ; 
                 choices[i] =    forms[i]['value'].toString()  + " - " + forms[i]['lstLookup'].firstWhere((element) => forms[i]['value'].toString() == element['code'].toString())['name'].toString();
    
            //   choices[i] = arr[i]['value'] ;
            }
            break ;

            case 5 : 
            if (arr[i]['value'] != null && arr[i]['value'] != ""){
            controllers[txtFieldCounter].text =  arr[i]['value'].toString();
               final controller = controllers[txtFieldCounter];
                  
                   heads[i] = arr[i]['arLabel'].toString() ;
                   choices[i] = arr[i]['value'].toString() ;
            }     
            txtFieldCounter = txtFieldCounter + 1 ;   
            break ;

            case 6 :
            if (arr[i]['value'] != null && arr[i]['value'] != ""){
            controllers[txtFieldCounter].text =  arr[i]['value'].toString();
               final controller = controllers[txtFieldCounter];
                   heads[i] = arr[i]['arLabel'].toString() ;
                   choices[i] = arr[i]['value'].toString() ;
            }
            txtFieldCounter = txtFieldCounter + 1 ;
            break ;
            case 7:
             if (arr[i]['value'] != null && arr[i]['value'] != ""){
               heads[i] =  arr[i]['arLabel']  ;     
               choices[i] = 'false' ;
             
            }
          }

      }
  }

  //build function
  List<Widget> buildWidgets (List arr , int txtFieldLength /*, int dropDownMenu*/) {
 txtFieldCounter = 0 ;

  List<Widget> widgets  = [SizedBox(height: 10,)] ;
  if (controllers != null){
    if (controllers.every((element) => element == null)){
      controllers = List.generate(txtFieldLength, (i) => TextEditingController());
    }
  }else{
      controllers = List.generate(txtFieldLength, (i) => TextEditingController());
  }
    
    if (arr.length == 0) {
/*if (connectivityResult == ConnectivityResult.none) {
  return [ Center(child: Text("لا يوجد اتصال بالانترنت "),)];
} else if (connectivityResult == ConnectivityResult.wifi) {
  return [ Center(child: Text("لا توجد بيانات "),)];
}*/
  return [ Container(width: MediaQuery.of(context).size.width, height:  MediaQuery.of(context).size.height  * 0.75, child: Center(child: Text("no data is available".tr() , style: boldMedTextStyle(Colors.black),),))];
     }
      for (int i = 0 ; i <arr.length ; i++){
        
          switch (arr[i]['ctrlType']) {
            
            case 1 :
            String label =   context.locale != Locale('ar') ?arr[i]['enLabel']  :arr[i]['arLabel'] ;
            arr[i]['isRequired'] ?  label = label + " *"  :null ;
            
            final controller = controllers[txtFieldCounter];
            if (flag != -1 &&  arr[i]['isRequired'] ) {
              _validate = (controller.text == ""); 

            }
            
            widgets.add(TextField(
              textAlign:  context.locale == Locale('ar') ? TextAlign.end : TextAlign.start,
              controller: controllers[txtFieldCounter],
              keyboardType: TextInputType.number,
              style:   TextStyle( fontSize: 14),
              decoration: inputDecorationSimple(label , label , validate: _validate &&  arr[i]['isRequired'] ),     
               onChanged: (value) {
                 final controller = controllers[txtFieldCounter];
                // setState(() {
                   heads[i] = arr[i]['arLabel'].toString() ;
                   choices[i] = value ;  
                  
                // });
                 
                },
            ));
             widgets.add(SizedBox(height: 10,)) ;
             txtFieldCounter = txtFieldCounter + 1 ;
            break ;

            case 2  :         
            String label =   context.locale != Locale('ar') ?arr[i]['enLabel']  :arr[i]['arLabel'] ;
            arr[i]['isRequired'] ?  label = label + " *"  :null ;
            
            final controller = controllers[txtFieldCounter];
            if (flag != -1 && arr[i]['isRequired']) {
                _validate = (controller.text == ""); 
               
            }
                widgets.add(TextFormField( 
                textAlign:  context.locale == Locale('ar') ? TextAlign.end : TextAlign.start,
                controller: controllers[txtFieldCounter], 
                
                onChanged: (value) {
                    final controller = controllers[txtFieldCounter];
                    heads[i] = arr[i]['arLabel'].toString() ;
                    choices[i] = value ;
                   print(value);
                 
                },
               style:   TextStyle( fontSize: 14),
              decoration: inputDecorationSimple(label , label , validate : _validate &&  arr[i]['isRequired']),     
            ));
             widgets.add(SizedBox(height: 10,)) ;
             txtFieldCounter = txtFieldCounter + 1 ;
            break ;

            case 3 :
            String label =   context.locale != Locale('ar') ?arr[i]['enLabel']  :arr[i]['arLabel'] ;
            arr[i]['isRequired'] ?  label = label + " *"  :null ;
             widgets.add(  
            Container(
              child: Column(                
                children: [
                  Text(label , style: regMedTextStyle((choices[i] == "" &&  arr[i]['isRequired']&& flag != -1)? Colors.red : Colors.black  ), ),
                  OutlineButton.icon(    
                  onPressed: () {      
                      DatePicker.showDatePicker(context,
                      locale: context.locale == Locale('en') ? LocaleType.en : LocaleType.ar,
                            showTitleActions: true,
                            onChanged: (DateTime date) {  
                              setState(() {
                                heads[i] =  arr[i]['arLabel']  ;     
                                choices[i] = (date.year.toString() + "/" + date.month.toString() + "/" + date.day.toString() );
                              });
                          });
                  },
                  highlightedBorderColor: Colors.blue,
                  borderSide: BorderSide(
                    width:(choices[i] == "" &&  arr[i]['isRequired'] && flag != -1)? 2.5 : 1.0,
                    color: (choices[i] == "" &&  arr[i]['isRequired'] && flag != -1)?Colors.red : Theme.of(context).accentColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),        
                  icon:  Icon(
                    Icons.arrow_drop_down,
                    size: 24.0,
                    color: Colors.blue,
                  ),    
                  label: Text(choices[i] == "" ?  ( context.locale != Locale('ar') ?arr[i]['enLabel'].toString()  :arr[i]['arLabel'].toString()) : choices[i].toString()),
    ),
                ],
              ),
            ),
            );
            widgets.add(SizedBox(height: 10,)) ;
            break ;

            case 4 :
             List<String> s = [];  
             
             String label =   context.locale != Locale('ar') ?arr[i]['enLabel']  :arr[i]['arLabel'] ;
             arr[i]['isRequired'] ?  label = label + " *"  :null ;
       
            if (arr[i]['lstLookup'] != null){
              arr[i]['lstLookup'].forEach((element) { 
              s.add(element['code'].toString() + " - " +  element['name'].toString() );
            });
            }
            widgets.add(
           Container(
            width: double.infinity * 0.8,
            child: new DropdownButton<String>(
            hint: Text(choices[i] == "" ? (label) : choices[i] , style: regMedTextStyle((choices[i] == "" &&  arr[i]['isRequired'] && flag != -1)? Colors.red : Colors.black  ), ),
            items: s.map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList(),
  onChanged: (value) {
      setState(() {
       heads[i] = arr[i]['arLabel'].toString() ;
       choices[i] = value ;

      });
  },
),
          )
          );
             widgets.add(SizedBox(height: 10,)) ;
            break ;

            case 5 : 
              String label =   context.locale != Locale('ar') ?arr[i]['enLabel']  :arr[i]['arLabel'] ;
               arr[i]['isRequired'] ?  label = label + " *"  :null ;

              final controller = controllers[txtFieldCounter];
              if (flag != -1 &&  arr[i]['isRequired']) {
                _validate = (controller.text == ""); 
              }

              choices[i] = arr[i]['value'] ?? "لا توجد قيمة" ;
              widgets.add(TextField( 
              textAlign:  context.locale == Locale('ar') ? TextAlign.end : TextAlign.start,
               style:   TextStyle( fontSize: 14),
               controller: controllers[txtFieldCounter],   
               readOnly: true, 
              decoration: inputDecorationSimple( label , label , validate : _validate &&  arr[i]['isRequired'] ),     
            ));
             widgets.add(SizedBox(height: 10,)) ;
             if (arr[i]['value'] != null){
              controllers[txtFieldCounter].text =  arr[i]['value'];
            }else{
              controllers[txtFieldCounter].text = "لا توجد قيمة";
            }
           txtFieldCounter = txtFieldCounter + 1 ;
            break ;

            case 6 :

               String label =   context.locale != Locale('ar') ?arr[i]['enLabel']  :arr[i]['arLabel'] ;
               arr[i]['isRequired'] ?  label = label + " *"  :null ;

              final controller = controllers[txtFieldCounter];
              if (flag != -1 &&  arr[i]['isRequired']) {
                _validate = (controller.text == ""); 
              }

            widgets.add(TextField( 
              textAlign:  context.locale == Locale('ar') ? TextAlign.end : TextAlign.start,
               style:   TextStyle( fontSize: 14),
               keyboardType: TextInputType.multiline,
               controller: controllers[txtFieldCounter],    
               maxLines: null,
               minLines: 6,
              decoration: inputDecorationSimple(label , label , validate : _validate &&  arr[i]['isRequired']), 
              onChanged: (value){
                 final controller = controllers[txtFieldCounter];
             //   setState(() {  
                  heads[i] = arr[i]['arLabel'].toString() ;
                  choices[i] = value ;
               // });
              },    
            ));
             widgets.add(SizedBox(height: 10,)) ;
             txtFieldCounter = txtFieldCounter + 1 ;

            break ;

            case 7  :
             List radios = arr[i]['lstLookup'];
            widgets.add(
            
              Container(
              child: Column(              
              children: <Widget>[
                 Text( context.locale != Locale('ar') ?arr[i]['enLabel']  : arr[i]['arLabel'] , style: regMedTextStyle((choices[i] == "" &&  arr[i]['isRequired'] && flag != -1)? Colors.red : Colors.black  ), ),
              for (int j = 1; j <= radios.length; j++)
              ListTile(
                contentPadding: EdgeInsets.zero,

        title: Text(
         radios[j-1]['arName'].toString() 
        ),
        leading: Radio(
          value:  radios[j-1]['arName'],
          groupValue: choices[i],
          activeColor: Color(0xFF6200EE),
          onChanged: (value) {
              setState(() {
                heads[i] = arr[i]['arLabel'].toString() ;
                choices[i] = value.toString();
              });
          },
        ),
      ),
  ],
),
            ));
             widgets.add(SizedBox(height: 10,)) ;
            break ;

        case 8  :
             List radios = arr[i]['lstLookup'];
             
             checkIfNull(radios.length);
             if (choices[i] == "" || choices[i] == null){
               choices[i] = 'false' ;
             }
             widgets.add(
              Container(
              child: Column(              
              children: <Widget>[
                 Text( context.locale != Locale('ar') ?arr[i]['enLabel']  : arr[i]['arLabel'] , style: regMedTextStyle((choices[i] == "" &&  arr[i]['isRequired'] && flag != -1)? Colors.red : Colors.black  ),),
              for (int j = 1; j <= radios.length; j++)
              
              ListTile(
                contentPadding: EdgeInsets.zero,

            title: Text(
            radios[j-1]['arName'].toString() 
         // style: Theme.of(context).textTheme.subtitle1.copyWith(color: j == 5 ? Colors.black38 : Colors.black),
        ),
        leading: Checkbox(  
        value:  radioChecks[j-1],   
        onChanged: (bool value) {  
          setState(() { 
             heads[i] = radios[j-1]['arLabel'].toString() ;            
             choices[i] = radioChecks.toString();
             radioChecks[j-1] = value ;
            
          });  
  },  
), 
      ),
  ],
),
            ));
             widgets.add(SizedBox(height: 10,)) ;
            break ;
          }

      }
        widgets.add(SizedBox(height: 50,)) ;
      return widgets ;
  }
  bool checkAllFileds (List forms){
    int _flag = -1 ;
    int index = 0 ;
    unPopulatedFileds = [] ;
    choices.forEach((element , ) { 
    //print(forms[index]['isRequired']);
        if ( (element == null || element.isEmpty) && forms[index]['isRequired']  ){
          _flag = 0 ;
          unPopulatedFileds.add(index);
         // print(choices);
          flag = 0 ;
        }
         index ++ ;
    });
    return  choices.length == forms.length && _flag == -1;
  }

  bool filedsAreAllEmpty (){
    bool isEmpty = true ;
    choices.forEach((element) {
      if (element != "" ){
          isEmpty = false ;
      }
    });
    return isEmpty ;
  }

   void jsonify (List values , List forms ){
   List jsonArr = [] ;
   print(choices);
  if (checkAllFileds(forms) && !filedsAreAllEmpty()){
   for (int i = 0 ; i < values.length; i++){
        jsonArr.add(jsonEncode(
         {
      "id": forms[i]['id'],
      "value": forms[i]['ctrlType'] !=4 ?values[i].toString() : values[i].toString().split(" - ")[0],
      "arLabel": forms[i]['arLabel'],
      "enLabel": forms[i]['enLabel'],
      "ctrlType":forms[i]['ctrlType'],
          } ));
     }
  print(jsonArr);
     
  }else{
    if (filedsAreAllEmpty()){
    openToast1(context, "please fill any field".tr());

    }else {
    String indexNumbers = "" ;
    unPopulatedFileds.forEach((element) { 
      indexNumbers = indexNumbers +  element.toString() + " " ;
      
    });
   // print(unPopulatedFileds);
    openToast1(context, "please fill all fields".tr() + indexNumbers + "are required".tr());
    }
  }
   //print(choices);
   }

void checkIfNull (length){
   if (radioChecks.every((element) => element == null)) {
     radioChecks = List.generate(length , (i) => false) ;
   }
   
}
  @override
  Widget build(BuildContext context) {
     readJson();
    if (choices.every((element) => element == null)) {
      choices = List.generate(forms.length, (i) => "") ;
    }
   if (heads.every((element) => element == null)) {
      heads = List.generate(forms.length, (i) => "") ;
    }
   if (radioButtons.every((element) => element == null)) {
      radioButtons  = List.generate(forms.length , (i) =>  List.generate(5 , (j) => 0)) ;
   }
   
   
    return Scaffold(
      appBar: AppBar(title: Text("dynamic form creator".tr()),),
      key: key,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.done,),
      onPressed: (){
     FocusScope.of(context).unfocus();
      if (forms.length != 0){
        setState(() {
        jsonify(choices ,forms ) ;          
        });
      }else{
      openToast(context , "Error, Refresh Page".tr());
      }
     
      },
      ),     
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children:isLoading ? [Container(height: 300, width: double.infinity,child: Center(child: CircularProgressIndicator()), ) ]
              :buildWidgets(forms, numberOfTextField /*sp.dropDpwnMenuNumber*/),),
        ),
      ),
    );
  }
}