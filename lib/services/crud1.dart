import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUD1{

  bool checksignin(){
    if(FirebaseAuth.instance.currentUser()!=null)
      return true;
    else
      return false;
  }
  Future<void> addData(noteData,BuildContext context) async{
    if(checksignin()){
      Firestore.instance.collection("testcrud").add(noteData).catchError((e){
      print(e);
      });
    }
    else{
      final snackBar = SnackBar(content: Text('Please Do Login'));
      Scaffold.of(context).showSnackBar(snackBar);
    } 
  }

  getData() async{
    return await Firestore.instance.collection('testcrud').getDocuments();
  }
  
  updateData(selectedDoc,newValue){
    Firestore.instance.collection("testcrud").document(selectedDoc).updateData(newValue).catchError((e){
      print(e);
    });
  }
  void deleteData(docId){
    Firestore.instance.collection("testcrud").document(docId).delete().catchError((e){
      print(e);
    });
  }



}