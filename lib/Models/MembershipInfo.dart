class MembershipInfo {
  String id, expires_at, status;

  int is_expired;

  bool is_offline, is_complementary;

  MembershipInfo(this.id, this.expires_at, this.status, this.is_offline,
      this.is_complementary, this.is_expired);
}