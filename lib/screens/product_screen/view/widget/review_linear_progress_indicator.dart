/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

class ReviewLinearProgressIndicator extends StatelessWidget {
 final dynamic percentage;
  const ReviewLinearProgressIndicator({Key? key, this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ((percentage ?? []).isNotEmpty)
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '5Star'.localized(),
                          style:  TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary,),
                          value: (percentage[0] / 100 ?? 0).toDouble(),
                        )),
                        if ((percentage ?? []).isNotEmpty)
                          SizedBox(
                            width: percentage[0] > 0 ? 8 : 18,
                          ),
                        Text(
                          '(${percentage[0].toString()}%)',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '4Star'.localized(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor:  AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,),
                                value: (percentage[1] / 100 ?? 0 / 100)
                                    .toDouble())),
                        SizedBox(
                          width: percentage[1] > 0 ? 8 : 18,
                        ),
                        Text(
                          '(${percentage[1] ?? 0}%)',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '3Star'.localized(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary,),
                          value: (percentage[2] / 100 ?? 0 / 100).toDouble(),
                        )),
                        SizedBox(
                          width: percentage[2] > 0 ? 8 : 18,
                        ),
                        Text(
                          '(${percentage[2] ?? 0}%)',
                          style:  TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '2Star'.localized(),
                          style:  TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary,),
                          value: (percentage[3] / 100 ?? 0 / 100).toDouble(),
                        )),
                        SizedBox(
                          width: percentage[3] > 0 ? 8 : 18,
                        ),
                        Text('(${percentage[3] ?? 0}%)',
                            style:  TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '1Star'.localized(),
                          style:  TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor:  AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,),
                                value: (percentage[4] / 100 ?? 0 / 100)
                                    .toDouble())),
                        SizedBox(
                          width: percentage[4] > 0 ? 8 : 18,
                        ),
                        Text(
                          '(${percentage[4] ?? 0}%)',
                          style:  TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ]))
          : const SizedBox(),
    );
  }
}
