import 'package:dude_music/Screens/splash_screen.dart';
import 'package:dude_music/db/model/dbfunctions.dart';
import 'package:flutter/material.dart';

import '../db/model/model.dart';

class Favbutton extends StatefulWidget {
 Favbutton({super.key,required this.index});
  int index;

  @override
  State<Favbutton> createState() => _FavbuttonState();
}
List<Favsongs> fav = [];
List<Songs> songs = box.values.toList();

class _FavbuttonState extends State<Favbutton> {
  @override
  Widget build(BuildContext context) {
    fav = favdb.values.toList();
    

    return Row(
      children:[
        fav.where((element) => element.id == songs[widget.index].id.toString()).isEmpty 
        ? IconButton(onPressed: (){
          favdb.add(
                    Favsongs(
                      artist: songs[widget.index].artist,
                      duration: songs[widget.index].duration.toString(),
                      songname: songs[widget.index].songname,
                      songurl: songs[widget.index].songurl,
                      id: songs[widget.index].id.toString(),
                      //index: widget.index,
                    ),
                  );
                  setState((){});
                  print(favdb.values.toString());
        }, 
        icon: const Icon(Icons.favorite_outline,color: Colors.white,),
        )
        : IconButton(onPressed: () async{
           int currentIndex = fav.indexWhere((element) =>
                      element.id == songs[widget.index].id.toString());
                  await favdb.deleteAt(currentIndex);
                  setState(() {});
        }, icon: const Icon(Icons.favorite_sharp,color: Colors.red,),)
      ]
      
    );
  }
}