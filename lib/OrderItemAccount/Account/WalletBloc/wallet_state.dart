import 'package:delivoo_store/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';

abstract class WalletState {}

class LoadingWalletInitialState extends WalletState {}

class LoadingWalletLoadingState extends WalletState {}

class LoadingWalletLoadedState extends WalletState {}

class LoadingWalletLoadFailedState extends WalletState {}

class WalletBalanceLoaded extends LoadingWalletLoadedState {
  final double balance;
  WalletBalanceLoaded(this.balance);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletBalanceLoaded && other.balance == balance;
  }

  @override
  int get hashCode => balance.hashCode;
}

class WalletTransactionsLoaded extends LoadingWalletLoadedState {
  final BaseListResponse<Transaction> transactionsResponse;
  WalletTransactionsLoaded(this.transactionsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletTransactionsLoaded &&
        other.transactionsResponse == transactionsResponse;
  }

  @override
  int get hashCode => transactionsResponse.hashCode;
}

class WalletTransactionsFailed extends LoadingWalletLoadFailedState {}
