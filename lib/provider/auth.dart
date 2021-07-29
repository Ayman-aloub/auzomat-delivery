import 'dart:convert';
import 'dart:async';

import 'package:auzomat_admin/model/http_exception.dart';
import 'package:auzomat_admin/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}
/*
The UI will depends on the Status to decide which screen/action to be done.
- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown
Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */
class User {
  String uid;
  User(this.uid);
}
class Auth extends ChangeNotifier {
  //Firebase Auth object

  //Firebase Auth object
  FirebaseAuth? _auth;
  String? _uid;

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;

  //Stream<UserModel> get user => _auth!.onAuthStateChanged.map(_userFromFirebase);

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    //_currentUser=User(null);


  }
  String? get userId {
    return _uid;
  }

  Future<String> signin(String email,String password) async{
    String result='DONE';
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value){
      _uid = value.user!.uid;

    }).
    catchError((error){
      throw(error);
    });

    await FirebaseDatabase.instance.reference().child('delivery').child(_uid!).once().then((value){print('value');
    if(value.value==null){
      signOut();
      result='ERROR';

    };
    });
    return result;

    notifyListeners();
  }
  Future<void> createAccount(String email,String password,String name,String phoneNumber) async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        .then((value){
          FirebaseDatabase.instance.reference().child('delivery').child(value.user!.uid).set({'isDelivery':'true',
            'Name':name,
            'Phone':phoneNumber});




    }).
    catchError((error){
      throw(error);
    });

    notifyListeners();
  }
  bool get isAuth {
    return _uid != null;
  }

  Future<bool> autoLogn() async{
    bool result=false;
    //print(await FirebaseAuth.instance.currentUser!.uid);
    final String? is_uid= await FirebaseAuth.instance.currentUser!.uid;
    if(is_uid!=null){
    _uid=is_uid;
    print(is_uid);
    result =true;
    }/*else {
    _uid=is_uid;
    print(is_uid);
    result =true;
    }*/
    //return await FirebaseAuth.instance.authStateChanges().isEmpty;
    /*await FirebaseAuth.instance.authStateChanges().listen((event) {
      if(event==null){
        result =false;
        return;
      }else {
        _uid=event.uid;
        print(event.uid);
        result =true;
      }



    });*/
    notifyListeners();
    return result;


  }
  Future<void> signOut() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    await FirebaseAuth.instance.signOut();
    _uid=null;


  }

}