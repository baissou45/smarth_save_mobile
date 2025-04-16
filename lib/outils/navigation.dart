import 'package:flutter/material.dart';

navigationTonextPage(context, Widget page){
  Navigator.of(context).push(MaterialPageRoute(builder: (context){
    return page;
  },),);
}