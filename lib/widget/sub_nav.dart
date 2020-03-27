import 'package:flutter/material.dart';
import 'package:flutterapp/model/common_model.dart';
import 'package:flutterapp/services/log_services.dart';
import 'package:flutterapp/util/navigator_util.dart';
import 'package:flutterapp/widget/webview.dart';

///活动入口
class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //四角圆度半径
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });
    //计算出第一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();
    //竖
    return Column(
      children: <Widget>[
        //横
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(0, separate),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate, subNavList.length),
          ),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    /**
     * Row 的效果是横向排版，把Row 里面的children 控件全部横向排版。可以设置内边距，也可以结合Expanded 填充使用，还可以设置其中的子控件的比例大小.
     */

    return Expanded(
      flex: 1,
      /**
       * GestureDetector({
          Key key,
          this.child,
          this.onTapDown,//可能导致点击的指针已联系到屏幕的特定位置
          this.onTapUp,//触发点的指针已停止在特定位置与屏幕联系
          this.onTap,//发生了点击。
          this.onTapCancel,//触发onTapDown的指针取消触发
          this.onDoubleTap,//双击
          this.onLongPress,//长按
          this.onLongPressUp,//长按结束
          this.onVerticalDragDown,//
          this.onVerticalDragStart,//指针已经接触到屏幕，而且可能开始垂直移动。
          this.onVerticalDragUpdate,//与屏幕接触并垂直移动的指针沿垂直方向移动
          this.onVerticalDragEnd,//以前与屏幕接触并垂直移动的指针不再与屏幕接触，并且当其停止接触屏幕时以特定速度移动。
          this.onVerticalDragCancel,//
          this.onHorizontalDragDown,//
          this.onHorizontalDragStart,//
          this.onHorizontalDragUpdate,//
          this.onHorizontalDragEnd,//
          this.onHorizontalDragCancel,//

          //    onPan可以取代onVerticalDrag或者onHorizontalDrag，三者不能并存
          this.onPanDown,//指针已经接触屏幕并开始移动
          this.onPanStart,//与屏幕接触并移动的指针再次移动
          this.onPanUpdate,//先前与屏幕接触并移动的指针不再与屏幕接触，并且当它停止接触屏幕时以特定速度移动
          this.onPanEnd,//先前触发 onPanDown 的指针未完成
          this.onPanCancel,//

          //    onScale可以取代onVerticalDrag或者onHorizontalDrag，三者不能并存，不能与onPan并存
          this.onScaleStart,//
          this.onScaleUpdate,//
          this.onScaleEnd,//
          this.behavior,
          this.excludeFromSemantics = false
          })
       */
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.push(
              context,
              WebView(
                url: model.url,
                statusBarColor: model.statusBarColor,
                hideAppBar: model.hideAppBar,
              ));
        },
        child: Column(
          children: <Widget>[
            Image.network(
              model.icon,
              width: 18,
              height: 18,
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                model.title,
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
