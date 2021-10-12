import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconFile {
  static Icon getWeatherIcones(
      {String? weatherDescription = "Clear",
      Color? color = Colors.pink,
      double? size = 20.0}) {
    switch (weatherDescription) {
      case "Clear":
        return Icon(
          FontAwesomeIcons.sun,
          color: color,
          size: size,
        );
      case "Clouds":
        return Icon(
          FontAwesomeIcons.cloud,
          color: color,
          size: size,
        );
      case "Rain":
        return Icon(
          FontAwesomeIcons.cloudRain,
          color: color,
          size: size,
        );
      case "Snow":
        return Icon(
          FontAwesomeIcons.snowman,
          color: color,
          size: size,
        );
      case "Thermo":
        return Icon(
          FontAwesomeIcons.thermometerHalf,
          color: color,
          size: size,
        );
      case "Smile":
        return Icon(
          FontAwesomeIcons.smileWink,
          color: color,
          size: size,
        );
      case "Hum":
        return Icon(
          FontAwesomeIcons.tachometerAlt,
          color: color,
          size: size,
        );
      default:
        return Icon(
          FontAwesomeIcons.sun,
          color: color,
          size: size,
        );
    }
  }
}
