import "package:flutter/material.dart";

// Route Factory for creating routes for screen widget
class LimsRouteFactory {
  static Route createRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}