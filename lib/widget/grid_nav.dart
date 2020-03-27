import 'package:flutter/material.dart';
import 'package:flutterapp/model/common_model.dart';
import 'package:flutterapp/model/grid_nav_model.dart';
import 'package:flutterapp/util/navigator_util.dart';
import 'package:flutterapp/widget/webview.dart';

///网格卡片
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * 设置widget四边圆角，可以设置阴影颜色，和z轴高度
     */
    return PhysicalModel(
      //z轴高度
      elevation: 0.0,
      //设置阴影颜色
      color: Colors.transparent,
      //四角圆度半径
      borderRadius: BorderRadius.circular(6),
      //裁剪模式
      clipBehavior: Clip.antiAlias,
      //先竖向布局
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  List<Widget> _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItems = [];
    items.forEach((item) {
      /**
       * Expanded这个控件会把同级别的控件，在父控件中填充满整个父控件。
       * 此组件会填满Row在主轴方向的剩余空间，撑开Row
       */
      expandItems.add(Expanded(child: item, flex: 1));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          //线性渐变
          gradient: LinearGradient(colors: [startColor, endColor])),
      child: Row(children: expandItems),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        /**
         * Stack控件的每一个子控件都是定位或不定位，定位的子控件是被Positioned控件包裹的。
         * Stack控件本身包含所有不定位的子控件，其根据alignment定位（默认为左上角）。
         * 然后根据定位的子控件的top、right、bottom和left属性将它们放置在Stack控件上。
         */
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                model.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        model);
  }

  _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    /**
     * 竖
     */
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, bottomItem, false),
        )
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    /**
     * 底部线
     */
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      //撑满父布局的宽度
      widthFactor: 1,
      child: Container(
        /**
         * 盒子
         */
        decoration: BoxDecoration(
          /**
           * 线
           */
            border: Border(
          left: borderSide,
          bottom: first ? borderSide : BorderSide.none,
        )),
        child: _wrapGesture(
            context,
            Center(
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            item),
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
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
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              title: model.title,
              hideAppBar: model.hideAppBar,
            ));
      },
      child: widget,
    );
  }
}
