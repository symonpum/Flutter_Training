class PaymentService {
  Future<bool> process({required double amount, required String method}) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // simulate success
  }
}
