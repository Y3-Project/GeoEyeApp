class Comment {
  String content = ''; // the actual comment
  String post = ''; // the post which the comment is attached to
  List<dynamic> reports = List.empty(
      growable:
          true); // this is an array of refs to users who have reported the post
  String user = ''; // the author of the comment

  /* Constructor */
  Comment(
      {required this.content,
      required this.post,
      required this.reports,
      required this.user});
}
