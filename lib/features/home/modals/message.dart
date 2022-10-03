import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  const Message({
    this.content,
    this.id,
    this.idFrom,
    this.idTo,
    this.read,
    this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }
  final String? content;
  final String? id;
  final String? idFrom;
  final String? idTo;
  final bool? read;
  final String? timestamp;

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String? content,
    String? idFrom,
    String? idTo,
    bool? read,
    String? timestamp,
    String? id,
  }) {
    return Message(
      content: content ?? this.content,
      id: id ?? this.id,
      idFrom: idFrom ?? this.idFrom,
      idTo: idTo ?? this.idTo,
      read: read ?? this.read,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [content, idFrom, idTo, read, timestamp, id];
}
