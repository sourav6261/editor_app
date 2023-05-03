import 'package:dio/dio.dart';
import 'package:edt/core/network/client_utils.dart';
import 'package:edt/module/home/model/collection/collection_model.dart';

import '../model/photo/photo_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final Dio client;

  HomeRepositoryImpl({required this.client});

  @override
  Future<List<CollectionItemModel>> getCollections(int perPage) async {
    try {
      final result = await client.get("/collections/featured",
          options: ClientUtils.pexelAuth,
          queryParameters: {
            "per_page": perPage,
          });

      if (result.statusCode == 200) {
        final resultFromJson = CollectionModel.fromJson(result.data);
        return resultFromJson.collections;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PhotoItemModel>> getPhotos(int page, int perPage) async {
    try {
      final result = await client.get(
        "/curated",
        options: ClientUtils.pexelAuth,
        queryParameters: {
          "page": page,
          "per_page": perPage,
        },
      );

      if (result.statusCode == 200) {
        final resultFromJson = PhotoModel.fromJson(result.data);
        return resultFromJson.photos;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
