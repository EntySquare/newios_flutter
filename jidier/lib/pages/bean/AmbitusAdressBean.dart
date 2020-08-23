class AmbitusAdreesBean {
  String status;
  Regeocode regeocode;
  String info;
  String infocode;

  AmbitusAdreesBean({this.status, this.regeocode, this.info, this.infocode});

  AmbitusAdreesBean.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    regeocode = json['regeocode'] != null
        ? new Regeocode.fromJson(json['regeocode'])
        : null;
    info = json['info'];
    infocode = json['infocode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.regeocode != null) {
      data['regeocode'] = this.regeocode.toJson();
    }
    data['info'] = this.info;
    data['infocode'] = this.infocode;
    return data;
  }
}

class Regeocode {
  List<Roads> roads;
  List<Roadinters> roadinters;
  AddressComponent addressComponent;
  String formattedAddress;
  List<Pois> pois;

  Regeocode(
      {this.roads,
      this.roadinters,
      this.formattedAddress,
      this.addressComponent,
      this.pois});

  Regeocode.fromJson(Map<String, dynamic> json) {
    if (json['roads'] != null) {
      roads = new List<Roads>();
      json['roads'].forEach((v) {
        roads.add(new Roads.fromJson(v));
      });
    }
    if (json['roadinters'] != null) {
      roadinters = new List<Roadinters>();
      json['roadinters'].forEach((v) {
        roadinters.add(new Roadinters.fromJson(v));
      });
    }
    formattedAddress = json['formatted_address'];
    addressComponent = json['addressComponent'] != null
        ? new AddressComponent.fromJson(json['addressComponent'])
        : null;
    if (json['pois'] != null) {
      pois = new List<Pois>();
      json['pois'].forEach((v) {
        pois.add(new Pois.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roads != null) {
      data['roads'] = this.roads.map((v) => v.toJson()).toList();
    }
    if (this.roadinters != null) {
      data['roadinters'] = this.roadinters.map((v) => v.toJson()).toList();
    }
    data['formatted_address'] = this.formattedAddress;
    if (this.addressComponent != null) {
      data['addressComponent'] = this.addressComponent.toJson();
    }
    if (this.pois != null) {
      data['pois'] = this.pois.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roads {
  String id;
  String location;
  String direction;
  String name;
  String distance;

  Roads({this.id, this.location, this.direction, this.name, this.distance});

  Roads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    direction = json['direction'];
    name = json['name'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['direction'] = this.direction;
    data['name'] = this.name;
    data['distance'] = this.distance;
    return data;
  }
}

class Roadinters {
  String secondName;
  String firstId;
  String secondId;
  String location;
  String distance;
  String firstName;
  String direction;

  Roadinters(
      {this.secondName,
      this.firstId,
      this.secondId,
      this.location,
      this.distance,
      this.firstName,
      this.direction});

  Roadinters.fromJson(Map<String, dynamic> json) {
    secondName = json['second_name'];
    firstId = json['first_id'];
    secondId = json['second_id'];
    location = json['location'];
    distance = json['distance'];
    firstName = json['first_name'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['second_name'] = this.secondName;
    data['first_id'] = this.firstId;
    data['second_id'] = this.secondId;
    data['location'] = this.location;
    data['distance'] = this.distance;
    data['first_name'] = this.firstName;
    data['direction'] = this.direction;
    return data;
  }
}

class AddressComponent {
  String city;
  String province;
  String adcode;
  String district;
  String towncode;
  String country;
  String township;
  String citycode;

  AddressComponent(
      {this.city,
      this.province,
      this.adcode,
      this.district,
      this.towncode,
      this.country,
      this.township,
      this.citycode});

  AddressComponent.fromJson(Map<String, dynamic> json) {
    try {
      city = json['city'];
    } catch (e) {}
    province = json['province'];
    adcode = json['adcode'];
    district = json['district'];
    towncode = json['towncode'];
    country = json['country'];
    township = json['township'];
    citycode = json['citycode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['province'] = this.province;
    data['adcode'] = this.adcode;
    data['district'] = this.district;
    data['towncode'] = this.towncode;
    data['country'] = this.country;
    data['township'] = this.township;
    data['citycode'] = this.citycode;
    return data;
  }
}

class Pois {
  String id;
  String direction;
  String poiweight;
  String name;
  String location;
  String distance;
  String type;

  Pois(
      {this.id,
      this.direction,
      this.poiweight,
      this.name,
      this.location,
      this.distance,
      this.type});

  Pois.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    direction = json['direction'];
    poiweight = json['poiweight'];
    name = json['name'];
    location = json['location'];
    distance = json['distance'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['direction'] = this.direction;
    data['poiweight'] = this.poiweight;
    data['name'] = this.name;
    data['location'] = this.location;
    data['distance'] = this.distance;
    data['type'] = this.type;
    return data;
  }
}
