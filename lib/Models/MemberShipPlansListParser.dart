class MemberShipPlansListParser {
  int id, recurring_count, billing_cycle_days;
  double amount;
  String razorpay_plan_id, currency, name, description;

  MemberShipPlansListParser(
      {this.id,
      this.razorpay_plan_id,
      this.currency,
      this.amount,
      this.name,
      this.description,
      this.recurring_count,
      this.billing_cycle_days});

  factory MemberShipPlansListParser.fromJson(Map<String, dynamic> json) =>
      MemberShipPlansListParser(
          id: json["id"],
          razorpay_plan_id: json["razorpay_plan_id"],
          currency: json["currency"],
          amount: json["amount"],
          name: json["name"],
          description: json["description"],
          recurring_count: json["recurring_count"],
          billing_cycle_days: json["billing_cycle_days"]);
}
