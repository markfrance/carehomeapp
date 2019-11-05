import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class DetailScreen extends StatelessWidget {

  final String fullImageUrl;

  DetailScreen(this.fullImageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl:  fullImageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
           
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}