import 'package:be_elite/models/Session/post_session_dto/session_card_dto/session_card_dto.dart';
import 'pageable.dart';
import 'sort.dart';

class SessionCardDtoPage {
	List<SessionCardDto>? sessionCardDto;
	Pageable? pageable;
	bool? last;
	int? totalPages;
	int? totalElements;
	bool? first;
	int? numberOfElements;
	int? size;
	int? number;
	Sort? sort;
	bool? empty;

	SessionCardDtoPage({
		this.sessionCardDto, 
		this.pageable, 
		this.last, 
		this.totalPages, 
		this.totalElements, 
		this.first, 
		this.numberOfElements, 
		this.size, 
		this.number, 
		this.sort, 
		this.empty, 
	});

	factory SessionCardDtoPage.fromJson(Map<String, dynamic> json) {
		return SessionCardDtoPage(
			sessionCardDto: (json['content'] as List<dynamic>?)
						?.map((e) => SessionCardDto.fromJson(e as Map<String, dynamic>))
						.toList(),
			pageable: json['pageable'] == null
						? null
						: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
			last: json['last'] as bool?,
			totalPages: json['totalPages'] as int?,
			totalElements: json['totalElements'] as int?,
			first: json['first'] as bool?,
			numberOfElements: json['numberOfElements'] as int?,
			size: json['size'] as int?,
			number: json['number'] as int?,
			sort: json['sort'] == null
						? null
						: Sort.fromJson(json['sort'] as Map<String, dynamic>),
			empty: json['empty'] as bool?,
		);
	}



	Map<String, dynamic> toJson() => {
				'content': sessionCardDto?.map((e) => e.toJson()).toList(),
				'pageable': pageable?.toJson(),
				'last': last,
				'totalPages': totalPages,
				'totalElements': totalElements,
				'first': first,
				'numberOfElements': numberOfElements,
				'size': size,
				'number': number,
				'sort': sort?.toJson(),
				'empty': empty,
			};
}
