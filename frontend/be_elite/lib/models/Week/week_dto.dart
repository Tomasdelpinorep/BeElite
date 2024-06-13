import 'content.dart';
import 'pageable.dart';
import 'sort.dart';

class WeekDto {
  List<WeekContent>? content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  bool? first;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? empty;

  WeekDto({
    this.content,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.first,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.empty,
  });

  factory WeekDto.fromJson(Map<String, dynamic> json) => WeekDto(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) => WeekContent.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        last: json['last'] as bool?,
        totalElements: json['totalElements'] as int?,
        totalPages: json['totalPages'] as int?,
        first: json['first'] as bool?,
        size: json['size'] as int?,
        number: json['number'] as int?,
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        numberOfElements: json['numberOfElements'] as int?,
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'last': last,
        'totalElements': totalElements,
        'totalPages': totalPages,
        'first': first,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'numberOfElements': numberOfElements,
        'empty': empty,
      };
}
