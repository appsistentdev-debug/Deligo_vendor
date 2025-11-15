abstract class WalletEvent {}

class FetchWalletBalanceEvent extends WalletEvent {}

class FetchWalletTransactionsEvent extends WalletEvent {
  final int page;
  FetchWalletTransactionsEvent(this.page);
}
