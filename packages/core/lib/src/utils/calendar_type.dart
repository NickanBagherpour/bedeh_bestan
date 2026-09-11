/// Which calendar system to use for display / pickers.
///
/// BedeBestan is Jalali-primary; Gregorian is an optional helper.
enum CalendarType { jalali, gregorian }

/// User preference for how dates are displayed.
enum CalendarPreference { jalali, gregorian }

/// Resolves [preference] into a concrete [CalendarType].
CalendarType calendarTypeFor(CalendarPreference preference) {
  return switch (preference) {
    CalendarPreference.jalali => CalendarType.jalali,
    CalendarPreference.gregorian => CalendarType.gregorian,
  };
}
