import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // banner
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              )),
              child: Container(
                padding: const EdgeInsets.only(
                    bottom: 10, top: 5, left: 0, right: 0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.5),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFfee7e1),
                        Color(0xFFd7defa),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    )),
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            ),
            // space
            const SizedBox(
              height: 10,
            ),
            // about us content
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Expanded(
                child: Text(
                    'Welcome to Hair Fixing Zone, your premier destination for cutting-edge Hair Replacement solutions in Bangalore. Established in 2016, Hair Fixing Zone has emerged as a beacon of hope for individuals grappling with hair loss, Baldness, Hair thinning, or seeking to enhance their natural beauty. With four branches strategically located across Bangalore, we strive to provide convenient access to our specialized services, ensuring that every client receives the personalized care and attention they deserve.'),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFf15f22),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }
}