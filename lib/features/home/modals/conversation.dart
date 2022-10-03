import 'package:chat_app/features/home/modals/message.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation extends Equatable {
  const Conversation({this.id, this.users, this.lastMessage});
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return _$ConversationFromJson(json);
  }
  final String? id;
  final List<String>? users;
  final Message? lastMessage;

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  Conversation copyWith({
    String? id,
    List<String>? users,
    Message? lastMessage,
  }) {
    return Conversation(
      id: id ?? this.id,
      users: users ?? this.users,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, users, lastMessage];
}
