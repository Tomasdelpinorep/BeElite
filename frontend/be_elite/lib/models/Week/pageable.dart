import 'sort.dart';

class Pageable {
	int? pageNumber;
	int? pageSize;
	Sort? sort;
	int? offset;
	bool? paged;
	bool? unpaged;

	Pageable({
		this.pageNumber, 
		this.pageSize, 
		this.sort, 
		this.offset, 
		this.paged, 
		this.unpaged, 
	});

	factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
				pageNumber: json['pageNumber'] as int?,
				pageSize: json['pageSize'] as int?,
				sort: json['sort'] == null
						? null
						: Sort.fromJson(json['sort'] as Map<String, dynamic>),
				offset: json['offset'] as int?,
				paged: json['paged'] as bool?,
				unpaged: json['unpaged'] as bool?,
			);

	Map<String, dynamic> toJson() => {
				'pageNumber': pageNumber,
				'pageSize': pageSize,
				'sort': sort?.toJson(),
				'offset': offset,
				'paged': paged,
				'unpaged': unpaged,
			};
}
