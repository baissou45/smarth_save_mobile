import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:smarth_save/utile/widgets/commonWidgets.dart';



//errorToast ______________________________
errorToast(BuildContext context, error){
  return GFToast.showToast("$error", context, toastDuration: 4, backgroundColor: Colors.red.shade700, textStyle: normalFont(Colors.white, 14), toastPosition: GFToastPosition.BOTTOM,);
}
//errorToast ______________________________
successToast(BuildContext context, error){
  return GFToast.showToast("$error", context, toastDuration: 4, backgroundColor:  Colors.green, textStyle: normalFont(Colors.white, 14), toastPosition: GFToastPosition.BOTTOM,);
}


//SNACKBARS----------------------------------
void showSimpleSnack(String value, IconData icon, Color iconColor,context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
    content: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            value,
            style: normalFont(Colors.white, 14.0),
          ),
        ),
        Icon(
          icon,
          color: iconColor,
          size: 26,
        )
      ],
    ),
  ));
}