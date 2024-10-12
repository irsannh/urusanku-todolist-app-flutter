import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/sign_in.dart';
import 'package:urusanku_app/page/sign_up.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Catat Semua \nUrusan Anda \nDengan Mudah', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600
              )),),
              SizedBox(height: 233,),
              Text('Masuk atau Buat Akun Baru \nUntuk Melanjutkan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
              )),),
              SizedBox(height: 43,),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                    }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: Colors.white,),
                    SizedBox(width: 8,),
                    Text('Masuk', style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                      )
                    ),)
                  ],
                )),
              ),
              SizedBox(height: 16,),
              SizedBox(
                height: 52, width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(
                          BorderSide(color: AppColor.blueColor, width: 1)
                        ),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                            )
                        )
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_add, color: AppColor.blueColor,),
                    SizedBox(width: 8,),
                    Text('Buat Akun Baru', style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                            color: AppColor.blueColor, fontSize: 18, fontWeight: FontWeight.bold
                        )
                    ),)
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
