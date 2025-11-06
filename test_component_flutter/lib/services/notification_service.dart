import 'package:flutter/widgets.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ValueNotifier<int> amountNotificationNotifier = ValueNotifier(0);
}
