import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  bool banned = false;
  String biography = '';
  List<dynamic> blockedUsers = [];
  String email = '';
  List<dynamic> followers = [];
  List<dynamic> following = [];
  bool moderator = false;
  String profilePicture = '';
  List<dynamic> reports = [];
  String timeoutStart = '';
  String username = '';
  String uuid = '';
  String id = '/users/';

  UserModel();
  /* Constructor */
  UserModel.setUser({
    required this.banned,
    required this.biography,
    required this.blockedUsers,
    required this.email,
    required this.followers,
    required this.following,
    required this.moderator,
    required this.profilePicture,
    required this.reports,
    required this.timeoutStart,
    required this.username,
    required this.uuid,
    required this.id
  });

  /* Convert a document to a User object */
  UserModel.fromDocument(DocumentSnapshot doc) {
    this.banned = doc['banned'];
    this.biography = doc['biography'];
    this.blockedUsers = doc['blockedUsers'];
    this.email = doc['email'];
    this.followers = doc['followers'];
    this.following = doc['following'];
    this.moderator = doc['moderator'];
    this.profilePicture = doc['profilePicture'];
    this.reports = doc['reports'];
    this.timeoutStart = doc['timeoutStart'];
    this.username = doc['username'];
    this.uuid = doc['uuid'];
    this.id = doc.id;
  }
}
