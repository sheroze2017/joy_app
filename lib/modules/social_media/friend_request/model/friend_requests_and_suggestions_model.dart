import 'all_friend_request_model.dart';

class FriendRequestsAndSuggestions {
  int? code;
  bool? sucess;
  FriendRequestsAndSuggestionsData? data;
  String? message;

  FriendRequestsAndSuggestions({this.code, this.sucess, this.data, this.message});

  FriendRequestsAndSuggestions.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null
        ? FriendRequestsAndSuggestionsData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class FriendRequestsAndSuggestionsData {
  List<FriendRequest>? friendRequests;
  List<Suggestion>? friends;
  List<Suggestion>? suggestions;

  FriendRequestsAndSuggestionsData({this.friendRequests, this.friends, this.suggestions});

  FriendRequestsAndSuggestionsData.fromJson(Map<String, dynamic> json) {
    if (json['friend_requests'] != null) {
      friendRequests = <FriendRequest>[];
      json['friend_requests'].forEach((v) {
        friendRequests!.add(FriendRequest.fromJson(v));
      });
    } else {
      friendRequests = [];
    }
    if (json['friends'] != null) {
      friends = <Suggestion>[];
      json['friends'].forEach((v) {
        friends!.add(Suggestion.fromJson(v));
      });
    } else {
      friends = [];
    }
    if (json['suggestions'] != null) {
      suggestions = <Suggestion>[];
      json['suggestions'].forEach((v) {
        suggestions!.add(Suggestion.fromJson(v));
      });
    } else {
      suggestions = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.friendRequests != null) {
      data['friend_requests'] =
          this.friendRequests!.map((v) => v.toJson()).toList();
    }
    if (this.friends != null) {
      data['friends'] = this.friends!.map((v) => v.toJson()).toList();
    }
    if (this.suggestions != null) {
      data['suggestions'] = this.suggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suggestion {
  dynamic id; // _id from API
  dynamic userId;
  String? name;
  String? location;
  String? userRole;
  String? image;

  Suggestion(
      {this.id,
      this.userId,
      this.name,
      this.location,
      this.userRole,
      this.image});

  Suggestion.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? json['_id'] ?? json['id'];
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    id = userId;
    name = json['name']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    userRole = json['user_role']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['location'] = this.location;
    data['user_role'] = this.userRole;
    data['image'] = this.image;
    return data;
  }
}
