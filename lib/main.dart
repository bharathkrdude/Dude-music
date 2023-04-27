import 'package:dude_music/Screens/splash_screen.dart';
import 'package:dude_music/db/model/model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>('Songs');

  Hive.registerAdapter(FavsongsAdapter());
  await Hive.openBox<Favsongs>('favsongs');

  Hive.registerAdapter(RecentSongsAdapter());
  await Hive.openBox<RecentSongs>('recentsongs');

  Hive.registerAdapter(PlaylistsAdapter());
  await Hive.openBox<Playlists>('playlists');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return MaterialApp(
      title: 'Dude Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
        primarySwatch: Colors.blue,
      ),
      home: const ScreenSplash(),
    );
  }
}
