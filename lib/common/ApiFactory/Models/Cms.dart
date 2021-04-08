class Cms {
  String? about;
  String? privacy_policy;
  String? terms_and_conditions;

  Cms({this.about, this.privacy_policy, this.terms_and_conditions});

  factory Cms.fromJson(Map<String, dynamic> json) {
    return Cms(
      about: json['about'],
      privacy_policy: json['privacy_policy'],
      terms_and_conditions: json['terms_and_conditions'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['privacy_policy'] = this.privacy_policy;
    data['terms_and_conditions'] = this.terms_and_conditions;
    return data;
  }
}
