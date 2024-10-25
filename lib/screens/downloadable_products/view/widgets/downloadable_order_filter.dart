
import 'package:intl/intl.dart';
import '../../utils/index.dart';

class DownloadableOrderFilters extends StatefulWidget {
  final DownloadableFiltersInput? appliedFilters;
  const DownloadableOrderFilters({this.appliedFilters, super.key});

  @override
  State<DownloadableOrderFilters> createState() => _DownloadableOrderFiltersState();
}

class _DownloadableOrderFiltersState extends State<DownloadableOrderFilters> {
  TextEditingController orderIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  List<String> status = [];
  int _currentStatus = 0;
  int _currentDate = -1;
  List<String> dates = [];
  String? fromDate;
  String? toDate;

  @override
  void initState() {
    status = [
      StringConstants.pending.localized(),
      StringConstants.available.localized(),
      StringConstants.expired.localized(),
    ];

    dates = [
      StringConstants.today.localized(),
      StringConstants.yesterday.localized(),
      StringConstants.thisWeek.localized(),
      StringConstants.thisMonth.localized(),
      StringConstants.lastMonth.localized(),
      StringConstants.last3Months.localized(),
      StringConstants.last6Months.localized(),
      StringConstants.thisYear.localized(),
    ];

    if(widget.appliedFilters != null){
      orderIdController.text = widget.appliedFilters?.orderId ?? "";
      titleController.text = widget.appliedFilters?.title ?? "";
      fromDateController.text = widget.appliedFilters?.orderDateFrom ?? "";
      toDateController.text = widget.appliedFilters?.orderDateTo ?? "";
      fromDate = fromDateController.text;
      toDate = toDateController.text;
      _currentDate = widget.appliedFilters?.selectedDateIndex ?? -1;
      int index = status.indexOf(widget.appliedFilters?.status ?? "");
      _currentStatus = index >= 0 ? index : 0;
    }
    super.initState();
  }

  @override
  void dispose() {
    orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(StringConstants.applyFilters.localized(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 20),
                  titleName(StringConstants.orderId.localized(), context),
                  CommonWidgets().getTextField(context, orderIdController,
                      StringConstants.orderId.localized(), keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  titleName(StringConstants.titleLabel.localized(), context),
                  CommonWidgets().getTextField(
                      context, titleController, StringConstants.titleLabel.localized()),
                  const SizedBox(height: 20),
                  titleName(StringConstants.date.localized(), context),
                  GridView.builder(
                      itemCount: dates.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3.5,
                          mainAxisSpacing: 16),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentDate = index;
                            });
                            setSelectedDate(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightWhiteColor),
                                color: _currentDate == index ? MobiKulTheme.accentColor :
                                null
                            ),
                            child: Text(dates[index], style: TextStyle(
                                color: _currentDate == index ? Theme.of(context).scaffoldBackgroundColor :
                                null
                            )),
                          ),
                        );
                      }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            _selectedDate(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightWhiteColor)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(fromDateController.text.isNotEmpty ? fromDateController.text
                                    : StringConstants.fromDate.localized(),
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.hintMessageColor
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            _selectedDate(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightWhiteColor)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(toDateController.text.isNotEmpty ? toDateController.text
                                    : StringConstants.toDate.localized(),
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.hintMessageColor
                                    )),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  titleName(StringConstants.status.localized(), context),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: DropdownButtonFormField(
                        iconEnabledColor: Colors.grey[600],
                        style: Theme.of(context).textTheme.bodyMedium,
                        items: status.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _currentStatus = status.indexOf(value!);
                          });
                        },
                        value: status[_currentStatus],
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                            borderSide: BorderSide(color: AppColors.lightWhiteColor),
                          ),
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          fillColor: Colors.black,
                          hintText: StringConstants.select.localized(),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                              borderSide:
                              BorderSide(color: AppColors.lightWhiteColor)),
                        )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: (){
                    DownloadableFiltersInput appliedFilters = DownloadableFiltersInput(
                        status: status[_currentStatus],
                        title: titleController.text, orderDateTo: toDate, orderDateFrom: fromDate,
                        orderId: orderIdController.text, selectedDateIndex: _currentDate
                    );
                    Navigator.of(context).pop(appliedFilters);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        color: MobiKulTheme.accentColor
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      StringConstants.applyFilters.localized(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                        StringConstants.clear.localized()
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget titleName(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(title, style: Theme.of(context).textTheme.labelMedium),
    );
  }

  Future<void> _selectedDate(bool isFromDate) async {
    DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              colorScheme: const ColorScheme.light(
                  primary: MobiKulTheme.accentColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                  secondary: Colors.black),
              dialogBackgroundColor: Colors.white,
            ),
            child: child ?? const Text(""),
          );
        },
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 0)),
        firstDate: DateTime(1950 - 01 - 01),
        lastDate: DateTime(9999 - 01 - 01)
    );

    DateTime date = DateTime.parse(picked.toString());

    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    if (picked != null) {
      setState(() {
        if(isFromDate){
          fromDateController.text = formattedDate.toString();
          fromDate = fromDateController.text;
        }
        else {
          toDateController.text = formattedDate.toString();
          toDate = toDateController.text;
        }
      });
    }
  }

  void setSelectedDate(int index) {
    String formattedDateFrom;
    String formattedDateTo;
    var dateFormatter = DateFormat('yyyy-MM-dd');
    DateTime now = DateTime.now();

    switch(index){
      case 0 :
        formattedDateFrom = dateFormatter.format(now);
        formattedDateTo = formattedDateFrom;
        break;
      case 1 :
        formattedDateFrom = dateFormatter.format(now.add(const Duration(days: -1)));
        formattedDateTo = formattedDateFrom;
        break;
      case 2 :
        var startDay = dateFormatter.format(now.subtract(Duration(days: now.weekday - 1)));
        var endDay = dateFormatter.format(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
        formattedDateFrom = startDay;
        formattedDateTo = endDay;
        break;
      case 3 :
        DateTime firstDayOfLastMonth = DateTime(now.year, now.month, 1);
        DateTime lastDayOfLastMonth = DateTime(now.year, now.month + 1, 0);
        formattedDateFrom = dateFormatter.format(firstDayOfLastMonth);
        formattedDateTo = dateFormatter.format(lastDayOfLastMonth);
        break;
      case 4 :
        DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
        DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        formattedDateFrom = dateFormatter.format(firstDayOfLastMonth);
        formattedDateTo = dateFormatter.format(lastDayOfLastMonth);
        break;
      case 5 :
        DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 3, 1);
        DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        formattedDateFrom = dateFormatter.format(firstDayOfLastMonth);
        formattedDateTo = dateFormatter.format(lastDayOfLastMonth);
        break;
      case 6 :
        DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 6, 1);
        DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        formattedDateFrom = dateFormatter.format(firstDayOfLastMonth);
        formattedDateTo = dateFormatter.format(lastDayOfLastMonth);
        break;
      case 7 :
        DateTime firstDayOfLastMonth = DateTime(now.year, 1, 1);
        DateTime lastDayOfLastMonth = DateTime(now.year, 12, 31);
        formattedDateFrom = dateFormatter.format(firstDayOfLastMonth);
        formattedDateTo = dateFormatter.format(lastDayOfLastMonth);
        break;

      default :
        formattedDateFrom = "";
        formattedDateTo = "";
    }
    fromDate = formattedDateFrom;
    toDate = formattedDateTo;
  }

}
