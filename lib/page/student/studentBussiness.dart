import 'package:easy_search/easy_search.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class studentBussinessPage extends StatefulWidget {
  @override
  _studentBussinessPageState createState() => _studentBussinessPageState();
}

class _studentBussinessPageState extends State<studentBussinessPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
                color: Colors.white,
                child: StaggeredGridView.countBuilder(
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  //cross axis cell count
                  mainAxisSpacing: 8,
                  // vertical spacing between items
                  crossAxisSpacing: 8,
                  // horizontal spacing between items
                  crossAxisCount: 2,
                  // no. of virtual columns in grid
                  itemCount: 3,
                  itemBuilder: (context, index) => buildImageCard(index),
                ),
              );
  }

  Widget buildImageCard(int index) => InkWell(
    child: Card(
      color: Colors.white,
      // margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        child: ClipRRect(
          // clip the image to a circle
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://source.unsplash.com/random?sig=$index',
              fit: BoxFit.cover,
            )),
      ),
    ),
    onTap: (){
      print('object');
    },
  );
}


