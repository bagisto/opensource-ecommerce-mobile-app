/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */





import 'package:bagisto_app_demo/screens/compare/utils/index.dart';


class CompareScreenBloc
    extends Bloc<CompareScreenBaseEvent, CompareScreenBaseState> {
  CompareScreenRepository? repository;

  CompareScreenBloc(this.repository)
      : super(CompareScreenInitialState()) {
    on<CompareScreenBaseEvent>(mapEventToState);
  }

  void mapEventToState(CompareScreenBaseEvent event,
      Emitter<CompareScreenBaseState> emit) async {
    if (event is CompareScreenFetchEvent) {
      try {
        CompareProductsData? compareScreenModel =
            await repository?.callCompareApi();

        emit(CompareScreenFetchDataState.success(
            compareScreenModel: compareScreenModel));
      } catch (e) {
        emit(CompareScreenFetchDataState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is RemoveFromCompareListEvent) {
      try {
        BaseModel baseModel = await repository!.removeFromCompareList(
          int.parse(event.productId ?? ""),
        );
        if (baseModel.status == true) {
          emit(RemoveFromCompareState.success(
              productDeletedId: event.productId.toString(),
              baseModel: baseModel,
              successMsg: baseModel.message));
        } else {
          emit(RemoveFromCompareState.fail(error: baseModel.graphqlErrors));
        }
      } catch (e) {
        emit(RemoveFromCompareState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToCartCompareEvent) {
      try {
        AddToCartModel? graphQlBaseModel = await repository?.callAddToCartAPi(int.parse(event.productId??""), event.quantity/* event.params*/);
        if (graphQlBaseModel?.success == true) {
          emit(AddToCartCompareState.success(
              response: graphQlBaseModel,
              cartProductId: event.productId,
              successMsg: StringConstants.addToCart.localized()));
        }else {
          emit(AddToCartCompareState.fail(error: graphQlBaseModel?.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartCompareState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToWishlistCompareEvent) {
      try {
        AddWishListModel? addWishListModel =
            await repository!.callWishListAddDeleteItem(event.productId);
        if (event.data?.product?.isInWishlist == true) {
          event.data?.product?.isInWishlist = false;
        } else {
          event.data?.product?.isInWishlist = true;
        }
        emit(AddToWishlistCompareState.success(
            response: addWishListModel,
            productDeletedId: event.productId,
            successMsg: addWishListModel!.message));
      } catch (e) {
        emit(AddToWishlistCompareState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }else if (event is FetchDeleteWishlistItemEvent) {
      try {
        AddToCartModel removeFromWishlist = await repository!.removeItemFromWishlist(event.productId);
        if(removeFromWishlist.status==true) {
          if (event.datum != null) {
            if (event.datum?.product?.isInWishlist == true) {
              event.datum?.product?.isInWishlist= false;
            } else {
              event.datum?.product?.isInWishlist = true;
            }
          } else {
            event.datum?.product?.isInWishlist= !(event.datum?.product?.isInWishlist ?? true);
          }

          emit (RemoveFromWishlistState.success( productDeletedId: event.productId.toString(), successMsg:removeFromWishlist.message,response: removeFromWishlist));
        }
      } catch (e) {
        emit (RemoveFromWishlistState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }

    else if (event is OnClickCompareLoaderEvent) {
      emit(OnClickCompareLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    }else if (event is RemoveAllCompareListEvent) {
      try {
        BaseModel baseModel = await repository!.removeAllCompareProducts();
        if (baseModel.status == true) {
          emit(RemoveAllCompareProductState.success(
              baseModel: baseModel,
              successMsg: baseModel.message));
        } else {
          emit(RemoveAllCompareProductState.fail(error: baseModel.graphqlErrors));
        }
      } catch (e) {
        emit(RemoveAllCompareProductState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }

  }
}
