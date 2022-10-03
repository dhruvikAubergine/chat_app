// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      content: json['content'] as String?,
      id: json['id'] as String?,
      idFrom: json['idFrom'] as String?,
      idTo: json['idTo'] as String?,
      read: json['read'] as bool?,
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'content': instance.content,
      'id': instance.id,
      'idFrom': instance.idFrom,
      'idTo': instance.idTo,
      'read': instance.read,
      'timestamp': instance.timestamp,
    };
