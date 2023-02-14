class RoomDetailResult {
  bool isLoading;
  bool? state;
  String? message;
  RoomDetail? roomDetail;

  RoomDetailResult({
    this.isLoading = true,
    this.state,
    this.message,
    this.roomDetail,
  });

  factory RoomDetailResult.fromJson(Map<String, dynamic> json) {
    if (json['state'] == false) {
      throw json['message'];
    }
    return RoomDetailResult(
      isLoading: false,
      state: json['state'],
      message: json['message'],
      roomDetail: RoomDetail.fromJson(json['data'])
    );
  }
}

class RoomDetail {
  String? roomCode;
  int? roomCapacity;
  String? guestName;
  int? roomService;
  String? roomAlias;
  int? checkinState;

  RoomDetail({
    this.roomCode,
    this.roomCapacity,
    this.guestName,
    this.roomService,
    this.roomAlias,
    this.checkinState,
  });

  factory RoomDetail.fromJson(Map<String, dynamic>json){
    return RoomDetail(
      roomCode: json['room_code'],
      roomCapacity: json['room_capacity'],
      guestName: json['guest_name'],
      roomService: json['room_service'],
      roomAlias: json['room_alias'],
      checkinState: json['checkin_state'],
    );
  }
}