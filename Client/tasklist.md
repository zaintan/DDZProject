####tasklist
#####基础框架
- mvc搭建
- 网络库,消息机制封装  --振宇
- 弹窗管理 层级管理
- 客户端本地数据固化
- ui封装，希望提供更多的接口，比如setText,setVisible等
- 定时器Timer.lua(已有)
- 事件EventProtocol.lua（已有）
- 状态机StateMachine.lua（已有）

#####功能
1. 登录----游客+微信
2. 创建\加入房间
3. 玩牌

#####界面
- 大厅+房间
- 二级界面: 登录+创建+加入

#####玩牌逻辑划分:
- Player---------------纯玩家信息维护
- RoomPlayer-----------房间内的玩家状态维护
- RoomController-------房间内逻辑管理
- RoomScene------------房间内界面状态维护 (RoomController拥有RoomScene的引用,roomScene只能通过消息机制通知controller信息)

- Poke---------------------单张牌 type,value--黑红梅方块
- PokeGroup----------------牌组 牌型定义--单张,顺子,对子,连队....... 
- PlayerPokes--------------管理单个玩家的牌(也可细分手牌 弃牌)  有提示出牌的接口
- PokeFactory--------------





