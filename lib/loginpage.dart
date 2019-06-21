//import 'package:firebaselogin/profilepage.dart';
import 'package:firebaselogin/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
enum FormType{
    login,
    register
  }
class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;
  
  bool validateAndSave(){
    final form = formKey.currentState;
    form.save();
    if(form.validate()){
        form.save();
        return true;
    }
    else
      return false;
  }
  void submit() async{
    if(validateAndSave()){
      try{
      if(_formType==FormType.login){
        FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password
          ).then((FirebaseUser user){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CRUD()));
          });
      }
      else{
        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email,password: _password);
        var alertDialog = AlertDialog(
          title: Text("Account Created Successfully"),
          content: Text("Please Do Login"),
        );

        showDialog(
            context: context,
            builder: (BuildContext context) => alertDialog);
      }
      }
      catch(e){
        print("Error is: $e");
      }
    }
  }
  void signin(){
    formKey.currentState.reset();
   setState(() {
     _formType = FormType.register; 
   });
  }
  void login(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login; 
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("LogIn")),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:buildInput()+buildSubmitButton()
          ),
        ),
     )
    );
  }
  List<Widget> buildInput(){
    return[
      TextFormField(
        style: TextStyle(fontSize: 17.0),
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(fontSize: 20.0),
        ),
        validator: (value) => value.isEmpty ? "Email can't be empty" :null,
        onSaved: (value)=>_email=value,
      ),
      TextFormField(
          style: TextStyle(fontSize: 17.0),
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(fontSize: 20.0)
        ),
        obscureText: true,
        validator: (value) => value.isEmpty ? "Password can't be empty" :null,
        onSaved: (value)=>_password=value,
      ),
    ];
  }
  List<Widget> buildSubmitButton(){
    if(_formType==FormType.login){
    return [
      Padding(padding: EdgeInsets.only(top:25.0),),
      ButtonTheme(
        height: 50.0,
        minWidth: 50.0,
        //buttonColor: Colors.orange[200],
        splashColor: Colors.red,
          child: RaisedButton(
          child: Text("LogIn",style: TextStyle(fontSize: 20.0,),),
          onPressed: submit,
        ),
      ),
      Padding(padding: EdgeInsets.only(top:15.0),),
      FlatButton(
        child: Text("Create an account", style: TextStyle(fontSize: 20.0,),),
        onPressed: signin,
      )
    ];}
    else{
      return [
      Padding(padding: EdgeInsets.only(top:25.0),),
      ButtonTheme(
        height: 50.0,
        minWidth: 50.0,
        //buttonColor: Colors.orange[200],
        splashColor: Colors.red,
          child: RaisedButton(
          child: Text("Create an account",style: TextStyle(fontSize: 20.0,),),
          onPressed: submit,
        ),
      ),
      Padding(padding: EdgeInsets.only(top:15.0),),
      FlatButton(
        child: Text("Have an account? LogIn", style: TextStyle(fontSize: 20.0,),),
        onPressed: login,
      )
    ];
    }
  }
}