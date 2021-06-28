class SubscriptionInitialInfo {
  String id,
      razorpay_subscription_id,
      razorpay_plan_id,
      status,
      short_url,
      expires_at_datetime;

  int plan_id;

  SubscriptionInitialInfo(
      this.id,
      this.razorpay_subscription_id,
      this.plan_id,
      this.razorpay_plan_id,
      this.status,
      this.short_url,
      this.expires_at_datetime);
}
