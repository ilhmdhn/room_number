import 'package:event_bus/event_bus.dart';
import 'package:room_number/data/model/room_detail_model.dart';

EventBus eventBusRoom = EventBus();

class RoomDetailEvent {
  RoomDetailResult detailRoom;
  RoomDetailEvent(this.detailRoom);
}

class RoomServiceEvent {
  bool service = false;
  RoomServiceEvent(this.service);
}
