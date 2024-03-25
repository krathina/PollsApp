class User {
  int? _expiresIn;
  String? _accessToken;
  String? _refreshToken;

  User(this._expiresIn, this._accessToken, this._refreshToken);

  User.map(dynamic obj) {
    _expiresIn = obj["expires_in"];
    _accessToken = obj["access_token"];
    _refreshToken = obj["refresh_token"];
  }

  int? get expires_in => _expiresIn;
  String? get access_token => _accessToken;
  String? get refresh_token => _refreshToken;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["expires_in"] = _expiresIn;
    map["access_token"] = _accessToken;
    map["refresh_token"] = _refreshToken;

    return map;
  }
}
