// ignore_for_file: prefer_collection_literals

class DeviceInfoModel {
  String? deviceName;
  String? deviceToken;
  String? location;
  String? fcmToken;
  String? country;
  String? ipAddress;
  int? pushChannel;

  DeviceInfoModel({
    this.deviceName,
    this.deviceToken,
    this.location,
    this.fcmToken,
    this.country,
    this.ipAddress,
    this.pushChannel
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['device_name'] = deviceName;
    data['device_token'] = deviceToken;
    data['location'] = location;
    data['push_token'] = fcmToken;
    data['country'] = country;
    data['ip_address'] = ipAddress;
    data['push_channel'] = pushChannel;
    return data;
  }
}