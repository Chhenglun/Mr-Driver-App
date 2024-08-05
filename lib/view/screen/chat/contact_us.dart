import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../util/color_resources.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Uri phoneNumber = Uri(scheme: 'tel', path: '0965482772');
  Uri telegramUri = Uri.parse('https://t.me/TaiiHor');
  Uri emailAddress = Uri(
    scheme: 'mailto',
    path: 'boutaihor571@gmail.com',
    query: 'How can I help you?',
  );

  Future<void> callNumber() async {
    await launchUrl(phoneNumber);
  }

  Future<void> CallUs() async {
    await FlutterPhoneDirectCaller.callNumber('0965482772');
  }

  Future<void> EmailUs() async {
    await launchUrl(emailAddress);
  }

  Future<void> TelegramUs() async {
    if (await canLaunchUrl(telegramUri)) {
      await launchUrl(telegramUri);
    } else {
      throw 'Could not launch $telegramUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: ColorResources.whiteColor),
        ),
        title: Text('ទំនាក់ទំនងយេីង', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: ColorResources.primaryColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo_no_background.jpg',
            width: 200,
            height: 200,
          ),
          ContactButton(
            onPressed: callNumber,
            icon: Icons.phone,
            text: 'ទំនាក់ទំនងយេីងតាមលេខទូរស័ព្ទ', color: Colors.green,
          ),
          ContactButton(
            onPressed: EmailUs,
            icon: Icons.email,
            text: 'ទំនាក់ទំនងយេីងតាមអ៊ីមែល', color: ColorResources.primaryColor,
          ),
          ContactButton(
            onPressed: TelegramUs,
            icon: Icons.telegram,
            text: 'ទំនាក់ទំនងយេីងតាមតេឡេក្រាម', color: ColorResources.blueColor,
          ),
        ],
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final Color color;

  const ContactButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: ColorResources.whiteColor),
            SizedBox(width: 40),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 20, color: ColorResources.whiteColor),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
