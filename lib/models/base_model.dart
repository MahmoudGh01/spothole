import 'dart:convert';

abstract class BaseModel {
  Map<String, dynamic> toJson();
  //static BaseModel fromJson(Map<String, dynamic> json);
}
