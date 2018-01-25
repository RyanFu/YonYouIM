;(function(global){
	callSDK("getJID"); 
	var myScroll,
		pullDownEl, pullDownOffset,
		pullUpEl, pullUpOffset,
		generatedCount = 0;
	var refresh_flag = true;
	function loaded() {
		
		global.spcScroll = new IScroll('#wrapper',{ mouseWheel: true });
	
	var flag;

	}
	document.addEventListener('DOMContentLoaded', loaded, false);
	
	
	
	var space_list_param={
		page:0,
		pageSize:200,
		userId:"_wallspaceJID_"
	};
//	var tem_data = {"mine":[{"id":"55e1affae4b0a371dd3794c8","appId":"udn","ts":1440854010,"etpId":"yonyou","name":"连接大志主机可以修改","type":1,"admins":["litfb.udn.yonyou"],"intro":"asdasdDone","creator":"litfb.udn.yonyou"},{"id":"55e419eae4b02f8c88dd464d","appId":"udn","ts":1441012202,"etpId":"yonyou","name":"五音不全","type":1,"admins":["guoshg.udn.yonyou"],"intro":"","creator":"guoshg.udn.yonyou"},{"id":"55e504f5e4b067f1b054a79d","appId":"udn","ts":1441072373,"etpId":"yonyou","name":"非诚勿扰","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"非诚勿扰","creator":"wangxin0.udn.yonyou"},{"id":"55e6a352e4b0fa7d32070468","appId":"udn","ts":1441178450,"etpId":"yonyou","name":"文本圈","type":1,"admins":["zhangxin0.udn.yonyou"],"intro":"请发文本","creator":"zhangxin0.udn.yonyou"},{"id":"55ed50b4e4b0196b75b50e8f","appId":"udn","ts":1441616052,"etpId":"yonyou","name":"左眼皮跳跳","type":1,"admins":["yangjz0.udn.yonyou"],"intro":"呵呵呵","creator":"yangjz0.udn.yonyou"},{"id":"55ee3a82e4b0bcd206fedab5","appId":"udn","ts":1441675906,"etpId":"yonyou","name":"封闭","type":0,"admins":["rongqb.udn.yonyou"],"intro":"","creator":"rongqb.udn.yonyou"},{"id":"55eea0a0e4b07f6975ea25a9","appId":"udn","ts":1441702048,"etpId":"yonyou","name":"lhclhc","type":0,"admins":["wangxin0"],"intro":"加班好啊！dajiahao a ","creator":"wangxin0"},{"id":"55eea354e4b07f6975ea25ac","appId":"udn","ts":1441702740,"etpId":"yonyou","name":"wangxin111","type":0,"admins":["wangxin0.udn.yonyou"],"intro":"1111","creator":"wangxin0.udn.yonyou"},{"id":"55eea692e4b0e460905a9826","appId":"udn","ts":1441703570,"etpId":"yonyou","name":"jdn","type":0,"admins":["haoba1.udn.yonyou"],"intro":"aaaaaaaaaa","creator":"haoba1.udn.yonyou"},{"id":"55efe2b1e4b07f6975ea26e8","appId":"udn","ts":1441784497,"etpId":"yonyou","name":"123456789","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"wangxin0.udn.yonyou","creator":"wangxin0.udn.yonyou"},{"id":"55f7d904e4b00ede2bd8c813","appId":"udn","ts":1442306308,"etpId":"yonyou","name":"openone","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f7d945e4b00ede2bd8c816","appId":"udn","ts":1442306373,"etpId":"yonyou","name":"needtobeinvited","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f7eedbe4b0686d4e977edd","appId":"udn","ts":1442311899,"etpId":"yonyou","name":"zz","type":0,"admins":["shicz.udn.yonyou"],"intro":"","creator":"shicz.udn.yonyou"},{"id":"55f81197e4b0686d4e977ef9","appId":"udn","ts":1442320791,"etpId":"yonyou","name":"codeape","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f82ff6e4b03cc53825739a","appId":"udn","ts":1442328566,"etpId":"yonyou","name":"what?type?","type":0,"admins":["wangxin0.udn.yonyou"],"intro":"wangxin0.udn.yonyou","creator":"wangxin0.udn.yonyou"},{"id":"55f91844a85b01da686237db","appId":"udn","ts":1442388034,"etpId":"yonyou","name":"fengbi","type":0,"admins":["wangxin0.udn.yonyou"],"intro":"wangxin0.udn.yonyou","creator":"wangxin0.udn.yonyou"},{"id":"55fa7d0be4b03cc5382573de","appId":"udn","ts":1442479371,"etpId":"yonyou","name":"1111111","type":1,"admins":["wangxin0","sYs"],"intro":"","creator":"sYs"},{"id":"55ffb0e7a85b68bbdaf601f1","appId":"udn","ts":1442820327,"etpId":"yonyou","name":"2015-9-21 15:25:26-jingzz-测试","type":1,"admins":["zhangxin0.udn.yonyou"],"intro":"test space","creator":"zhangxin0.udn.yonyou"},{"id":"55ffb1fda85b68bbdaf601f6","appId":"udn","ts":1442820605,"etpId":"yonyou","name":"2015-9-21 15:30:04-jingzz-测试","type":0,"admins":["zhangxin0.udn.yonyou"],"intro":"test space","creator":"zhangxin0.udn.yonyou"},{"id":"5600fe14e4b0033be842c116","appId":"udn","ts":1442905620,"etpId":"yonyou","name":"当山峰没有菱角的时候","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"560102f1e4b03cc5382573e2","appId":"udn","ts":1442906865,"etpId":"yonyou","name":"创建圈子简化页面","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"0","type":1,"ts":0,"intro":"默认好友圈","name":"我的好友圈","creator":"System"}],"other":[{"id":"55dfd052e4b0a371dd379366","appId":"udn","ts":1440731218,"etpId":"yonyou","name":"测试001修改会跳页了！666","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"类型开放——>封闭?再由封闭——>开放","creator":"wangxin0.udn.yonyou"},{"id":"55dfd0afe4b0a371dd379369","appId":"udn","ts":1440731311,"etpId":"yonyou","name":"测试8888888修改888111","state":0,"type":0,"admins":["wangxin0.udn.yonyou"],"intro":"888888888h888","creator":"wangxin0.udn.yonyou"},{"id":"55e660c6e4b0a371dd379834","appId":"udn","ts":1441161414,"etpId":"yonyou","name":"ws_create001","state":0,"type":1,"admins":["liu"],"intro":"欢迎加入！","creator":"liu"},{"id":"55ebed42e4b03f8f5d8466ea","appId":"udn","ts":1441525058,"etpId":"yonyou","name":"spaceTest","state":0,"type":1,"admins":["rongqb.udn.yonyou"],"intro":"test space123456789","creator":"rongqb.udn.yonyou"},{"id":"55eea05de4b07f6975ea25a7","appId":"udn","ts":1441701981,"etpId":"yonyou","name":"lhc","state":0,"type":1,"admins":["wangxin0"],"intro":"gogoggo","creator":"wangxin0"},{"id":"55f15aabe4b07f6975ea2807","appId":"udn","ts":1441880747,"etpId":"yonyou","name":"wangxin0的封闭圈","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"滚滚滚","creator":"wangxin0.udn.yonyou"},{"id":"55f67d1ee4b026378fa74abe","appId":"udn","ts":1442217246,"etpId":"yonyou","name":"111","state":0,"type":0,"admins":["lhc"],"intro":"111","creator":"lhc"},{"id":"55f7eedbe4b0686d4e977edd","appId":"udn","ts":1442311899,"etpId":"yonyou","name":"zz","state":1,"type":0,"admins":["shicz.udn.yonyou"],"intro":"","creator":"shicz.udn.yonyou"},{"id":"55f7ef15e4b0686d4e977ee2","appId":"udn","ts":1442311957,"etpId":"yonyou","name":"dd","state":0,"type":0,"admins":["shicz.udn.yonyou"],"intro":"","creator":"shicz.udn.yonyou"},{"id":"55fa7d0be4b03cc5382573de","appId":"udn","ts":1442479371,"etpId":"yonyou","name":"1111111","state":1,"type":1,"admins":["wangxin0","sYs"],"intro":"","creator":"sYs"},{"id":"55e1affae4b0a371dd3794c8","appId":"udn","ts":1440854010,"etpId":"yonyou","name":"连接大志主机可以修改","state":1,"type":1,"admins":["litfb.udn.yonyou"],"intro":"asdasdDone","creator":"litfb.udn.yonyou"},{"id":"55e419eae4b02f8c88dd464d","appId":"udn","ts":1441012202,"etpId":"yonyou","name":"五音不全","state":1,"type":1,"admins":["guoshg.udn.yonyou"],"intro":"","creator":"guoshg.udn.yonyou"},{"id":"55e5020fe4b067f1b054a797","appId":"udn","ts":1441071631,"etpId":"yonyou","name":"教育局教育局长","state":0,"type":1,"admins":["rongqb.udn.yonyou"],"intro":"","creator":"rongqb.udn.yonyou"},{"id":"55e504f5e4b067f1b054a79d","appId":"udn","ts":1441072373,"etpId":"yonyou","name":"非诚勿扰","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"非诚勿扰","creator":"wangxin0.udn.yonyou"},{"id":"55e50689e4b067f1b054a79f","appId":"udn","ts":1441072777,"etpId":"yonyou","name":"天天","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55e656aee4b0a371dd379821","appId":"udn","ts":1441158830,"etpId":"yonyou","name":"liuhaichao.udn.yonyou","state":0,"type":1,"admins":["liu"],"intro":"hello！！！","creator":"刘海超"},{"id":"55e659afe4b0a371dd379829","appId":"udn","ts":1441159599,"etpId":"yonyou","name":"ws_0002.udn.yonyou就是666","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55e659e0e4b0a371dd37982b","appId":"udn","ts":1441159648,"etpId":"yonyou","name":"ws_0003.udn.yonyou","state":0,"type":1,"admins":["zhangxin0.udn.yonyou"],"intro":"","creator":"zhangxin0.udn.yonyou"},{"id":"55e65c95e4b0a371dd37982f","appId":"udn","ts":1441160341,"etpId":"yonyou","name":"ws_001.udn.yonyou","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"hello","creator":"wangxin0.udn.yonyou"},{"id":"55e66c9de4b0a371dd379840","appId":"udn","ts":1441164445,"etpId":"yonyou","name":"ws_create002","state":0,"type":0,"admins":["liuhaichao"],"intro":"大家好啊！999999","creator":"liuhaichao"},{"id":"55e6a352e4b0fa7d32070468","appId":"udn","ts":1441178450,"etpId":"yonyou","name":"文本圈","state":1,"type":1,"admins":["zhangxin0.udn.yonyou"],"intro":"请发文本","creator":"zhangxin0.udn.yonyou"},{"id":"55e6ff39e4b0a371dd3798aa","appId":"udn","ts":1441201977,"etpId":"yonyou","name":"create_modify_OK","state":0,"type":1,"admins":["wangxin0"],"intro":"","creator":"wangxin0"},{"id":"55e706f8e4b0a371dd3798b1","appId":"udn","ts":1441203960,"etpId":"yonyou","name":"create_modify_two","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"创建并修改的例子","creator":"wangxin0.udn.yonyou"},{"id":"55e70839e4b0a371dd3798b6","appId":"udn","ts":1441204281,"etpId":"yonyou","name":"create_modify_three","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"创建修改测试圈子","creator":"wangxin0.udn.yonyou"},{"id":"55ebd87ae4b0a371dd379c47","appId":"udn","ts":1441519738,"etpId":"yonyou","name":"这名字太长啦啊","state":0,"type":1,"admins":["rongqb.udn.yonyou"],"intro":"测试圈子名称","creator":"rongqb.udn.yonyou"},{"id":"55ebe0dce4b0a371dd379c55","appId":"udn","ts":1441521884,"etpId":"yonyou","name":"大阅兵","state":0,"type":1,"admins":["wangxin0"],"intro":"9.3","creator":"wangxin0"},{"id":"55ec5361e4b0a371dd379cca","appId":"udn","ts":1441551201,"etpId":"yonyou","name":"习大大阅兵","state":0,"type":1,"admins":["wangxin0"],"intro":"给小日本看","creator":"wangxin0"},{"id":"55ecfa98e4b0196b75b5071d","appId":"udn","ts":1441594008,"etpId":"yonyou","name":"闲人勿入","state":0,"type":0,"admins":["wangxin0.udn.yonyou"],"intro":"内有恶犬","creator":"wangxin0.udn.yonyou"},{"id":"55ecf10de4b0a371dd379d45","appId":"udn","ts":1441591565,"etpId":"yonyou","name":"999感冒灵感冒药","state":0,"type":1,"admins":["wangxin0"],"intro":"999666","creator":"wangxin0"},{"id":"55ed4d0be4b0196b75b50e88","appId":"udn","ts":1441615115,"etpId":"yonyou","name":"滴滴答答","state":0,"type":1,"admins":["yangjz0.udn.yonyou"],"intro":"","creator":"yangjz0.udn.yonyou"},{"id":"55ed50b4e4b0196b75b50e8f","appId":"udn","ts":1441616052,"etpId":"yonyou","name":"左眼皮跳跳","state":1,"type":1,"admins":["yangjz0.udn.yonyou"],"intro":"呵呵呵","creator":"yangjz0.udn.yonyou"}]}
//	var data = {
//				space_list:tem_data
//			};
//			var template_invoke = template('spaces',data);
//			$('#allspaces').html(template_invoke);
//			global.spcScroll.refresh();

//	var space_list_param={
//		page:0,
//		pageSize:200,
//		userId:"wangxin0.udn.yonyou",
//		token:"b13289f9-542e-43c8-9ee7-862f83342c1f"
//	};
//	
//	$.ajax({
//		type:"post",
//		url:'http://172.20.8.189:9090/sysadmin/plugins/friends/space/page',
//		dataType:'json',
//		data:JSON.stringify(space_list_param),
//		success:function(res){
//			var data = {
//				space_list:res
//			};
//			var template_invoke = template('spaces',data);
//			$('#allspaces').html(template_invoke);
//			global.spcScroll.refresh();
//		},
//		error:function(res){
//			
//		}
//	}); 
	global.refreshSpaces = function(){
//		window.jid = 'wangxin0.udn.yonyou';
//		var fake_data = {"mine":[{"id":"55e1affae4b0a371dd3794c8","appId":"udn","ts":1440854010,"etpId":"yonyou","name":"连接大志主机可以修改","type":1,"admins":["litfb.udn.yonyou"],"intro":"asdasdDone","creator":"litfb.udn.yonyou"},{"id":"55e419eae4b02f8c88dd464d","appId":"udn","ts":1441012202,"etpId":"yonyou","name":"五音不全","type":1,"admins":["guoshg.udn.yonyou"],"intro":"","creator":"guoshg.udn.yonyou"},{"id":"55e504f5e4b067f1b054a79d","appId":"udn","ts":1441072373,"etpId":"yonyou","name":"非诚勿扰","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"非诚勿扰","creator":"wangxin0.udn.yonyou"},{"id":"55e6a352e4b0fa7d32070468","appId":"udn","ts":1441178450,"etpId":"yonyou","name":"文本圈","type":1,"admins":["zhangxin0.udn.yonyou"],"intro":"请发文本","creator":"zhangxin0.udn.yonyou"},{"id":"55ebed42e4b03f8f5d8466ea","appId":"udn","ts":1441525058,"etpId":"yonyou","name":"spaceTest","type":1,"admins":["rongqb.udn.yonyou"],"intro":"test space123456789","creator":"rongqb.udn.yonyou"},{"id":"55ed50b4e4b0196b75b50e8f","appId":"udn","ts":1441616052,"etpId":"yonyou","name":"左眼皮跳跳","type":1,"admins":["yangjz0.udn.yonyou"],"intro":"呵呵呵","creator":"yangjz0.udn.yonyou"},{"id":"55ee3a82e4b0bcd206fedab5","appId":"udn","ts":1441675906,"etpId":"yonyou","name":"封闭","type":0,"admins":["rongqb.udn.yonyou"],"intro":"","creator":"rongqb.udn.yonyou"},{"id":"55eea692e4b0e460905a9826","appId":"udn","ts":1441703570,"etpId":"yonyou","name":"jdn","type":0,"admins":["haoba1.udn.yonyou"],"intro":"aaaaaaaaaa","creator":"haoba1.udn.yonyou"},{"id":"55efe2b1e4b07f6975ea26e8","appId":"udn","ts":1441784497,"etpId":"yonyou","name":"123456789","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"wangxin0.udn.yonyou","creator":"wangxin0.udn.yonyou"},{"id":"55f7d904e4b00ede2bd8c813","appId":"udn","ts":1442306308,"etpId":"yonyou","name":"openone","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f7d945e4b00ede2bd8c816","appId":"udn","ts":1442306373,"etpId":"yonyou","name":"needtobeinvited","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f7eedbe4b0686d4e977edd","appId":"udn","ts":1442311899,"etpId":"yonyou","name":"zz","type":0,"admins":["shicz.udn.yonyou"],"intro":"","creator":"shicz.udn.yonyou"},{"id":"5600fe14e4b0033be842c116","appId":"udn","ts":1442905620,"etpId":"yonyou","name":"当山峰没有菱角的时候","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"560102f1e4b03cc5382573e2","appId":"udn","ts":1442906865,"etpId":"yonyou","name":"创建圈子简化页面","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"560135f9e4b03cc5382573f5","appId":"udn","ts":1442919929,"etpId":"yonyou","name":"ws002","type":1,"admins":["rongqb.udn.yonyou"],"intro":"","creator":"rongqb.udn.yonyou"},{"id":"560216d8e4b03cc5382573f9","appId":"udn","ts":1442977496,"etpId":"yonyou","name":"create_modify123","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"5602624be4b00d6bb6630fab","appId":"udn","ts":1442996811,"etpId":"yonyou","name":"WS00002","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"5603a5d8e4b0e3280f38d042","appId":"udn","ts":1443079640,"etpId":"yonyou","name":"集成测试修改+搜索成员","type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"0","type":1,"ts":0,"intro":"默认好友圈","name":"我的好友圈","creator":"System"}],"other":[{"id":"55f68507e4b026378fa74ac0","appId":"udn","ts":1442219271,"etpId":"yonyou","name":"123123111","state":0,"type":0,"admins":["litfb.udn.yonyou"],"intro":"","creator":"litfb.udn.yonyou"},{"id":"55efe71de4b07f6975ea26ed","appId":"udn","ts":1441745789,"etpId":"yonyou","name":"12345","state":0,"type":0,"admins":["liuhca.udn.yonyou"],"intro":"测试删除成员","creator":"liuhca.udn.yonyou"},{"id":"55efe2b1e4b07f6975ea26e8","appId":"udn","ts":1441784497,"etpId":"yonyou","name":"123456789","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"wangxin0.udn.yonyou","creator":"wangxin0.udn.yonyou"},{"id":"56010ab1e4b03cc5382573e8","appId":"udn","ts":1442908849,"etpId":"yonyou","name":"123456789000","state":0,"type":0,"admins":["yangjz0.udn.yonyou"],"intro":"","creator":"yangjz0.udn.yonyou"},{"id":"55f913b2e4b03cc5382573b0","appId":"udn","ts":1442386866,"etpId":"yonyou","name":"22222","state":0,"type":1,"admins":["litfb.udn.yonyou"],"intro":"546456456","creator":"litfb.udn.yonyou"},{"id":"5603b2ace4b03cc538257409","appId":"udn","ts":1443082924,"etpId":"yonyou","name":"23123123","state":0,"type":1,"admins":["litfb.udn.yonyou"],"intro":"发布","creator":"litfb.udn.yonyou"},{"id":"55f90ef0e4b0b42ec561a808","appId":"udn","ts":1442385648,"etpId":"yonyou","name":"346762147","state":0,"type":1,"admins":["yangjz0.udn.yonyou"],"intro":"3577997","creator":"yangjz0.udn.yonyou"},{"id":"55ee2f02e4b0bcd206feda7e","appId":"udn","ts":1441672962,"etpId":"yonyou","name":"82年酱油","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"酱油滴滴","creator":"wangxin0.udn.yonyou"},{"id":"55ed4d5fe4b0196b75b50e8a","appId":"udn","ts":1441615199,"etpId":"yonyou","name":"GGMM","state":0,"type":1,"admins":["yangjz0.udn.yonyou"],"intro":"MMGG","creator":"yangjz0.udn.yonyou"},{"id":"5602624be4b00d6bb6630fab","appId":"udn","ts":1442996811,"etpId":"yonyou","name":"WS00002","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55fa2beae4b0da5862f09f7b","appId":"udn","ts":1442458602,"etpId":"yonyou","name":"assassin","state":0,"type":1,"admins":["yangjz0.udn.yonyou"],"intro":"","creator":"yangjz0.udn.yonyou"},{"id":"55f7d971e4b00ede2bd8c819","appId":"udn","ts":1442306417,"etpId":"yonyou","name":"cantjionwithoutpermission","state":0,"type":0,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f147e1e4b057622f6bb2f2","appId":"udn","ts":1441875937,"etpId":"yonyou","name":"codefarmer","state":0,"type":0,"admins":["wangxin0.udn.yonyou"],"intro":"codefarmer","creator":"wangxin0.udn.yonyou"},{"id":"560216d8e4b03cc5382573f9","appId":"udn","ts":1442977496,"etpId":"yonyou","name":"create_modify123","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55e70839e4b0a371dd3798b6","appId":"udn","ts":1441204281,"etpId":"yonyou","name":"create_modify_three","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"创建修改测试圈子","creator":"wangxin0.udn.yonyou"},{"id":"55e706f8e4b0a371dd3798b1","appId":"udn","ts":1441203960,"etpId":"yonyou","name":"create_modify_two","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"创建并修改的例子","creator":"wangxin0.udn.yonyou"},{"id":"55f7ef15e4b0686d4e977ee2","appId":"udn","ts":1442311957,"etpId":"yonyou","name":"dd","state":0,"type":0,"admins":["shicz.udn.yonyou"],"intro":"","creator":"shicz.udn.yonyou"},{"id":"55f15ca2e4b07f6975ea2810","appId":"udn","ts":1441881250,"etpId":"yonyou","name":"forbidden","state":0,"type":0,"admins":["wangxin0.udn.yonyou"],"intro":"gg","creator":"wangxin0.udn.yonyou"},{"id":"55eea692e4b0e460905a9826","appId":"udn","ts":1441703570,"etpId":"yonyou","name":"jdn","state":1,"type":0,"admins":["haoba1.udn.yonyou"],"intro":"aaaaaaaaaa","creator":"haoba1.udn.yonyou"},{"id":"55f12000e4b07f6975ea27d2","appId":"udn","ts":1441865728,"etpId":"yonyou","name":"myGod","state":0,"type":1,"admins":["liuhca.udn.yonyou"],"intro":"God","creator":"liuhca.udn.yonyou"},{"id":"55f7d945e4b00ede2bd8c816","appId":"udn","ts":1442306373,"etpId":"yonyou","name":"needtobeinvited","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f7d904e4b00ede2bd8c813","appId":"udn","ts":1442306308,"etpId":"yonyou","name":"openone","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55f15952e4b07f6975ea2800","appId":"udn","ts":1441880402,"etpId":"yonyou","name":"privatespacebyYjz","state":0,"type":0,"admins":["yangjz0.udn.yonyou"],"intro":"no access","creator":"yangjz0.udn.yonyou"},{"id":"55ebed42e4b03f8f5d8466ea","appId":"udn","ts":1441525058,"etpId":"yonyou","name":"spaceTest","state":1,"type":1,"admins":["rongqb.udn.yonyou"],"intro":"test space123456789","creator":"rongqb.udn.yonyou"},{"id":"560135f9e4b03cc5382573f5","appId":"udn","ts":1442919929,"etpId":"yonyou","name":"ws002","state":1,"type":1,"admins":["rongqb.udn.yonyou"],"intro":"","creator":"rongqb.udn.yonyou"},{"id":"5604130961ccd5838f0339a6","appId":"udn","ts":1443107593,"etpId":"yonyou","name":"ws_1443107592","state":0,"type":0,"admins":["zhangxin0.udn.yonyou"],"intro":"test space","creator":"zhangxin0.udn.yonyou"},{"id":"560413d061ccd5838f0339a8","appId":"udn","ts":1443107792,"etpId":"yonyou","name":"ws_1443107792","state":0,"type":0,"admins":["zhangxin0.udn.yonyou"],"intro":"test space","creator":"zhangxin0.udn.yonyou"},{"id":"5604148861ccd5838f0339aa","appId":"udn","ts":1443107976,"etpId":"yonyou","name":"ws_1443107976","state":0,"type":0,"admins":["rongqb.udn.yonyou"],"intro":"test space","creator":"rongqb.udn.yonyou"},{"id":"55f7eedbe4b0686d4e977edd","appId":"udn","ts":1442311899,"etpId":"yonyou","name":"zz","state":1,"type":0,"admins":["shicz.udn.yonyou"],"intro":"","creator":"shicz.udn.yonyou"},{"id":"55ee936ae4b0e460905a97e5","appId":"udn","ts":1441698666,"etpId":"yonyou","name":"中国人","state":0,"type":0,"admins":["guoshg.udn.yonyou"],"intro":"","creator":"guoshg.udn.yonyou"},{"id":"55e419eae4b02f8c88dd464d","appId":"udn","ts":1441012202,"etpId":"yonyou","name":"五音不全","state":1,"type":1,"admins":["guoshg.udn.yonyou"],"intro":"","creator":"guoshg.udn.yonyou"},{"id":"560102f1e4b03cc5382573e2","appId":"udn","ts":1442906865,"etpId":"yonyou","name":"创建圈子简化页面","state":1,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"},{"id":"55e50689e4b067f1b054a79f","appId":"udn","ts":1441072777,"etpId":"yonyou","name":"天天","state":0,"type":1,"admins":["wangxin0.udn.yonyou"],"intro":"","creator":"wangxin0.udn.yonyou"}]};
//		global.JSFN.listSpacesCallback(fake_data);
//		global.proxy.getWallSpaceList(JSON.stringify(space_list_param));
		callSDK('getWallSpaceList',space_list_param)
	};
	setTimeout(function(){refreshSpaces();},window.proxy?0:80);
	
	$(document).on('tap','#space_edit_btn',function(){
		$('.spaces-page').addClass('editable');
		$('#allspaces li:not(.incharge)').addClass('hidden');//只显示有操作权限的圈子
		global.spcScroll.refresh();

		//隐藏操作圈子菜单
		$('.sps-operations').addClass('hidden');
	});
	/*弹出创建圈子表单*/
	$(document).on('tap','#new_space',function(){
		$('#space_creat').removeClass('hidden');
//		$('#space_creat').addClass('live act');
		setTimeout(function(){
			$('#space_creat').animate({top:'0%'},200,'ease-in');//addClass('act');
		},50);
	});
	/*编辑圈子*/
	$(document).on('tap','.spaces-page.editable .all-spc li,.spaces-page.editable .my-spc li',function(){
		var spaceName = $(this).find('.space-name').html();
		$("#space-pic").text(spaceName.substr(spaceName.length - 2 , 2));
		$('#space_edit').find('input[name="new_space_name"]').val(spaceName);
		$('#space_edit').find('input[name="new_space_intro"]').val($(this).find('.space-brief').html());
		$('#space_edit').find('.spc-dismiss').attr('sid',$(this).find('.join-sts').attr('sid'));
		$('#spc_id').val($(this).find('.join-sts').attr('sid'));
		var origin_type = $(this).find('.join-sts').attr('spcType');
		if(origin_type==1){
			$('#new_auth_label').addClass('checked');
		}else{
			$('#new_auth_label').removeClass('checked');
		}
		
		$('#space_edit').removeClass('hidden');
		setTimeout(function(){
			$('#space_edit').animate({top:'0%'},200,'ease-in');// addClass('act');
		},50);
		$('.spaces-page').removeClass('editable');
		$('#allspaces li').removeClass('hidden');
	});
	/*退出圈子*/
	$(document).on('tap','.my-spc .join-sts',function(){
		if($('.spaces-page').hasClass('editable')){
			return false;
		}
		var data = {
			userId:"_wallspaceJID_",
			spaceId:$(this).attr('sid')
		}
		$(this).closest('li').addClass('todeal');
//		global.proxy.quitWallSpace(JSON.stringify(data));
		callSDK('quitWallSpace',data);
	});
	/*加入圈子*/
	$(document).on('tap','.all-spc .unjoined', function(){
		if($('.spaces-page').hasClass('editable')){
			return false;
		}
		var data = {
			userId:"_wallspaceJID_",
			spaceId:$(this).attr('sid')
		};
		$(this).closest('li').addClass('todeal'); 
//		global.proxy.joinWallSpace(JSON.stringify(data));
		if($(this).attr('spcType')==1){
			callSDK('joinWallSpace',data);
		}else{
			window.targetWsid = $(this).attr('sid');
			$('#space_apply').removeClass('hidden');
			 setTimeout(function(){
			 	$('#space_apply').addClass('act')
			 },50);
		}
		
	});
	/*申请加入圈子*/
	
	$(document).on('tap','#space_apply .confirm',function(e){
		var data = {
				userId:'_wallspaceJID_',
				spaceId:window.targetWsid
		}
		callSDK('applyInWallSpace',data);
		return false;
	});
	
	
	$(document).on('tap','#space_creat .arr-back',function(){
		$('#space_creat').animate({top:'100%'},200,'ease-in')//removeClass('act');
		setTimeout(function(){$('#space_creat').addClass('hidden');},200);
		return false;
	});
	$(document).on('tap','#space_edit .arr-back',function(){
		$('#space_edit').animate({top:'100%'},200,'ease-in')//.removeClass('act');
		setTimeout(function(){$('#space_edit').addClass('hidden');},200);
		return false;
	});
	$(document).on('tap','#space_apply .arr-back',function(){
		$('#space_apply').animate({top:'100%'},200,'ease-in')//.removeClass('act');
		setTimeout(function(){$('#space_apply').addClass('hidden');},200);
		return false;
	});
	/*创建圈子*/
	$(document).on('tap','#space_creat .confirm',function(e){
		var spaceName = $('input[name="space_name"]').val().trim();
		if(!(/^[A-Za-z0-9_\u4e00-\u9fa5]{1,10}$/).test(spaceName)){
			if (spaceName.length > 10) {
				showMessage('圈子名称最长10位');
			} else{
				showMessage('圈子名称格式不正确');
			}
			return false;
		}
		if($('input[name="space_intro"]').val().trim().length>50){
			showMessage('圈子简介过长');
			return false;
		}
		var data = {
			space:{
				name:$('input[name="space_name"]').val(),
				intro:$('input[name="space_intro"]').val(),
				creator:'_wallspaceJID_',
				type:$('#auth_label').hasClass('checked')?1:0,
				user_ids:'',
				admin:'_wallspaceJID_'
			}
		}
//		global.proxy.createWallSpace(JSON.stringify(data));
		callSDK('createWallSpace',data);
	});
	$('#sps_oper_btn').on('tap',function(){
		$('.sps-operations').removeClass('hidden');
	});
	$(document).on('tap',function(e){
		var $target = $(e.target);
		if(!($target.closest('ul').hasClass('sps-operations') || $target.closest('div').attr('id')=='sps_oper_btn')){
			$('.sps-operations').addClass('hidden');
		}
	});
	$(document).on('tap','.spc-dismiss',function(){
		var data = {
			id:$(this).attr('sid'),
			userId:"_wallspaceJID_"
		}
//		global.proxy.deleteWallSpace(JSON.stringify(data));
		callSDK('deleteWallSpace',data);
	});
	$(document).on('tap','#view_member',function(){
//		localStorage.wsidCache = $('#spc_id').val();
		location.href='spc-user.html?wsidCache='+$('#spc_id').val();
	})
	/*保存圈子修改*/
	$('.spc-save').on('tap',function(){
		var newSpaceName = $('input[name="new_space_name"]').val().trim();
		if(!(/^[A-Za-z0-9_\u4e00-\u9fa5]{1,10}$/).test(newSpaceName)){
			if (newSpaceName.length > 10) {
				showMessage('圈子名称最长10位');
			} else{
				showMessage('圈子名称格式不正确');
			}
			return false;
		}
		if($('input[name="new_space_intro"]').val().trim().length>50){
			showMessage('圈子简介过长');
			return false;
		}
		var data={
			userId:'_wallspaceJID_',
			sid:$('#spc_id').val(),
			space:{
				name:$('input[name="new_space_name"]').val(),
				intro:$('input[name="new_space_intro"]').val(),
				type:$('#new_auth_label').hasClass('checked')?1:0,
			}	
		};
		callSDK('modifyWallSpace',data);
	})
	
	$(document).on('tap','#auth_label,#new_auth_label',function(){
		$(this).toggleClass('checked');
	});
	
})(window);
