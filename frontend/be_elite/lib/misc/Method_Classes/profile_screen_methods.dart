class ProfileSreenMethods {
  ProfileSreenMethods();

  int getDaysInProgram(String joinedProgramDate) {
    DateTime now = DateTime.now();

    Duration difference = now.difference(DateTime.parse(joinedProgramDate));

    int daysDifference = difference.inDays;

    return daysDifference;
  }
  
}
