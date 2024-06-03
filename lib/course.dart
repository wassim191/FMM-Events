import 'package:flutter/material.dart';

class Coursee {
  String Prof;
  String description;
  double quantity;
  String category;
  double price;
  String images;
  double phone;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Coursee(this.Prof, this.description, this.quantity, this.category, this.price,
      this.images, this.phone, this.date, this.startTime, this.endTime);
}
