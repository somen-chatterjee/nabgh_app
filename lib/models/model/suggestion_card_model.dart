
import 'dart:ui';

class SuggestionCardModel {
  final String? imgSrc;
  String title;
  String subtitle;
  Function onTap;
  Color color;

  SuggestionCardModel(
      {required this.subtitle, required this.title, required this.imgSrc, required this.onTap, required this.color});

  // Setter for title
  // set setTitle(String newName) => title = newName;

  // Setter for subtitle
  // set setSubtitle(String newName) => subtitle = newName;
}

