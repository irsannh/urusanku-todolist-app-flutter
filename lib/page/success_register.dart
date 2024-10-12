import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/home_page.dart';

class SuccessRegister extends StatelessWidget {
  const SuccessRegister({super.key});

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
              Text('Akun Berhasil Dibuat!', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold
              )),),
              SizedBox(height: 24,),
              Text('Silakan menuju Halaman Beranda \nUntuk Membuat Urusan Baru', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
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
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                    }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: Colors.white,),
                    SizedBox(width: 8,),
                    Text('Menuju Ke Halaman Beranda', style: GoogleFonts.plusJakartaSans(
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
