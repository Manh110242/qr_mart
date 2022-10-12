class NotificationModle {
  String id,
      title,
      description,
      link,
      type,
      recipient_id,
      sender_id,
      unread,
      created_at,
      updated_at;

  NotificationModle(
      {this.id,
      this.title,
      this.description,
      this.link,
      this.type,
      this.recipient_id,
      this.sender_id,
      this.unread,
      this.created_at,
      this.updated_at});
}
