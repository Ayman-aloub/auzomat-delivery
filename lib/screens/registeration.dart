import 'package:auzomat_admin/screens/logn.dart';
import 'package:flutter/material.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';
import '../model/http_exception.dart';
import '../utils/color.dart';
import '../utils/constants.dart';
import '../widgets/btn_widget.dart';
import '../widgets/herder_container.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  var is_loading=false;
  final _formkey = GlobalKey<FormState>();
  bool visible=true;

  TextEditingController _namecontroller = TextEditingController();

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _countrycontroller = TextEditingController();
  @override
  void dispose() {


    _emailcontroller.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    _countrycontroller.dispose();



    super.dispose();
  }
  void _showErrorDialog(String message) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("التسجيل"),
            Expanded(
              flex: 1,
              child: is_loading?Center(child: CircularProgressIndicator()):Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                        TextFormField(
                          controller: _namecontroller,
                          decoration: kTextFieldDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'name',
                            hintText: 'Enter Your name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Fill name Input';
                            }
                            // return 'Valid Name';
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                            if (value!.isEmpty || value.length < 6) {
                              return 'Please Fill Password Input';
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _countrycontroller,
                          keyboardType: TextInputType.number,
                          decoration: kTextFieldDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'phone',
                            hintText: 'Enter Your phone number',
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !(value.length == 11)) {
                              return 'Please Fill phone number with 11 number';
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Color(0xFFFF7643),
                          child: Text(
                            'Resgister Full User',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            setState(() {
                              is_loading=true;
                            });
                            try{
                              if (_formkey.currentState!.validate()) {
                                var result = await Provider.of<Auth>(
                                    context, listen: false).createAccount(
                                    _emailcontroller.text,
                                    _passwordcontroller.text,
                                    _namecontroller.text,
                                    _countrycontroller.text
                                );

                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>login()));

                              }
                              setState(() {
                                is_loading=false;
                              });



                            }on HttpException catch (error) {
                              var errorMessage = 'Authentication failed';
                              if (error.toString().contains('EMAIL_EXISTS')) {
                                errorMessage = 'This email address is already in use.';
                              } else if (error.toString().contains('INVALID_EMAIL')) {
                                errorMessage = 'This is not a valid email address';
                              } else if (error.toString().contains('WEAK_PASSWORD')) {
                                errorMessage = 'This password is too weak.';
                              } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
                                errorMessage = 'Could not find a user with that email.';
                              } else if (error.toString().contains('INVALID_PASSWORD')) {
                                errorMessage = 'Invalid password.';
                              }
                              _showErrorDialog(errorMessage);
                            } catch (error) {
                              const errorMessage =
                                  'Could not authenticate you. Please try again later.';
                              _showErrorDialog(error.toString());

                            }
                            setState(() {
                              is_loading=false;
                            });


                          },
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
                      text: "you have an account ? ",
                      style: TextStyle(color: Colors.black)),
                  TextSpan(

                      text: "log in",
                      style: TextStyle(color: orangeColors)),


                ]),
              ),
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>login()));
              },
            ),
          ],
        ),
      ),
    );
  }

}
