enum CheckType { 
   mood, 
   vitals, 
   medication, 
   nutrition,
   body,
   other,
}

class Comment{
  final String carer;
  final DateTime time;
  final String text;

  Comment(this.carer,this.time, this.text);
}

class FeedItem {
  final String name;
  DateTime date;
  final CheckType type;
  final String body;
  String imageUrl;
  List<Comment> comments;

  FeedItem(this.name, this.type, this.body );
}