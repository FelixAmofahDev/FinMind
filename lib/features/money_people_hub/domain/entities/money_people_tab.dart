/// The two views available in the Money & People hub.
enum MoneyPeopleTab {
  owesYou('Owes you'),
  youOwe('You owe');

  const MoneyPeopleTab(this.label);

  final String label;
}
