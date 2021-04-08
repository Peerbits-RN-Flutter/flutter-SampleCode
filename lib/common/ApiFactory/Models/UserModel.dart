import 'package:get/get.dart';

var KcurrentUser = UserModel().obs;

class UserModel {
  String? about_company;
  String? company_name;
  String? email;
  int? id;
  String? image;
  int? is_email_verified;
  bool? is_profile_completed;
  String? website;
  String? benefits;

  UserModel(
      {this.about_company,
      this.company_name,
      this.email,
      this.id,
      this.image,
      this.is_email_verified,
      this.is_profile_completed,
      this.website,
      this.benefits});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      about_company: json['about_company'],
      company_name: json['company_name'],
      email: json['email'],
      id: json['id'],
      image: json['image'],
      is_email_verified: json['is_email_verified'],
      is_profile_completed: json['is_profile_completed'] == 0 ? false : true,
      website: json['website'],
      benefits: json['benefits'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_company'] = this.about_company;
    data['company_name'] = this.company_name;
    data['email'] = this.email;
    data['id'] = this.id;
    data['image'] = this.image;
    data['is_email_verified'] = this.is_email_verified;
    data['is_profile_completed'] = this.is_profile_completed;
    data['website'] = this.website;
    data['benefits'] = this.benefits;
    return data;
  }

  Map<String, dynamic> updateProfiletoJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['company_name'] = this.company_name;
    data['email'] = this.email;
    data['website'] = this.website;
    data['about_company'] = this.about_company;
    data['benefits'] = this.benefits;
    return data;
  }
}
