class RFIDWorkbook {
  String? shipIDIMO;
  String? purchaseOrder;
  String? rFID;
  String? assetDescription;
  String? storeName;

  RFIDWorkbook({
    this.shipIDIMO,
    this.purchaseOrder,
    this.rFID,
    this.assetDescription,
    this.storeName,
  });

  factory RFIDWorkbook.fromMap(Map<String, dynamic> map) {
    return RFIDWorkbook(
      shipIDIMO: map['Ship ID (IMO)'] as String?,
      purchaseOrder: map['PurchaseOrder #'] as String?,
      rFID: map['RFID #'] as String?,
      assetDescription: map['Asset description'] as String?,
      storeName: map['Store Name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Ship ID (IMO)': shipIDIMO,
      'PurchaseOrder #': purchaseOrder,
      'RFID #': rFID,
      'Asset description': assetDescription,
      'Store Name': storeName,
    };
  }
}
