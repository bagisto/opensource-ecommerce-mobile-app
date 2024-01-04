class SocialLoginModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;
  int? isSocial;
  String? photoUrl;
  String? serverAuthCode;
  String? authProvider;
  String? token;


  SocialLoginModel.empty();

  SocialLoginModel({
    this.lastName,
    this.firstName,
    this.id,
    this.email,
    this.isSocial,
    this.photoUrl,
    this.serverAuthCode,
    this.authProvider,
    this.token,

  });

  Map<String, dynamic> toJson() {
    var data = {
      "id": id,
      "email": email,
      "firstname": firstName,
      "lastname": lastName,
      "isSocial":isSocial,
      "photoUrl":photoUrl,
      "serverAuthCode": serverAuthCode,
      "authProvider": authProvider,
      "token": token,

    };

    return data;
  }
}
