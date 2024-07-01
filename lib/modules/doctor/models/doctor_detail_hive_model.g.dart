// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_detail_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorDetailModelAdapter extends TypeAdapter<DoctorDetailModel> {
  @override
  final int typeId = 1;

  @override
  DoctorDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorDetailModel(
      code: fields[0] as int?,
      success: fields[1] as bool?,
      data: fields[2] as DataModel?,
      message: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorDetailModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.success)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataModelAdapter extends TypeAdapter<DataModel> {
  @override
  final int typeId = 2;

  @override
  DataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel(
      userId: fields[0] as int?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String?,
      image: fields[4] as String?,
      userRole: fields[5] as String?,
      authType: fields[6] as String?,
      phone: fields[7] as String?,
      deviceToken: fields[8] as String?,
      doctorDetailId: fields[9] as int?,
      gender: fields[10] as String?,
      expertise: fields[11] as String?,
      location: fields[12] as String?,
      consultationFee: fields[13] as String?,
      qualifications: fields[14] as String?,
      reviews: (fields[15] as List?)?.cast<ReviewModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DataModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.userRole)
      ..writeByte(6)
      ..write(obj.authType)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.deviceToken)
      ..writeByte(9)
      ..write(obj.doctorDetailId)
      ..writeByte(10)
      ..write(obj.gender)
      ..writeByte(11)
      ..write(obj.expertise)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.consultationFee)
      ..writeByte(14)
      ..write(obj.qualifications)
      ..writeByte(15)
      ..write(obj.reviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewModelAdapter extends TypeAdapter<ReviewModel> {
  @override
  final int typeId = 3;

  @override
  ReviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewModel(
      rating: fields[0] as String?,
      review: fields[1] as String?,
      status: fields[2] as String?,
      giveBy: fields[3] as GiveByModel?,
      reviewId: fields[4] as int?,
      createdAt: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.review)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.giveBy)
      ..writeByte(4)
      ..write(obj.reviewId)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GiveByModelAdapter extends TypeAdapter<GiveByModel> {
  @override
  final int typeId = 4;

  @override
  GiveByModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GiveByModel(
      name: fields[0] as String?,
      image: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GiveByModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiveByModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
