class DownloadableFiltersInput {
  String? title;
  String? status;
  String? orderId;
  String? orderDateFrom;
  String? orderDateTo;
  int? selectedDateIndex;

  DownloadableFiltersInput({
    this.status, this.orderId, this.title, this.orderDateFrom, this.orderDateTo,
    this.selectedDateIndex = -1
 });
}