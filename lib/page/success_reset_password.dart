import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/sign_in.dart';

class SuccessResetPassword extends StatelessWidget {
  const SuccessResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(

          children: [
            SizedBox(height: 161,),
            Center(child: Image.asset('images/success.png', height: 128, width: 128,)),
            SizedBox(height: 40,),
            Text('Email Sudah Dikirimkan!', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold
            )),),
            SizedBox(height: 24,),
            Text('Kami telah mengirimkan email \nuntuk merubah kata sandi anda. \nSilakan cek kotak masuk pada email anda.', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal
            )), textAlign: TextAlign.center,),
            SizedBox(height: 73,),
            SizedBox(
              height: 52, width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColor.blueColor),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      )
                  ),
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInPage()), (Route<dynamic> route) => false);
                  }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Colors.white,),
                  SizedBox(width: 8,),
                  Text('Kembali Ke Halaman Login', style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                      )
                  ),)
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
