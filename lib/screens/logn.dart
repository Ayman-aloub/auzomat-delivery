import 'package:auzomat_admin/model/http_exception.dart';
import 'package:auzomat_admin/provider/auth.dart';
import 'package:auzomat_admin/screens/next.dart';
import 'package:auzomat_admin/screens/registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/color.dart';
import '../utils/constants.dart';
import '../widgets/btn_widget.dart';
import '../widgets/herder_container.dart';


class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  bool visible=true;
  bool isLogin =false;


  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();



  void _showErrorDialog(String message,BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {


    _emailcontroller.dispose();

    _passwordcontroller.dispose();



    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              HeaderContainer("تسجيل الدخول"),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailcontroller,
                            decoration: kTextFieldDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Email',
                              hintText: 'Enter Your Email',
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please Fill Email Input';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordcontroller,
                            obscureText: visible,
                            decoration: kTextFieldDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Password',

                              hintText: 'Enter Your Password',
                              suffixIcon: IconButton(
                                icon:new Icon(Icons.visibility),
                                onPressed: ()=>{setState((){visible=!visible;}) },

                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value!.length < 6) {
                                return 'Please Fill Password Input';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),



                             Container(
                               width: double.infinity,
                               height: MediaQuery.of(context).size.height*0.08,


                               child: RaisedButton(
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(28.0),
                                     side: BorderSide(color: Color(0xFFFF7643))
                                 ),



                                color: Color(0xFFFF7643),
                                child: isLogin ? CircularProgressIndicator( ):Text(
                                  'logn in',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  try{
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        isLogin = true;
                                      });
                                      var result = await Provider.of<Auth>(
                                          context, listen: false).signin(
                                          _emailcontroller.text,
                                          _passwordcontroller.text
                                      );
                                      if(result=='ERROR'){
                                  setState(() {
                                  isLogin = false;
                                  _showErrorDialog('you are not delivery',context);
                                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>next()));
                                  });
                                  }else{
                                  setState(() {
                                  isLogin = false;
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>next()));
                                  });
                                  }


                                    }

                                  }on FirebaseAuthException catch (e) {
                                    var errorMessage = 'Authentication failed';
                                    if (e.code == 'user-not-found') {
                                      errorMessage = 'This is not a valid email address';
                                    } else if (e.code == 'wrong-password') {
                                      errorMessage = 'Invalid password.';
                                    }
                                    _showErrorDialog(errorMessage,context);
                                    setState(() {
                                      isLogin = false;
                                    });
                                  }on HttpException catch (e){
                                  _showErrorDialog(e.toString(),context);
                                  setState(() {
                                  isLogin = false;
                                  });
                                  }
                                  catch (error) {
                                    const errorMessage =
                                        'Could not authenticate you. Please try again later.';
                                    _showErrorDialog(error.toString(),context);
                                    setState(() {
                                      isLogin = false;
                                    });
                                  }
                                },
                            ),
                             ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Don't have an account ? ",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(

                          text: "Registor",
                          style: TextStyle(color: orangeColors)),


                  ]),
                ),
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>RegPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}
