enum Sender { user, bot }

class Messages {
  final String text;
  final Sender sender;
  final DateTime timestamp;

  Messages({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': sender == Sender.user ? 'user' : 'bot',
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      text: json['text'],
      sender: json['sender'] == 'user' ? Sender.user : Sender.bot,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class GroupedMessages {
  final String date;
  final List<Messages> messages;

  GroupedMessages({required this.date, required this.messages});
}
