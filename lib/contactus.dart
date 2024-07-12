import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CommonUtils.dart';

class contactus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFf3e3ff),
          title: const Text(
            'Contact Us',
            style: TextStyle(
                color: Color(0xFF0f75bc),
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CommonUtils.primaryTextColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body:

      Container(

        child:
        Column(

        //  mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
            //  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/f_us3.png',
                fit: BoxFit.fitHeight ,
               //  width: 250.0,
               // height: 250.0,
                // Adjust as needed
              ),
            ),

            SizedBox(height: 20),
            SocialMediaButton(
              iconPath:  'assets/facebook.svg',
              username: 'Facebook',
              color: Colors.blueAccent,
              url: 'https://www.facebook.com/HAIRFIXINGZONE',
            ),
            SocialMediaButton(
              iconPath:  'assets/instagram.svg',
              username: 'Instagram',
              color: Colors.pinkAccent,
              url: 'https://www.instagram.com/hairfixingzoneofficial/',
            ),
            SocialMediaButton(
              iconPath: 'assets/youtube.svg',
              username: 'Youtube',
              color: Colors.redAccent,
              url: 'https://www.youtube.com/channel/UCkbMLIkXoT2ISurXiFvBvCQ',
            ),//7093879682 sai charan
            SocialMediaButton(
              iconPath: 'assets/site.svg',
              username: 'Our Website',
              color: Color(0xFF0f75bc),
              url: 'https://hairfixingzone.com',
            ),
            Expanded(child: Container()), // Spacer to push button to the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: InkWell(
                onTap: () async {
                  final url = 'tel:+919916160222';
                  try {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Tooltip(
                  message: 'Call Us',
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: CommonUtils.primaryTextColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(width: 10),
                        Text(
                          'Call Us: +(91) 9916160222',
                          style: CommonStyles.txSty_20w_fb,
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/phone_call.svg',
                          width: 25,
                          height: 25,
                          color:Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between button and bottom of screen
          ],
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final String iconPath;
  final String username;
  final Color color;
  final String url;

  const SocialMediaButton({
    required this.iconPath,
    required this.username,
    required this.color,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child:
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  iconPath,
                  width: 25,
                  height: 25,
                  color: color, // Adjust color as needed
                ), // replac
                // Image.asset(
                //   iconPath,
                //   width: 40,
                //   height: 40,
                // ),
              ),
              Text(
                username,
                style: CommonStyles.txSty_20black_fb
              ),
            ],
          ),
        ),
      ),
    );
  }
}