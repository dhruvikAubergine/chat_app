import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserProfile extends Equatable {
  const UserProfile({
    this.id,
    this.email,
    this.fullName,
    this.phone,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final String? fullName;
  @HiveField(3)
  final int? phone;
  @HiveField(4)
  final String? profilePictureUrl;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? email,
    String? id,
    String? fullName,
    int? phone,
    String? profilePictureUrl,
  }) {
    return UserProfile(
      email: email ?? this.email,
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, fullName, phone, profilePictureUrl, id];
}
