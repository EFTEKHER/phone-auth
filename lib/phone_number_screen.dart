import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
class phoneNumberScreen extends StatefulWidget {
 

  @override
  State<phoneNumberScreen> createState() => _phoneNumberScreenState();
}

class _phoneNumberScreenState extends State<phoneNumberScreen> {
  TextEditingController phoneController=TextEditingController();
  TextEditingController  oTpController=TextEditingController();
  String verificationIdReceived="";
  bool otpVisible=false;
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: SafeArea(child: Container(
        height: MediaQuery.of(context).size.height,
        width:MediaQuery.of(context).size.width,
        
        margin: EdgeInsets.all(10),
        child:Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
TextField(
  controller: phoneController,
  textAlign: TextAlign.center,
  decoration: InputDecoration(border: OutlineInputBorder(),hintText:'Enter Mobile Number:' ),
),
SizedBox(height:20),
Visibility(
  visible: otpVisible,
  child:   TextField(textAlign: TextAlign.center,
  keyboardType: TextInputType.phone,
  controller: oTpController,
  
    decoration: InputDecoration(border: OutlineInputBorder(),hintText:'Enter OTP:', ),),
),
SizedBox(height: 20),
ElevatedButton(onPressed: (){
  if(otpVisible){
    verifyCode();
  }
  else{
    verifyNumber();
  }

}
, child: Text(otpVisible?'Login':'Verify')),
          ],
        ),) ,
      )),
    );
  }
  void verifyNumber()
{
 auth.verifyPhoneNumber(phoneNumber: phoneController.text, verificationCompleted: (PhoneAuthCredential credential)async{
  await auth.signInWithCredential(credential).then((value) {
     print('you are logged in Successfully');
   });
 }, verificationFailed: (FirebaseAuthException exception){
   print(exception.message);
 }, codeSent: (String verificationId, int?resendToken ){
   verificationIdReceived=verificationId;
  otpVisible=true;
   setState(() {
     
   });
 }, codeAutoRetrievalTimeout: (String verificationId){});
}
void verifyCode()async {
  PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: verificationIdReceived, smsCode: oTpController.text);
  await auth.signInWithCredential(credential).then((value) {
    print('Signed In successfully');
  });
  }

}

