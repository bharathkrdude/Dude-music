import 'package:dude_music/db/model/dbfunctions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../db/model/model.dart';
import '../../style.dart';

bool textformVisibility = false;


class IfNoPlaylist extends StatefulWidget {
  const IfNoPlaylist({
    Key? key,
  }) : super(key: key);

  @override
  State<IfNoPlaylist> createState() => _IfNoPlaylistState();
}

class _IfNoPlaylistState extends State<IfNoPlaylist> {
  TextEditingController textcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: textformVisibility,
            child: Form(
              key: formkey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                autofocus: true,
                controller: textcontroller,
                cursorHeight: 25,
                decoration: InputDecoration(
                  hintText: 'Playlist name',
                  hintStyle: songnametext,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  List<Playlists> values = playlistsBox.values.toList();

                  bool isAlreadyAdded = values
                      .where((element) => element.playlistname == value!.trim())
                      .isNotEmpty;

                  if (value!.trim() == '') {
                    return 'Name Required';
                  }
                  if (isAlreadyAdded) {
                    return 'This Name Already Exist';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20), 
          addsongbutton(context),
          // 
        ],
      ),
    );
  }

  addPlaylist() { 
    if (formkey.currentState!.validate()) {
      playlistsBox
          .add(Playlists(playlistname: textcontroller.text, playlistsonglist: []));
      setState(() {
        textformVisibility = false;
      });
    }
    // Navigator.pop(context);
  }
  Container addsongbutton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.34,
    decoration: BoxDecoration(
      color:Colors.white,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              textformVisibility == false
                  ? setState(() {
                      textformVisibility = true;
                    })
                  : addPlaylist();
            },
            child:  const Text('Create Playlists', style: TextStyle(color: Colors.black,)),
          )
        ],
      ),
    ),
  );
}
}

Future<dynamic> playlistBottomSheet(BuildContext context, int songindex) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(0)),
            ),
            child: ValueListenableBuilder<Box<Playlists>>(
              valueListenable:Hive.box<Playlists>('playlists').listenable(),
              builder: (context, Box<Playlists> playlistBox, _) {
                List<Playlists> Playlist = playlistBox.values.toList();

                if (playlistBox.isEmpty) {
                  return const IfNoPlaylist();
                }
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Playlist',
                      style: songnametext,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: Playlist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(
                              Icons.headphones_rounded,
                              color: Colors.white,
                            ),
                            title: Text(
                              Playlist[index].playlistname,
                              style: songnametext,
                            ),
                            onTap: () {
                              Playlists? plsongs = playlistBox.getAt(index);
                              List<Songs>? plnewsongs = plsongs!.playlistsonglist;
                              Box<Songs> box = Hive.box('Songs');
                              List<Songs> dbAllsongs = box.values.toList();
                              bool isAlreadyAdded = plnewsongs.any((element) =>
                                  element.id ==
                                  dbAllsongs[songindex].id);

                              if (!isAlreadyAdded) {
                                plnewsongs.add(
                                  Songs(
                                    songname:
                                        dbAllsongs[songindex].songname,
                                    artist: dbAllsongs[songindex].artist,
                                    duration:
                                        dbAllsongs[songindex].duration,
                                    songurl:
                                        dbAllsongs[songindex].songurl,
                                    id: dbAllsongs[songindex].id,
                                    count: dbAllsongs[songindex].count
                                  ),
                                );

                                playlistBox.putAt(
                                  index,
                                 Playlists(playlistname: Playlist[index].playlistname, playlistsonglist: plnewsongs)
                                );

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.black,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                        '${dbAllsongs[songindex].songname}Added to ${Playlist[index].playlistname}')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.black,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                        '${dbAllsongs[songindex].songname} is already added')));
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                    const IfNoPlaylist(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
