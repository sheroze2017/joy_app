class Places {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? clas;
  String? type;
  int? placeRank;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  Places(
      {this.placeId,
      this.licence,
      this.osmType,
      this.osmId,
      this.lat,
      this.lon,
      this.clas,
      this.type,
      this.placeRank,
      this.importance,
      this.addresstype,
      this.name,
      this.displayName,
      this.address,
      this.boundingbox});

  Places.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    licence = json['licence'];
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    lat = json['lat'];
    lon = json['lon'];
    clas = json['class'];
    type = json['type'];
    placeRank = json['place_rank'];
    importance = json['importance'];
    addresstype = json['addresstype'];
    name = json['name'];
    displayName = json['display_name'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    boundingbox = json['boundingbox'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_id'] = this.placeId;
    data['licence'] = this.licence;
    data['osm_type'] = this.osmType;
    data['osm_id'] = this.osmId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['class'] = this.clas;
    data['type'] = this.type;
    data['place_rank'] = this.placeRank;
    data['importance'] = this.importance;
    data['addresstype'] = this.addresstype;
    data['name'] = this.name;
    data['display_name'] = this.displayName;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['boundingbox'] = this.boundingbox;
    return data;
  }
}

class Address {
  String? cityDistrict;
  String? county;
  String? stateDistrict;
  String? state;
  String? iSO31662Lvl4;
  String? country;
  String? countryCode;

  Address(
      {this.cityDistrict,
      this.county,
      this.stateDistrict,
      this.state,
      this.iSO31662Lvl4,
      this.country,
      this.countryCode});

  Address.fromJson(Map<String, dynamic> json) {
    cityDistrict = json['city_district'];
    county = json['county'];
    stateDistrict = json['state_district'];
    state = json['state'];
    iSO31662Lvl4 = json['ISO3166-2-lvl4'];
    country = json['country'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_district'] = this.cityDistrict;
    data['county'] = this.county;
    data['state_district'] = this.stateDistrict;
    data['state'] = this.state;
    data['ISO3166-2-lvl4'] = this.iSO31662Lvl4;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    return data;
  }
}
