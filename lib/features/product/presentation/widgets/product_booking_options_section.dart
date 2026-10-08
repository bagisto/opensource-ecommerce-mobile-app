import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';

class ProductBookingOptionsSection extends StatelessWidget {
  final ProductModel product;

  const ProductBookingOptionsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final booking = product.bookingProducts.isNotEmpty
        ? product.bookingProducts.first
        : null;
    if (booking == null) return const SizedBox.shrink();

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      buildWhen: (previous, current) =>
          previous.bookingForm != current.bookingForm ||
          previous.bookingTicketQuantities != current.bookingTicketQuantities ||
          previous.bookingSlots != current.bookingSlots ||
          previous.isBookingSlotsLoading != current.isBookingSlotsLoading ||
          previous.bookingSlotsError != current.bookingSlotsError,
      builder: (context, state) {
        final form = state.bookingForm;
        final type = (booking.type ?? '').toLowerCase().trim();
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(context)!;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking.allowCancellation == false) ...[
                _buildEventMetaRow(
                  context: context,
                  icon: Icons.event_busy_outlined,
                  label: l10n.productBookingCancellation,
                  value: l10n.productBookingCancellationNotAllowed,
                ),
                const SizedBox(height: 22),
              ],
              if (type == 'event') ...[
                _buildEventOverview(context, booking),
                const SizedBox(height: 24),
                _buildEventTickets(
                  context,
                  booking,
                  state.bookingTicketQuantities,
                ),
              ] else if (type == 'table') ...[
                _buildTableOverview(context, booking),
                const SizedBox(height: 28),
                _buildSectionHeading(context, l10n.productBookingBookTable),
                const SizedBox(height: 14),
                _buildBookingFieldLabel(
                  context,
                  l10n.productBookingSelectDateRequired,
                ),
                const SizedBox(height: 10),
                _buildDateField(
                  context,
                  booking: booking,
                  label: l10n.productBookingDateFormatHint,
                  value: form['date'],
                  onChanged: (v) {
                    context.read<ProductDetailBloc>().add(
                      UpdateBookingField(key: 'date', value: v),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildBookingFieldLabel(
                  context,
                  l10n.productBookingSelectSlotRequired,
                ),
                const SizedBox(height: 10),
                _buildSlotField(context, booking, state),
                const SizedBox(height: 26),
                _buildSectionHeading(
                  context,
                  l10n.productBookingSpecialRequestNotesRequired,
                ),
                const SizedBox(height: 14),
                _buildTableNotesField(context, form['note']?.toString() ?? ''),
              ] else if (type == 'appointment') ...[
                _buildAppointmentOverview(context, booking),
                const SizedBox(height: 28),
                _buildSectionHeading(
                  context,
                  l10n.productBookingBookAppointment,
                ),
                const SizedBox(height: 14),
                _buildBookingFieldLabel(
                  context,
                  l10n.productBookingSelectDateRequired,
                ),
                const SizedBox(height: 10),
                _buildDateField(
                  context,
                  booking: booking,
                  label: l10n.productBookingDateFormatHint,
                  value: form['date'],
                  onChanged: (v) {
                    context.read<ProductDetailBloc>().add(
                      UpdateBookingField(key: 'date', value: v),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildBookingFieldLabel(
                  context,
                  l10n.productBookingSelectSlotRequired,
                ),
                const SizedBox(height: 10),
                _buildSlotField(context, booking, state),
              ] else if (type == 'rental') ...[
                _buildRentalOverview(context, booking),
                const SizedBox(height: 24),
                _buildRentalTypeSelector(context, booking, form),
                const SizedBox(height: 24),
                if ((form['rentingType']?.toString().toLowerCase() ?? 'daily') ==
                    'daily') ...[
                  _buildSectionHeading(
                    context,
                    l10n.productBookingSelectDateRequired,
                  ),
                  const SizedBox(height: 14),
                  _buildBookingFieldLabel(context, l10n.productBookingFrom),
                  const SizedBox(height: 10),
                  _buildDateField(
                    context,
                    booking: booking,
                    label: l10n.productBookingFrom,
                    value: form['dateFrom'],
                    onChanged: (v) {
                      context.read<ProductDetailBloc>().add(
                        UpdateBookingField(key: 'dateFrom', value: v),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildBookingFieldLabel(context, l10n.productBookingTo),
                  const SizedBox(height: 10),
                  _buildDateField(
                    context,
                    booking: booking,
                    label: l10n.productBookingTo,
                    value: form['dateTo'],
                    minimumDateOverride: _parseDateOnly(form['dateFrom']),
                    onChanged: (v) {
                      context.read<ProductDetailBloc>().add(
                        UpdateBookingField(key: 'dateTo', value: v),
                      );
                    },
                  ),
                ] else ...[
                  _buildBookingFieldLabel(
                    context,
                    l10n.productBookingSelectDateRequired,
                  ),
                  const SizedBox(height: 14),
                  _buildDateField(
                    context,
                    booking: booking,
                    label: l10n.productBookingSelectDate,
                    value: form['date'],
                    onChanged: (v) {
                      context.read<ProductDetailBloc>().add(
                        UpdateBookingField(key: 'date', value: v),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildBookingFieldLabel(
                    context,
                    l10n.productBookingSelectSlotRequired,
                  ),
                  const SizedBox(height: 10),
                  _buildSlotField(context, booking, state),
                ],
              ] else ...[
              if ((booking.location ?? '').trim().isNotEmpty) ...[
                _buildEventMetaRow(
                  context: context,
                  icon: Icons.location_on_outlined,
                  label: l10n.productBookingLocation,
                  value: booking.location!.trim(),
                  actionLabel: l10n.productBookingViewOnMap,
                  onTap: () => _openMap(booking.location!.trim()),
                ),
                const SizedBox(height: 12),
              ],
              if (booking.activeSlot?.duration != null) ...[
                _label(context, l10n.productBookingSlotDuration),
                const SizedBox(height: 6),
                Text(
                  l10n.productBookingDurationMinutes(
                    booking.activeSlot!.duration!,
                  ),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral700,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (type == 'rental') ...[
                _buildRentalTypeSelector(context, booking, form),
                const SizedBox(height: 12),
              ],
              if (type == 'rental' &&
                  (form['rentingType']?.toString().toLowerCase() ?? 'daily') ==
                      'daily') ...[
                _buildDateField(
                  context,
                  booking: booking,
                  label: l10n.productBookingStartDate,
                  value: form['dateFrom'],
                  onChanged: (v) {
                    context.read<ProductDetailBloc>().add(
                      UpdateBookingField(key: 'dateFrom', value: v),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildDateField(
                  context,
                  booking: booking,
                  label: l10n.productBookingEndDate,
                  value: form['dateTo'],
                  minimumDateOverride: _parseDateOnly(form['dateFrom']),
                  onChanged: (v) {
                    context.read<ProductDetailBloc>().add(
                      UpdateBookingField(key: 'dateTo', value: v),
                    );
                  },
                ),
              ] else if (type != 'event') ...[
                _buildDateField(
                  context,
                  booking: booking,
                  label: l10n.productBookingDate,
                  value: form['date'],
                  onChanged: (v) {
                    context.read<ProductDetailBloc>().add(
                      UpdateBookingField(key: 'date', value: v),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildSlotField(context, booking, state),
              ],
              if (type == 'table') ...[
                const SizedBox(height: 10),
                _buildNoteField(context, form['note']?.toString() ?? ''),
              ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventOverview(BuildContext context, BookingProductData booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasLocation = (booking.location ?? '').trim().isNotEmpty;
    final eventDate = _formatEventDateRange(booking);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLocation) ...[
          _buildEventMetaRow(
            context: context,
            icon: Icons.location_on_outlined,
            label: l10n.productBookingLocation,
            value: booking.location!.trim(),
            actionLabel: l10n.productBookingViewOnMap,
            onTap: () => _openMap(booking.location!.trim()),
          ),
          const SizedBox(height: 22),
        ],
        if (eventDate != null)
          _buildEventMetaRow(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: l10n.productBookingEventOn,
            value: eventDate,
            iconTopPadding: 2,
          ),
        if (eventDate != null) const SizedBox(height: 28),
        Text(
          l10n.productBookingBookYourTicket,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.neutral100 : AppColors.neutral900,
          ),
        ),
      ],
    );
  }

  Widget _buildRentalOverview(BuildContext context, BookingProductData booking) {
    final hasLocation = (booking.location ?? '').trim().isNotEmpty;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLocation)
          _buildEventMetaRow(
            context: context,
            icon: Icons.location_on_outlined,
            label: l10n.productBookingLocation,
            value: booking.location!.trim(),
            actionLabel: l10n.productBookingViewOnMap,
            onTap: () => _openMap(booking.location!.trim()),
          ),
      ],
    );
  }

  Widget _buildAppointmentOverview(
    BuildContext context,
    BookingProductData booking,
  ) {
    final hasLocation = (booking.location ?? '').trim().isNotEmpty;
    final slotDuration = booking.activeSlot?.duration;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLocation) ...[
          _buildEventMetaRow(
            context: context,
            icon: Icons.location_on_outlined,
            label: l10n.productBookingLocation,
            value: booking.location!.trim(),
            actionLabel: l10n.productBookingViewOnMap,
            onTap: () => _openMap(booking.location!.trim()),
          ),
          const SizedBox(height: 22),
        ],
        if (slotDuration != null) ...[
          _buildEventMetaRow(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: l10n.productBookingSlotDurationLabel,
            value: l10n.productBookingDurationMinutes(slotDuration),
            iconTopPadding: 2,
          ),
          const SizedBox(height: 22),
        ],
      ],
    );
  }

  Widget _buildTableOverview(BuildContext context, BookingProductData booking) {
    final hasLocation = (booking.location ?? '').trim().isNotEmpty;
    final slotDuration = booking.activeSlot?.duration;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLocation) ...[
          _buildEventMetaRow(
            context: context,
            icon: Icons.location_on_outlined,
            label: l10n.productBookingLocation,
            value: booking.location!.trim(),
            actionLabel: l10n.productBookingViewOnMap,
            onTap: () => _openMap(booking.location!.trim()),
          ),
          const SizedBox(height: 22),
        ],
        if (slotDuration != null) ...[
          _buildEventMetaRow(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: l10n.productBookingSlotDurationLabel,
            value: l10n.productBookingDurationMinutes(slotDuration),
            iconTopPadding: 2,
          ),
          const SizedBox(height: 22),
        ],
      ],
    );
  }

  Widget _buildEventMetaRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    String? actionLabel,
    IconData? trailingIcon,
    VoidCallback? onTap,
    double iconTopPadding = 0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: iconTopPadding),
          child: Icon(
            icon,
            size: 28,
            color: isDark ? AppColors.neutral100 : AppColors.black,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.neutral200
                      : AppColors.neutral600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: isDark
                      ? AppColors.neutral100
                      : AppColors.neutral900,
                ),
              ),
              if (actionLabel != null && onTap != null) ...[
                const SizedBox(height: 14),
                InkWell(
                  onTap: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.process600,
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          trailingIcon,
                          size: 24,
                          color: AppColors.process600,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingFieldLabel(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.neutral200 : AppColors.neutral800,
      ),
    );
  }

  Widget _buildTableNotesField(BuildContext context, String initialValue) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      initialValue: initialValue,
      maxLines: 4,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.neutral100 : AppColors.neutral900,
      ),
      decoration: InputDecoration(
        hintText: l10n.productBookingSpecialRequestNotesHint,
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary500),
        ),
      ),
      onChanged: (value) {
        context.read<ProductDetailBloc>().add(
          UpdateBookingField(key: 'note', value: value),
        );
      },
    );
  }

  Widget _buildRentalTypeSelector(
    BuildContext context,
    BookingProductData booking,
    Map<String, dynamic> form,
  ) {
    final rentalType = (booking.rentalSlot?.rentingType ?? '').toLowerCase();
    final l10n = AppLocalizations.of(context)!;
    final options = rentalType == 'daily_hourly'
        ? const ['daily', 'hourly']
        : <String>[rentalType == 'hourly' ? 'hourly' : 'daily'];
    final selected =
        (form['rentingType']?.toString().toLowerCase() ?? options.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(context, l10n.productBookingChooseRentOption),
        const SizedBox(height: 16),
        Wrap(
          spacing: 28,
          runSpacing: 14,
          children: options.map((option) {
            final isSelected = option == selected;
            return InkWell(
              onTap: () {
                context.read<ProductDetailBloc>().add(
                  UpdateBookingField(key: 'rentingType', value: option),
                );
              },
              borderRadius: BorderRadius.circular(999),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RentalOptionIndicator(isSelected: isSelected),
                  const SizedBox(width: 12),
                  Text(
                    option == 'daily'
                        ? l10n.productBookingDailyBasis
                        : l10n.productBookingHourlyBasis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.neutral200
                          : AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// First day in [bounds] that has booking slots, or null if none.
  DateTime? _firstBookableDate(
    BookingProductData booking,
    _BookingDateBounds bounds,
  ) {
    for (var day = bounds.firstDate;
        !day.isAfter(bounds.lastDate);
        day = DateTime(day.year, day.month, day.day + 1)) {
      if (booking.isBookableOn(day)) return day;
    }
    return null;
  }

  Widget _buildDateField(
    BuildContext context,
    {required BookingProductData booking,
    required String label,
    dynamic value,
    DateTime? minimumDateOverride,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final dateBounds = _resolveDateBounds(
          booking,
          minimumDateOverride: minimumDateOverride,
        );
        if (dateBounds == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.productBookingNoDatesAvailable),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        final selectedDate = _parseDateOnly(value?.toString());
        final initialDate = selectedDate != null &&
                !selectedDate.isBefore(dateBounds.firstDate) &&
                !selectedDate.isAfter(dateBounds.lastDate) &&
                booking.isBookableOn(selectedDate)
            ? selectedDate
            : _firstBookableDate(booking, dateBounds);
        if (initialDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.productBookingNoDatesAvailable),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        final picked = await showDatePicker(
          context: context,
          firstDate: dateBounds.firstDate,
          lastDate: dateBounds.lastDate,
          initialDate: initialDate,
          // Days without booking slots are greyed out, like the web.
          selectableDayPredicate: booking.isBookableOn,
        );
        if (picked == null) return;
        final formatted =
            '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        onChanged(formatted);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value?.toString().isNotEmpty == true ? value.toString() : label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: value?.toString().isNotEmpty == true
                      ? (isDark ? AppColors.neutral100 : AppColors.neutral900)
                      : AppColors.neutral400,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 24,
              color: isDark ? AppColors.neutral400 : AppColors.neutral400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotField(
    BuildContext context,
    BookingProductData booking,
    ProductDetailState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final form = state.bookingForm;
    final type = (booking.type ?? '').toLowerCase().trim();
    final rentingType = form['rentingType']?.toString().toLowerCase().trim();
    final usesDynamicSlots =
        type == 'default' ||
        type == 'appointment' ||
        type == 'table' ||
        (type == 'rental' && rentingType == 'hourly');
    final options = usesDynamicSlots
        ? state.bookingSlots.map((slot) => slot.label).toList()
        : (booking.activeSlot?.slotRanges() ?? const <String>[]);
    final selected = form['slot']?.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasDate = form['date']?.toString().trim().isNotEmpty == true;
    final isLoading = usesDynamicSlots && state.isBookingSlotsLoading;
    final isEnabled = !isLoading && options.isNotEmpty;

    String hintText = l10n.productBookingSelectSlot;
    String? helperText;
    Color helperColor = AppColors.neutral400;
    if (usesDynamicSlots && !hasDate) {
      hintText = l10n.productBookingSelectDateFirst;
      helperText = l10n.productBookingChooseDateFirstToSeeSlots;
    } else if (isLoading) {
      hintText = l10n.productBookingLoadingSlots;
      helperText = l10n.productBookingSlotsLoadingForSelectedDate;
    } else if (usesDynamicSlots &&
        state.bookingSlotsError != null &&
        state.bookingSlotsError!.trim().isNotEmpty) {
      hintText = l10n.productBookingUnableToLoadSlots;
      helperText = state.bookingSlotsError!.trim();
      helperColor = AppColors.primary600;
    } else if (usesDynamicSlots && hasDate && options.isEmpty) {
      hintText = l10n.productBookingNoSlotsAvailable;
      helperText = l10n.productBookingNoSlotsAvailableForSelectedDate;
      helperColor = AppColors.primary600;
    } else if (hasDate && !isLoading && options.isNotEmpty && selected == null) {
      helperText = l10n.productBookingSelectOneSlotToContinue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: isEnabled && options.contains(selected) ? selected : null,
              isExpanded: true,
              onChanged: !isEnabled
                  ? null
                  : (value) {
                      context.read<ProductDetailBloc>().add(
                        UpdateBookingField(key: 'slot', value: value),
                      );
                    },
              hint: Text(
                hintText,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutral400,
                ),
              ),
              items: options
                  .map(
                    (slot) => DropdownMenuItem<String>(
                      value: slot,
                      child: Text(
                        slot,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 28,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: helperColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNoteField(BuildContext context, String initialValue) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      initialValue: initialValue,
      maxLines: 3,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: isDark ? AppColors.neutral100 : AppColors.neutral900,
      ),
      decoration: InputDecoration(
        hintText: l10n.productBookingSpecialRequestNotesLowercase,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (value) {
        context.read<ProductDetailBloc>().add(
          UpdateBookingField(key: 'note', value: value),
        );
      },
    );
  }

  Widget _buildEventTickets(
    BuildContext context,
    BookingProductData booking,
    Map<String, int> selectedQuantities,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...booking.eventTickets.asMap().entries.map((entry) {
          final index = entry.key;
          final ticket = entry.value;
          final qty = selectedQuantities[ticket.id] ?? 0;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              border: index == booking.eventTickets.length - 1
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AppColors.neutral700
                            : AppColors.neutral300,
                      ),
                    ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.name ?? 'Ticket',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.neutral100
                                : AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (ticket.price != null &&
                            ticket.specialPrice != null &&
                            ticket.price! > ticket.specialPrice!)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              ticket.originalPriceLabel ?? '',
                              style: AppTextStyles.originalPriceText(context)
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        Text(
                          '${ticket.displayPriceLabel} Per Ticket',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral600,
                          ),
                        ),
                        if ((ticket.description ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            ticket.description!.trim(),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: isDark
                                  ? AppColors.neutral200
                                  : AppColors.neutral900,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                _EventTicketStepper(
                  quantity: qty,
                  onDecrease: qty > 0
                      ? () {
                          context.read<ProductDetailBloc>().add(
                            UpdateBookingTicketQuantity(
                              ticketId: ticket.id,
                              quantity: qty - 1,
                            ),
                          );
                        }
                      : null,
                  // Never request more tickets than the event offers.
                  onIncrease: ticket.qty > 0 && qty >= ticket.qty
                      ? null
                      : () {
                          context.read<ProductDetailBloc>().add(
                            UpdateBookingTicketQuantity(
                              ticketId: ticket.id,
                              quantity: qty + 1,
                            ),
                          );
                        },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String? _formatEventDateRange(BookingProductData booking) {
    final from = _formatEventDateTime(booking.availableFrom);
    final to = _formatEventDateTime(booking.availableTo);
    if (from == null && to == null) {
      return null;
    }
    if (from != null && to != null) {
      return '$from - $to';
    }
    return from ?? to;
  }

  String? _formatEventDateTime(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;

    DateTime? parsed = DateTime.tryParse(value);
    parsed ??= DateFormat('yyyy-MM-dd HH:mm:ss').tryParse(value);
    parsed ??= DateFormat('yyyy-MM-dd hh:mm a').tryParse(value);

    if (parsed == null) return value;

    return DateFormat('d MMMM, yyyy hh:mm a').format(parsed);
  }

  DateTime? _tryParseDateTime(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;

    DateTime? parsed = DateTime.tryParse(value);
    parsed ??= DateFormat('yyyy-MM-dd HH:mm:ss').tryParse(value);
    parsed ??= DateFormat('yyyy-MM-dd hh:mm a').tryParse(value);
    return parsed;
  }

  DateTime? _parseDateOnly(String? raw) {
    final parsed = _tryParseDateTime(raw);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  _BookingDateBounds? _resolveDateBounds(
    BookingProductData booking, {
    DateTime? minimumDateOverride,
  }) {
    final today = _dateOnly(DateTime.now());
    final availableFrom = _parseDateOnly(booking.availableFrom);
    final availableTo = _parseDateOnly(booking.availableTo);

    var firstDate = availableFrom != null && availableFrom.isAfter(today)
        ? availableFrom
        : today;

    if (minimumDateOverride != null && minimumDateOverride.isAfter(firstDate)) {
      firstDate = minimumDateOverride;
    }

    final fallbackLastDate = DateTime(today.year + 10, today.month, today.day);
    final lastDate = availableTo ?? fallbackLastDate;

    if (lastDate.isBefore(firstDate)) {
      return null;
    }

    return _BookingDateBounds(firstDate: firstDate, lastDate: lastDate);
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  Future<void> _openMap(String location) async {
    final encodedLocation = Uri.encodeComponent(location);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedLocation',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSectionHeading(BuildContext context, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      value,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.neutral100 : AppColors.black,
      ),
    );
  }

  Widget _label(BuildContext context, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      value,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.neutral200 : AppColors.neutral900,
      ),
    );
  }
}

class _BookingDateBounds {
  final DateTime firstDate;
  final DateTime lastDate;

  const _BookingDateBounds({
    required this.firstDate,
    required this.lastDate,
  });
}

class _EventTicketStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const _EventTicketStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _RentalOptionIndicator extends StatelessWidget {
  final bool isSelected;

  const _RentalOptionIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF121A5A),
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isSelected ? 14 : 0,
          height: isSelected ? 14 : 0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF121A5A),
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(
          icon,
          size: 22,
          color: enabled
              ? (isDark ? AppColors.neutral100 : AppColors.neutral900)
              : (isDark ? AppColors.neutral600 : AppColors.neutral400),
        ),
      ),
    );
  }
}
