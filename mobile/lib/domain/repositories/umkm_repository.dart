import '../../domain/entities/umkm_sale.dart';
import '../../domain/entities/umkm_debt.dart';

abstract class UmkmRepository {
  Future<void> addSale(UmkmSale sale);
  Future<List<UmkmSale>> getAllSales();

  Future<void> addDebt(UmkmDebt debt);
  Future<List<UmkmDebt>> getAllDebts();
}
