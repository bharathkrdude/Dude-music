import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../style.dart';
import 'privacy_policy.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

bool notificationSwitch = true;

class _ScreenSettingsState extends State<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Image.asset(
              "assets/IMAGES/Settings.png",
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            // TextButton(onPressed: (){ Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => const PrivacyPolicy()));}, child: const Text('Privacy Policy',style: settingsText,)),
            Column(
              children: [
                ListTile(
                  title: Text(
                    'Share this app',
                    style: settingsText,
                  ),
                  trailing: IconButton(
                      onPressed: () async  {
                        final urlpreview = 'https://youtu.be/9_iyRGuSGS0';
                        await Share.share('$urlpreview');
                      },
                      icon: Icon(
                        Icons.share_outlined,
                        color: Colors.limeAccent,
                        size: 25,
                      )),
                ),
                ListTile(
                  title: const Text(
                    'Privacy Policy',
                    style: settingsText,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()));
                  },
                ),
                const NotificationSwitch(),
                ListTile(
                  title: const Text(
                    'About',
                    style: settingsText,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AboutPage()));
                  },
                ),
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //   //   TextButton(onPressed: (){}, child: const Text('Nottification')),
            //   // Switch(activeColor: Colors.blue,inactiveTrackColor: Colors.white, value: false, onChanged: (bool){})
            //   ],
            // ),

            // TextButton(onPressed: (){Navigator.of(context).push(
            //             MaterialPageRoute(builder: (context) => const AboutPage()));}, child: const Text('About',style: settingsText,)),
          ],
        ),
      ),
    );
  }
}

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Notifications',
        style: settingsText,
      ),
      trailing: Switch(
        inactiveTrackColor: Colors.white,
        value: notificationSwitch,
        onChanged: (newValue) {
          // print(newValue);
          setState(() {
            notificationSwitch = newValue;
          });
          // print(notificationSwitch);
        },
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LicensePage(
      applicationName: 'Dude Music',
      applicationIcon: Image(
        image: AssetImage('assets/IMAGES/mainlogo.png'),
      ),
      applicationVersion: '1.0',
      applicationLegalese: 'Developed By \nBharath KR',
    );
  }
}
