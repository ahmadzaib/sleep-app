import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    if(mounted){Future.delayed(const Duration(seconds: 2), (){
      NavigationService.goNamed(AppRoutes.splashWithLogo);
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
       decoration: BoxDecoration(gradient:AppConstants.defaultGradient(context),
       
      
       
       ),
       child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.asset(AppImagesPng.vector1),
          Image.asset(AppImagesPng.vector2,width: 95*0.01.sw,),
          Image.asset(AppImagesPng.vector3,width: 88*0.01.sw,),
          Image.asset(AppImagesPng.vector4),
          Image.asset(AppImagesPng.dragonWithFlame),

        ],
       ),
      ),
    );
  }
}