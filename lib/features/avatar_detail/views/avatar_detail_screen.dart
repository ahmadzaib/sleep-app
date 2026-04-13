import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/constants/mock_data.dart';
import 'package:avatar_flow/features/avatar_detail/views/components/detail_screen_appbar.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarDetailScreen extends StatelessWidget {
  const AvatarDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AvatarDetailAppbar(
          title: "Avatar",
          subtitleText: "Meet and manage your character",
          onInfoTap: () {},
          actions: [
            IconButton(
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              icon: CustomSvg(path: AppIconsSvg.moreVer),
            ),
          ],
        ),

        body: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: Column(
            children: [
              //Appbar
              Container(
                height: 300.h,

                child: Stack(
                  alignment: AlignmentGeometry.bottomCenter,
                  children: [
                    ClipPath(
                      clipper: MyClipper(),
                      child: Image.network(
                        dummyImage,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        AppImagesPng.dummyImage,
                        height: 250.h,
                      ),
                    ),
                  ],
                ),
              ),

              //
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();

    path_0.moveTo(size.width * 0.0700000, size.height * 0.5000000);
    path_0.quadraticBezierTo(
      size.width * 0.0170400,
      size.height * 0.5261667,
      0,
      size.height * 0.5966667,
    );
    path_0.quadraticBezierTo(
      size.width * -0.0005000,
      size.height * 0.6583333,
      size.width * -0.0020000,
      size.height * 0.8433333,
    );
    path_0.quadraticBezierTo(
      size.width * -0.0116000,
      size.height * 1.0134333,
      size.width * 0.1000000,
      size.height * 1.0033333,
    );
    path_0.quadraticBezierTo(
      size.width * 0.2995000,
      size.height * 1.0008333,
      size.width * 0.8980000,
      size.height * 0.9933333,
    );
    path_0.quadraticBezierTo(
      size.width * 1.0052400,
      size.height * 1.0189000,
      size.width * 1.0020000,
      size.height * 0.8166667,
    );
    path_0.quadraticBezierTo(
      size.width * 1.0010000,
      size.height * 0.6525000,
      size.width * 0.9980000,
      size.height * 0.1600000,
    );
    path_0.quadraticBezierTo(
      size.width * 1.0053800,
      size.height * -0.0057000,
      size.width * 0.8947400,
      size.height * -0.0050667,
    );
    path_0.quadraticBezierTo(
      size.width * 0.6885550,
      size.height * 0.1212000,
      size.width * 0.0700000,
      size.height * 0.5000000,
    );

    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
