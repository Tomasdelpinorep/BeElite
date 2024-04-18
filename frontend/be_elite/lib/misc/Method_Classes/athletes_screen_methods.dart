import 'package:be_elite/models/Session/session_card_dto/block_dto.dart';
import 'package:intl/intl.dart';

class AthleteScreenMethods {
  AthleteScreenMethods();

  String getSessionCardTitle(String date) {
    DateTime dateTime = DateTime.parse(date);

    DateFormat formatter = DateFormat('EEEE, MMMM d');

    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  double getNumberOfWorkoutsCompleted(List<Block> blocks){
    double count = 0;
    for(var block in blocks){
      if(block.isCompleted!){
        count++;
      }
    }
    return count;
  }
}
