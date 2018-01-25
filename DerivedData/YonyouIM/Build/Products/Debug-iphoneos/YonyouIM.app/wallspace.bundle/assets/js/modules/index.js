;(function(global){
	/**
	 * index主JS文件
	 */
	var myScroll,
		pullDownEl, pullDownOffset,
		pullUpEl, pullUpOffset,
		generatedCount = 0;
	var refresh_flag = true;
	var window_width = $(window).width(),
		window_height = $(window).height();
	$('#pic_viewer').css('lineHeight',window_height+"px");
	$('#send_msg_bd').css('max-height',window_height-150+'px')

	var IndexMain = function(){
		//var
	}
	
	$('.switch-space .drop-menu').width(window_width);
//	global.proxy.getJID();
	callSDK("getJID"); 
//	var urlStr = window.location.href;
//	var paraObj = genParaObj(urlStr.split('?')[1]);
//	var curSpaceId = paraObj.curSpaceId?paraObj.curSpaceId:0;
//	$('.switch-space .drop-menu').css('max-height',window_height);

/**
	 * 初始化iScroll控件
	 */
	function loaded() {
		global.spcsScroll = new IScroll('#spc-wrapper');
		global.spcsScroll.refresh();
		global.sendMsgScroll = new IScroll('#send_msg_bd');
		return;/*replace_the_iscroll*/
		pullDownEl = document.getElementById('pullDown');
		pullDownOffset = pullDownEl.offsetHeight;
		pullUpEl = document.getElementById('pullUp');
		pullUpOffset = pullUpEl.offsetHeight;
		
		global.myScroll = new IScroll('#wrapper',{ mouseWheel: true });
//		global.SwitchScroll = new IScroll('#spc-wrapper',{ mouseWheel: true });
		var flag;
		global.myScroll.on('scrollStart',function(){

		});
		global.myScroll.on('scrollEnd',function(){


			//$('.pullUpLabel').html( '<img style="width:25px" src="../img/loading.GIF">');
			//上拉刷新
			if((this.y-this.maxScrollY)<=50 && this.directionY == 1){
				if (!hasReachBottom()) {
					showMessage("已到最后");
					$('.pullUpLabel').html('');
					return false;
				}else{
					$('.pullUpLabel').html( '<img style="width:25px" src="../img/loading.GIF">');
					flag = 0;
				}				
			}
			if(this.y == 0 && this.directionY == -1){
				flag = 1;
				$('.pullDownLabel').html( '<img style="width:25px" src="../img/loading.GIF">');
			}


			/*
			* 下拉到底部
			*/
			if(flag === 0){
				pullUpAction();
//				global.myScroll.refresh();
//				$('.pullUpLabel').html( '');
			}
			if(flag === 1){
				//$('.pullDownLabel').html( '下拉刷新...');
					pullDownAction();
			}
			flag = -1;
		});
			
	}

		var space_list_param={
			page:0,
			pageSize:50,
			userId:"_wallspaceJID_"
		};
//		var space_list_param={
//			page:0,
//			pageSize:200,
//			userId:"wangxin0.udn.yonyou",
//			token:'b59ec83d-de5f-4fec-b469-b79f7da3120f'
//		};
//		global.proxy.getJoinedSpaces(JSON.stringify(space_list_param));
		setTimeout(function(){ callSDK("getJoinedSpaces",space_list_param);},global.proxy?0:80);
	/*
	 * 刷新方法
	 */
	global.refreshPage = function () {
//		var param = {
//			wsid:0,//localStorage.cur_space_id,
//			username:"wangxin0.udn.yonyou",
//			page:0,
//			pageSize:200,
//			token:"b59ec83d-de5f-4fec-b469-b79f7da3120f"
//		};
		window.cur_page =1;
		var param = {
//			wsid:localStorage.cur_space_id,
			wsid:curSpaceId,
			userId:"_wallspaceJID_",
			page:window.cur_page,
			pageSize:20
		};
		
//	var fake_data = {
//						con_lists: [{"id":"56049b19e4b03cc53825740c","sid":"0","username":"litfb.udn.yonyou","replyList":[],"ts":1443142425,"docType":1,"praiseUsers":[],"nickName":"hippo","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"<img src=\\\"..\/img\/face\/smile_1f609.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f60e.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f60d.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f60c.png\\\" class=\\\"face-pic\\\">","praiseNickNames":[]},{"id":"56049b0be4b03cc53825740b","sid":"0","username":"litfb.udn.yonyou","replyList":[{"id":"56049b31e4b03cc53825740d","userFrom":"litfb.udn.yonyou","ts":1443142449,"nickNameTo":"hippo","userTo":"litfb.udn.yonyou","pid":"56049b0be4b03cc53825740b","cont":"<img src=\\\"..\/img\/face\/smile_1f601.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f601.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f601.png\\\" class=\\\"face-pic\\\">","nickNameFrom":"hippo"}],"ts":1443142411,"docType":1,"praiseUsers":[],"nickName":"hippo","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"<img src=\\\"..\/img\/face\/smile_1f602.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f602.png\\\" class=\\\"face-pic\\\"><img src=\\\"..\/img\/face\/smile_1f602.png\\\" class=\\\"face-pic\\\">","praiseNickNames":[]},{"id":"5603ae2fe4b03cc538257408","sid":"0","username":"litfb.udn.yonyou","replyList":[{"id":"5603b6e0e4b087eef327c062","userFrom":"zhangxin0.udn.yonyou","ts":1443084000,"nickNameTo":"hippo","userTo":"litfb.udn.yonyou","pid":"5603ae2fe4b03cc538257408","cont":"哦哦","nickNameFrom":"3333"}],"ts":1443081775,"docType":1,"praiseUsers":[],"nickName":"hippo","documents":["jbvmfs34la9tmtkdofgx","i8lgbjtm4tf8x4tp9hqt","irf87tr21wka16wm3vea"],"remoteUrl":"","remoteAbstract":"","cont":"<div class = 'img-can '><p style='background-image:url(https:\/\/im.yyuap.com\/sysadmin\/rest\/resource\/yonyou\/udn\/download?token=a8e6030b-8e2a-433c-b58c-9e4ed90df5a6&attachId=jbvmfs34la9tmtkdofgx&mediaType=2&downloader=yangjz0.udn.yonyou)'><\/p><p style='background-image:url(https:\/\/im.yyuap.com\/sysadmin\/rest\/resource\/yonyou\/udn\/download?token=a8e6030b-8e2a-433c-b58c-9e4ed90df5a6&attachId=i8lgbjtm4tf8x4tp9hqt&mediaType=2&downloader=yangjz0.udn.yonyou)'><\/p><p style='background-image:url(https:\/\/im.yyuap.com\/sysadmin\/rest\/resource\/yonyou\/udn\/download?token=a8e6030b-8e2a-433c-b58c-9e4ed90df5a6&attachId=irf87tr21wka16wm3vea&mediaType=2&downloader=yangjz0.udn.yonyou)'><\/p><\/div>","praiseNickNames":[]},{"id":"5603adf4e4b03cc538257407","sid":"0","username":"litfb.udn.yonyou","replyList":[],"ts":1443081716,"docType":1,"praiseUsers":[],"nickName":"hippo","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"sdfsdfsdfsdf","praiseNickNames":[]},{"id":"5603a58ee4b0e3280f38d041","sid":"0","username":"yangjz0.udn.yonyou","replyList":[],"ts":1443079566,"docType":1,"praiseUsers":[],"nickName":"建祖","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"我问燕子你为啥来。。燕子说这里的山路十八弯。。八佰伴","praiseNickNames":[]},{"id":"5603a339e4b0e3280f38d040","sid":"0","username":"yangjz0.udn.yonyou","replyList":[],"ts":1443078969,"docType":1,"praiseUsers":[],"nickName":"建祖","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"我这个人不太会说话, 要是有什么得罪的地方。你特么来打我啊","praiseNickNames":[]},{"id":"560248a1e4b00d6bb6630f9f","sid":"0","username":"yangjz0.udn.yonyou","replyList":[{"id":"560248c4e4b00d6bb6630fa0","userFrom":"wangxin0.udn.yonyou","ts":1442990276,"nickNameTo":"建祖","userTo":"yangjz0.udn.yonyou","pid":"560248a1e4b00d6bb6630f9f","cont":"DDT","nickNameFrom":"王鑫111"},{"id":"560249c0e4b00d6bb6630fa3","userFrom":"yangjz0.udn.yonyou","ts":1442990528,"nickNameTo":"建祖","userTo":"yangjz0.udn.yonyou","pid":"560248a1e4b00d6bb6630f9f","cont":"Yy","nickNameFrom":"建祖"}],"ts":1442990241,"docType":1,"praiseUsers":[],"nickName":"建祖","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"Keep moving","praiseNickNames":[]},{"id":"56023a4ee4b00d6bb6630f89","sid":"0","username":"litfb.udn.yonyou","replyList":[{"id":"56039e50e4b0e3280f38d03c","userFrom":"wangxin0.udn.yonyou","ts":1443077712,"nickNameTo":"hippo","userTo":"litfb.udn.yonyou","pid":"56023a4ee4b00d6bb6630f89","cont":"<img src=\"..\/img\/face\/smile_1f60e.png\" class=\"face-pic\">","nickNameFrom":"王鑫111"}],"ts":1442986574,"docType":1,"praiseUsers":[],"nickName":"hippo","documents":["6knlrrjkddnsfeodllyd"],"remoteUrl":"","remoteAbstract":"","cont":"<img src='https:\/\/im.yyuap.com\/sysadmin\/rest\/resource\/yonyou\/udn\/download?token=a8e6030b-8e2a-433c-b58c-9e4ed90df5a6&attachId=6knlrrjkddnsfeodllyd&mediaType=2&downloader=yangjz0.udn.yonyou'\/>","praiseNickNames":[]},{"id":"56014d97e4b00d6bb6630f81","sid":"0","username":"wangxin0.udn.yonyou","replyList":[{"id":"5601f45ce4b00d6bb6630f82","userFrom":"wangxin0.udn.yonyou","ts":1442968668,"nickNameTo":"王鑫111","userTo":"wangxin0.udn.yonyou","pid":"56014d97e4b00d6bb6630f81","cont":"hg","nickNameFrom":"王鑫111"},{"id":"56038b9ce4b0e3280f38d00e","userFrom":"yangjz0.udn.yonyou","ts":1443072924,"nickNameTo":"王鑫111","userTo":"wangxin0.udn.yonyou","pid":"56014d97e4b00d6bb6630f81","cont":"<img src=\"..\/img\/face\/smile_1f609.png\" class=\"face-pic\">","nickNameFrom":"建祖"}],"ts":1442925975,"docType":1,"praiseUsers":["wangxin0.udn.yonyou"],"nickName":"王鑫111","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"yy","praiseNickNames":["王鑫111"]},{"id":"56014b5de4b00d6bb6630f80","sid":"0","username":"wangxin0.udn.yonyou","replyList":[],"ts":1442925405,"docType":1,"praiseUsers":[],"nickName":"王鑫111","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"<img src=\"..\/img\/face\/smile_1f608.png\" class=\"face-pic\"><img src=\"..\/img\/face\/smile_1f608.png\" class=\"face-pic\"><img src=\"..\/img\/face\/smile_1f609.png\" class=\"face-pic\">","praiseNickNames":[]},{"id":"56012a79e4b0033be842c122","sid":"0","username":"wangxin0.udn.yonyou","replyList":[],"ts":1442916985,"docType":1,"praiseUsers":[],"nickName":"王鑫111","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"呵呵","praiseNickNames":[]},{"id":"56010ae0e4b0033be842c118","sid":"0","username":"wangxin0.udn.yonyou","replyList":[{"id":"56010ae8e4b0033be842c119","userFrom":"wangxin0.udn.yonyou","ts":1442908904,"nickNameTo":"王鑫111","userTo":"wangxin0.udn.yonyou","pid":"56010ae0e4b0033be842c118","cont":"呵呵呵","nickNameFrom":"王鑫111"},{"id":"56012a74e4b0033be842c11f","userFrom":"wangxin0.udn.yonyou","ts":1442916980,"nickNameTo":"王鑫111","userTo":"wangxin0.udn.yonyou","pid":"56010ae0e4b0033be842c118","cont":"去","nickNameFrom":"王鑫111"}],"ts":1442908896,"docType":1,"praiseUsers":[],"nickName":"王鑫111","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"有营养","praiseNickNames":[]},{"id":"55f8093fe4b0686d4e977ef5","sid":"0","username":"shicz.udn.yonyou","replyList":[{"id":"55f80943e4b0686d4e977ef6","userFrom":"shicz.udn.yonyou","ts":1442318659,"nickNameTo":"施成章","userTo":"shicz.udn.yonyou","pid":"55f8093fe4b0686d4e977ef5","cont":"x","nickNameFrom":"施成章"}],"ts":1442318655,"docType":1,"praiseUsers":[],"nickName":"施成章","documents":["5ai9cyjg5s719i23i8bk"],"remoteUrl":"","remoteAbstract":"","cont":"d<img src='https:\/\/im.yyuap.com\/sysadmin\/rest\/resource\/yonyou\/udn\/download?token=a8e6030b-8e2a-433c-b58c-9e4ed90df5a6&attachId=5ai9cyjg5s719i23i8bk&mediaType=2&downloader=yangjz0.udn.yonyou'\/>","praiseNickNames":[]},{"id":"55f80938e4b0686d4e977ef3","sid":"0","username":"shicz.udn.yonyou","replyList":[],"ts":1442318648,"docType":1,"praiseUsers":["wangxin0.udn.yonyou"],"nickName":"施成章","documents":[],"remoteUrl":"","remoteAbstract":"","cont":"d","praiseNickNames":["王鑫111"]}]
//				};
//		var html = template('convs', fake_data);
//		var $conDOM = $(html);
//		$('#thelist').html($conDOM);
//		global.proxy.getPostList(JSON.stringify(param));
		setTimeout(function(){ callSDK("getPostList",param);},global.proxy?80:120);
		/*$.ajax({
//			url:r_url + '?_='+new Date().getTime(),
			url:'http://172.20.8.189:9090/sysadmin/plugins/friends/dynamic/wallspace/postList',
			type:"post",
			dataType:'json',
			data:JSON.stringify(param),
			success:function(res_data){
				var data = {
						con_lists: res_data
				};
				var html = template('convs', data);
				var $conDOM = $(html);
				var $tem_imgs = $conDOM.find('img');
				$conDOM.find('img:not(.face-pic)').each(function(i){
						$(this).attr('src', 'http://m.qpic.cn/psb?/V13JxPiP2M8tIN/4y8atM4MOiaSphhN9TNiT2HDNUF4aeQLyd01k0s0640!/m/dBwBAAAAAAAA&ek=1&kp=1&pt=0&bo=gAJVAwAAAAAFAPc!&su=059567857&t=5#sce=5-4-3&rf=-0-0&appid=311');
				});
//				var imgs_str = '<div class="img-can">';
//				if($tem_imgs.length>1){
//					$tem_imgs.each(function(i){
//						imgs_str+='<p style="background:url('+$(this).attr('src')+')"></p>';
//						$(this).remove();
//					});
//					imgs_str+='</div>';
//					html = imgs_str+$conDOM.html();
//					$conDOM.prepend(imgs_str);
//				}
//				alert(html)
				$('#thelist').html($conDOM);
				global.myScroll.refresh();
			},
			error:function(data){
			}
		});*/
	}

	refreshPage();
	/**
	 * 下拉刷新
	 * myScroll.refresh();
	 */
	function pullDownAction () {
		window.spacePullType = 1;
		refreshPage();
	}

	//检查是否到达列表底部
	function hasReachBottom(){
		return $("#notMore").hasClass('hidden');
	}

	/**
	 * 上拉加载更多
	 * myScroll.refresh();
	 */
	function pullUpAction () {
		window.spacePullType = 0;
		var param = {
//			wsid:localStorage.cur_space_id,
			wsid:curSpaceId,
			userId:"_wallspaceJID_",
			page:++window.cur_page,
			pageSize:20
		};
		callSDK("getPostList",param);
	}

	

	//禁止tochmove事件
//	document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
	//初始化绑定iScroll控件
	document.addEventListener('DOMContentLoaded', loaded, false);


	$(document).on('error','img',function(e){
	});

	


    /**
    * 选择本地文件后的回调方法
    */
	function onUploadImgChange(sender){
        var filePath = sender.value;
        //var fileExt = filePath.substring(filePath.lastIndexOf(".")).toLowerCase();
        try{
            if(typeof FileReader !== 'undefined'){
               for(var i=0;i<sender.files.length;i++){
		               var file = sender.files[i];
		                var fileSize = file.fileSize || file.size;
		              	if(checkFileSize(fileSize)){
		                    var reader = new FileReader();
		                    reader.onload = (function(f){
		                    	return function(e){
		                    		var _p = document.createElement("p");
									_p.style.backgroundImage = "url("+this.result+")";//'<p style="background:url('+filePath+')"></p>'
									/*_img = document.createElement("img");
									_img.attributes['picType'] = 'pic';
									_img.src = data_cbk[i];
									_img.style.width = '40%';
									_img.style.margin = '0 5%';
									_img.style.float = 'left';*/
//									document.getElementById('imgcont').appendChild(_p);
									$('#imgcont').append(_p);
									global.sendMsgScroll.refresh();
		                    	}
		                    	
		                    })(file);
		                    reader.readAsDataURL(file);
		              	}
               }
            }
        }catch(e){
            ("出错了");
        }
    }

   



	/*
	* 发布会话
	*/
	global.sendmessage = function (content,fid,gid){
		//会话数据
    	var _data = {};
		var  $imgList = $('#imgcont').children('p');
		var _content = ($.trim(content));
		if(!_content&&!$('#imgcont').html()){
			showMessage('动态内容不能为空');
			return false;
		}
    	var pic_list = new Array();
    	if($imgList.length > 0){
			$imgList.each(function(i){
				if($(this).css('backgroundImage')){
					var img_url = $(this).css('backgroundImage');
					var path = img_url.split('(')[1].split(')')[0].replace("file://","");
					if(-1!=path.indexOf('base64')){
						path = path.replace(/data:image\/\w{3,4};base64,/g, '')
					}
					pic_list.push(path);
				}
			});
			

    	}
    		
		var topost = {
			files:pic_list,
			post:{
//				sid:global.localStorage.cur_space_id,
				sid:curSpaceId,
				username:"_wallspaceJID_",
				cont: global.proxy?_content.replace(/"/g,'\\"'):_content,
				documents: [],
				docType: 1,
				remoteUrl: "",
				remoteAbstract: "",
				praiseUsers: []

			}
		}
		console.log(topost.post.cont)
//		global.proxy.publishPost(JSON.stringify(topost));
		setTimeout(function(){
					$('#sendmesspage').animate({left:'100%'},200);//.css('left','0%');
				},50);
		$('#messagefield').html('');
		console.log(topost);
		callSDK("publishPost",topost);
//  		$.ajax({
//				url: global.ESN_URL + '/speech/detail/mid/5',
//				type:'post',
//				dataType:'json',
//				data:'{"cont":"'+_content+'","fid":"'+fid+'","gid":"'+gid+'","fm":"2"}',
//				success:function(){
//					//...
//					_content = null;
//					$imgList.remove();
//					refreshPage();
//				},
//				error: function(e){
//					_content = null;
//				}
//			});
    }

	var rep_para= {}; //参数
//	var rep_para= new Array(); //参数
	var $footer=$("footer");
//	var $reply_input = $("input[name='replycont']"); //输入框
	var $reply_input = $("div[name='replycont']"); //输入框
	global.isCanReply=true;

	

	function readyForReply(post,status,reply){
		if(!global.isCanReply){
			return;
		}
		clearState();
		if(reply){
			reply.addClass('reply-item-back');
		}
		$reply_input.val("").trigger('focus');
		$footer.removeClass('hidden');
		post.addClass('ing');
//		var id = post.attr('id');
//		var fid =  post.attr('fid');
//		var replyid = id;
//		var replyuid;
//		var replyname;
		var userfrom = "_wallspaceJID_";
		var data = {
			reply:{
				pid : post.attr('id'),
				userFrom:'_wallspaceJID_'
			}
		}
		switch(status){
			case 0: replyuid  = post.find('.p-auth .u-name').attr('uid');
					replyName = post.find('.p-auth .u-name').html();
				  break;
			case 1: replyuid = reply.attr('fromid');
					replyName = reply.find('.reply').html();
				  break;
			default:break;
		}
		rep_para = data;
//		readyForParam(id,fid,replyid,replyuid,replyname);
		global.cache.replyuid = replyuid;
		global.cache.replyName = replyName;
		$reply_input.attr('placeholder','回复：'+replyName);
	}

	function readyForParam(id,fid,replyid,replyuid,replyname){
		rep_para['id']=id;
		rep_para['feed_id']=fid;
		rep_para['feed_type']=15;
		rep_para['feed_reply_to_id']=replyid;
		rep_para['feed_reply_obj_mid']=replyid;
		rep_para['feed_reply_to_mid']=replyuid;
		rep_para['feed_reply_to_name']=replyname;
	}


	/**
	* 回复
	*/
	$("#send_btn").on("tap",function(){
//		var reply_cont = $reply_input.val();
		var reply_cont = $reply_input.html();
		global.cache.replyCont = reply_cont;
		if(reply_cont.length == 0 || !$(".post-item.ing")){
			if(reply_cont.length == 0){
				$reply_input.trigger('focus');
			}
			return;
		}

		global.isCanReply=false;
		rep_para.reply.cont = global.proxy?$(this).siblings('.replycont').html().replace(/"/g,'\\"'):$(this).siblings('.replycont').html();
		rep_para.reply.userTo = global.cache.replyuid;
		$reply_input.html('');
//		global.proxy.addTextReply(JSON.stringify(rep_para));
		console.log(rep_para)
		callSDK("addTextReply",rep_para);
		$footer.addClass('hidden');

	});
	
	
	/*事件绑定 start*/
	$('.switch-tap').on('tap',function(e){
		$('.switch-space').find('.drop-menu').toggleClass('hidden');
			global.spcsScroll.refresh();
	});
	
	
	$(document).on('tap',function(e){
		var $target = $(e.target);
		if(!$(e.target).closest('.switch-tap').length&& 
		!$(e.target).closest('ul').hasClass('drop-menu')){
			$('.drop-menu').addClass('hidden');
			global.spcsScroll.refresh();
		}
		if(!$target.closest('.face-wraper').length && !$target.hasClass('add-face')){
			$('#sendmesspage').find('.faces-container').html('');
		}
//
		$target.closest('div').hasClass("reply-btn") ? readyForReply($target.closest(".post-item"),0) : $target.hasClass("reply-item") ? readyForReply($target.closest(".post-item"),1,$target) :(function(){if(!($target.hasClass("replycont")||($target.closest('#reply-ops').length)||$target.hasClass('add-face')||$target.closest('div').hasClass('face-list'))){$footer.addClass('hidden');clearState();}})();
	});

	$('.add-face').on('tap',function(){
		$target_face_area = $(this).closest('.face-node').find('.faces-container');
		if(!$target_face_area.find('.face-wraper').length){
			$target_face_area.append(face_list);
		}
		if($(this).closest('#send_msg_bd').length){
			global.sendMsgScroll.refresh();
		}
		$('.face-list ul').width(window_width);
		$('.msg-extra').addClass('hidden');
	});

	var face_page = 0;
	$(document).on('touchmove','.face-list',function(e){e.preventDefault();});
	$(document).on('swipeLeft','.face-list',function(e){
		if(face_page>=2)return;
		face_page++;
		$(this).css('marginLeft',-face_page*window_width+'px')
	});
	$(document).on('swipeRight','.face-list',function(){
		if(face_page<=0)return;
		face_page--;
		$(this).css('marginLeft', -face_page*window_width+'px')
	});

	/*表情*/
	$(document).on('tap','.face-list img',function(){
		var $tem_img = $(this).clone();
		$tem_img.addClass('face-pic')
		var $face_node = $(this).closest('.face-node');
		$face_node.find('.face-allow').append($tem_img);
		if($face_node.attr('id')=='sendmesspage'){
			$face_node.find('.place-holder').hide();
		}
//		exeSucess = "document.execCommand('insertHtml', false,'<img src=\""
//      + 'https://www.baidu.com/img/bdlogo.png'+ "\" height=auto width=200 ></img>');";
//      console.log(exeSucess)
//      eval(exeSucess);



	});

	$('#messagefield').on('keyup tap blur',function(e){
		if(e.type == 'blur'){
			$('.msg-extra').addClass('hidden');
		}else{
			$('.msg-extra').removeClass('hidden');
			$(this).siblings('.place-holder').hide();
		}

	});
	$('#messagefield').on('paste',function(e){
			e.preventDefault();
			var clip_cont = (e.clipboardData.getData('text/plain'));
			console.log(e.clipboardData.getData('text/plain'));
			$(this).append(htmlspecialchars(clip_cont));

	});
	$(this).closest('.face-node').find('.faces-container').html('');
	/*
	 * 调用本地的摄像头
	 */
	$('#catchphoto').on('tap',function(e){
		if(window.proxy){
			window.proxy.startPhotoActivity();
		}else{
			$('#pic_model').removeClass('hidden')
		}
	});

	$('#ios_photo,#ios_loc_pic').on('change', function(e){
		onUploadImgChange(this);
	});
	/*点赞*/
	$(document).on('tap','.post-foot .praise',function(){
		data={
			praise:{
				pid:$(this).closest('.post-item').attr('id'),
				userFrom:'_wallspaceJID_',
				userTo:$(this).closest('.post-item').attr('id')
			}
		};
		var $praise_count = $(this).find('.praise-num');
		if(!$(this).hasClass('praised')){
			$(this).append('<span class="fly-plus1">+1</span>')
			$praise_count.html(parseInt($praise_count.html(),10)+1 );
			$(this).addClass('praised');
//			global.proxy.addPraiseReply(JSON.stringify(data));
			callSDK("addPraiseReply",data)
		}else{
			$praise_count.html(parseInt($praise_count.html(),10)-1 );
			$(this).removeClass('praised');
//			global.proxy.cancelPraiseReply(JSON.stringify(data));
			callSDK("cancelPraiseReply",data);

		}
	});
	$(document).on('tap','.sps-link',function(){
		switchSpace($(this).attr('sid'),$(this).html());
	});
	$(document).on('tap','.p-cont img:not(.face-pic),.p-cont p',function(e){
		var $target = $(e.target);
		if($target.is('p')){
			var $list = $(this).parent().find('p');
			var p_index = $list.index($(this));
			var	append_str = '<ul class="clearfix" style="width:'+$list.length*window_width+'px;-webkit-transform:translateX('+-p_index*window_width+'px);">';
			$list.each(function(){
				var img_url = $(this).css('backgroundImage');
				var path = img_url.split('(')[1].split(')')[0];
					append_str+= ('<li style="width:'+window_width+'px"><img src="'+path+'"/></li>');
//					append_str+= ('<li style="width:'+window_width+'px"><img src="'+'http://www.topdesignmag.com/wp-content/uploads/2010/12/2216.jpg'+'"/></li>');
			});
			append_str+="</ul>"
		}else{
			append_str = '<ul class="clearfix" style="width:'+window_width+'px;-webkit-transform:translateX(0px);">';
			append_str+= ('<li style="width:'+window_width+'px"><img src="'+$(this).attr('src')+'"/></li></ul>');
//			$("#pic_viewer").append($(this).clone()).removeClass('hidden')
		}
		$("#pic_viewer").append(append_str).removeClass('hidden');
	});
	var img_index = 0,startX,startTime,diff,cur_X,$pic_container = $('#pic_viewer').find('ul'),
		limit = $('#pic_viewer').find('li').length;
	$(document).on('touchstart','#pic_viewer img',function(e){
		$('#pic_viewer').find('ul').css('-webkit-transition-duration','0ms')
			cur_X = getCurX();
			startTime = new Date;
			var touch_point = e.touches[0];
			startX = touch_point.clientX;
			//alert(touch_point.clientX)
			limit = $('#pic_viewer').find('li').length;
	})
	$(document).on('touchmove','#pic_viewer img',function(e){
			var touch_point = e.touches[0];
			diff = (touch_point.clientX-startX);

//			console.log("diff:"+diff+"cur:"+cur_X+(parseInt(diff,10)+parseInt(cur_X,10)))
//			console.log("diff:"+diff+"curX:"+cur_X+" "+parseInt((diff+cur_X),10));
			$('#pic_viewer').find('ul').css('-webkit-transform','translateX('+(parseInt(diff,10)+parseInt(cur_X,10))+'px)');
//			$('#pic_viewer').find('ul').css('-webkit-transform','translateX('+(parseInt(diff,10)+parseInt(cur_X,10))+'px)');
	})
	$(document).on('touchend','#pic_viewer img',function(e){
			var duration = new Date - startTime;
			if(!(diff<0&&img_index == limit-1)&&!(diff>0&&img_index == 0)
			&&(Math.abs(diff)>window_width/2 ||( (duration<250)&&Math.abs(diff)>20))){
				diff<0?img_index++:img_index--;
//				alert(-window_width*img_index)
					$('#pic_viewer img').removeClass('enlarge');
					$('#pic_viewer img').css('-webkit-transform','scale(1.0);')

				$('#pic_viewer').find('ul').css('-webkit-transition-duration','500ms')
				setTimeout(function(){
					$('#pic_viewer').find('ul').css('-webkit-transform','translateX('+-window_width*img_index+'px)');
				},50);
				cur_X = getCurX();
			}else{
					$('#pic_viewer').find('ul').css('-webkit-transition-duration','500ms')
					$('#pic_viewer').find('ul').css('-webkit-transform','translateX('+cur_X+'px)');

			}
			/*if((diff<0&&img_index == limit-1)||(diff>0&&img_index == 0)
			||(Math.abs(diff)<window_width/2 && (duration>250)||diff<20)){
					$('#pic_viewer').find('ul').css('-webkit-transition-duration','200ms')
					$('#pic_viewer').find('ul').css('-webkit-transform','translateX('+cur_X+'px)');
			}else{
				diff<0?img_index++:img_index--;
//				alert(-window_width*img_index)
				$('#pic_viewer').find('ul').css('-webkit-transition-duration','200ms')
				setTimeout(function(){
					$('#pic_viewer').find('ul').css('-webkit-transform','translateX('+-window_width*img_index+'px)');
				},200);
				cur_X = getCurX();

			}*/
			diff = startX = 0;
	})
	var type;
	$(document).on('doubleTap','#pic_viewer *',function(e){
		type = e.type;
		var active_img = $('#pic_viewer img').eq(img_index);
				if(active_img.hasClass('enlarge')){
					active_img.removeClass('enlarge');
					active_img.css('-webkit-transform','scale(1.0);')
				}else{
					active_img.addClass('enlarge');
					active_img.css('-webkit-transform','scale(1.8);')
				}
	});
	$(document).on('tap','#pic_viewer *',function(e){
		type = e.type;
		setTimeout(function(){console.log(type); if(type=='tap'){
			diff = startX = cur_X = img_index = 0;
			$('#pic_viewer').html('').addClass('hidden');
		}},300);
	});
	$(document).on('focusin','.face-allow',function(){
		$(this).closest('.face-node').find('.faces-container').html('');
	});
//	$('header').on('touchmove', function (e) { e.preventDefault(); }, false);
	/*ios拍照、本地图片*/
	$(document).on('tap','#ios_photo,#ios_pic',function(){
		$('#pic_model').addClass('hidden');
		location.href = "wallspace://"+($(this).attr('id')=='ios_pic'?'localPic':'takePhoto');
	});
	$(document).on('tap','#pic_model',function(e){
		 if($(e.target).find('div').length){
		 	$('#pic_model').addClass('hidden');
		 }
	});
	$(document).on('tap','#pic_model .cancel',function(e){
		 	$('#pic_model').addClass('hidden');
	});

	var publish_flag = true;
	$(document).on('tap','#sendmessage',function(){
		if(!publish_flag){return false;}
		publish_flag = false;
		$('#sendmesspage').removeClass('hidden');
		setTimeout(function(){
			$('#sendmesspage').animate({left:'0%'},200);//.css('left','0%');
			publish_flag = true;
		},50)
	})
	$(document).on('tap','#sendmesspage .exit',function(){
		if( confirm("确认放弃发布？")){
				$('#sendmesspage').animate({left:'100%'},200,'ease-in',function(){
					$('#sendmesspage').addClass('hidden');
				})//..css('left','100%');
				$('#messagefield,#imgcont').html('');
				$('#imgcont').removeClass('hascont');
				$('.messagediv .place-holder').show();
//				setTimeout(function(){
//					$('#sendmesspage').addClass('hidden');
//				},50000)
		}
	});
	document.getElementById('pic_viewer').addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
	$(document).on('tap','#befirstposter',function(){$('#sendmessage').trigger('tap')})

	/*发布动态*/
	$('#publish_btn').on('touchend',function(e){
		//隐藏键盘
		hideKeyboard();
		e.preventDefault();
		sendmessage($('#messagefield').html(),2,1);
//		$('messagefield').val('');
		$('#messagefield,#imgcont').html('');
		$('#imgcont').removeClass('hascont');
		$('.messagediv  .place-holder').show();
	})

	//所有输入框隐藏键盘
	var hideKeyboard = function() {
	    document.activeElement.blur();
	    $("input").blur();
	};
	//$(document).on('keyup','#messagefield',function(e){/*for(var obj in e){console.log(obj)}}*/alert(e.keyCode);})
	
	var w_m = {},atTop,dis,startY;
	$(document).on('touchstart','#wrapper',function(e){
		w_m.sy = e.touches[0].clientY;
		$('#wrapper').css('-webkit-transition','0')
		console.log("%%%%%%%%"+document.getElementById('wrapper').getBoundingClientRect().bottom);
		atTop = document.getElementById('wrapper').getBoundingClientRect().top>=20;
		atBottom = document.getElementById('detector').getBoundingClientRect().top<=(window_height+20);
	})
	$(document).on('touchmove','#wrapper',function(e){
			w_m.y = e.touches[0].clientY;
			dis = w_m.y-w_m.sy;
		if(atTop && dis>0){
//			console.log(dis*Math.pow(0.6,dis/window_height));
			$('#wrapper').css('-webkit-transform','translateY('+dis*Math.pow(0.5,dis/window_height)+'px)')
			e.preventDefault();	
		}else if(atBottom && dis<0){
			$('.pullUpLabel').html( '<img style="width:25px;" src="../img/loading.GIF">');
			var abs_dis = -dis;
			$('#wrapper').css('-webkit-transform','translateY(-'+abs_dis*Math.pow(0.8,abs_dis/window_height)+'px)')
			e.preventDefault();	
		}
	});
	$(document).on('touchend','#wrapper',function(e){
		//alert(dis);
//		console.log(dis);
		console.log(atBottom);
		if((atTop&&dis>0) ||(atBottom && dis<0) ){
//			setTimeout(function(){
				$('#wrapper').css('-webkit-transition','300ms');
				$('#wrapper').css('-webkit-transform','translateY(0)');
				if(atTop&&dis>0){
					pullDownAction()
				}else{
					if (!hasReachBottom()) {
						showMessage("已到最后");
						$('.pullUpLabel').html('');
						return false;
					}
					pullUpAction();	
				}
//				$('.pullUpLabel').html( '');
//			},200);
			setTimeout(function(){$('.pullUpLabel').html('');},350)
		}
	});
	/*replace_the_iscroll*/
	$(document).on('touchmove',function(e){//alert($(e.target).attr('id'))
//		if(!($(e.target).closest('#wrapper').length||$(e.target).closest('#spc-wrapper').length)){
		if(!($(e.target).closest('#wrapper').length)){
			e.preventDefault();
		}
	});
//	(function(){
//		var startY,diff,point={},transDis=0,maxDis;
//		$(document).on('touchstart','#spc-wrapper',function(e){
//			maxDis = $('#spc-wrapper .drop-menu').height();
//			startY = e.touches[0].clientY;
//		});
//		$(document).on('touchmove','#spc-wrapper',function(e){
//			var cur_y = e.touches[0].clientY;
//			diff = cur_y - startY;
//			console.log("<><><>???"+diff+"???"+transDis)
//			if((transDis>=0 && diff>=0) || (transDis<=400-maxDis && diff<=0)){
//				return;
//			}
//			transDis+=diff;
////			console.log("<><><>???"+diff);
//			$(this).find('ul').css('-webkit-transform','translateY('+transDis+'px)')
//		});
//	})();
	/*replace_the_iscroll*/
	$('#tem_test').on('change',function(){
		onUploadImgChange(this)
	});
	
	/*圈子列表用iscroll展现后点击事件被拦截*/
	$(document).on('tap','#jump',function(){location.href="spaces.html"});
	
	$(document).on('tap',function(){
		$('#messagefield').blur();
	})
	/*事件绑定end*/
	
	
	
	//清除上次点击缓存
	global.clearState = function(){
		$(".post-item.ing").removeClass("ing");
		$('.reply-item.reply-item-back').removeClass('reply-item-back');
	}

	 //检测文件大小
    function checkFileSize(fileSize){
		if(fileSize > 1024*1024*5){
			alert("您上传的文件大于5M,请重新选择！");
			return false;
		}
        return true;
    }
    function getCurX(){
    	var trans = $(document).find('#pic_viewer ul').css('-webkit-transform');
			 var tem = $.inArray(trans,[undefined,'none',null])>=0?0:trans.match(/\-?[0-9]+/g)[0];
			  return tem;
    }
    function htmlspecialchars(str)
	{
	    str = str.replace(/&/g, '&amp;');
	    str = str.replace(/</g, '&lt;');
	    str = str.replace(/>/g, '&gt;');
	    str = str.replace(/"/g, '&quot;');
	    str = str.replace(/'/g, '&#039;');
	    return str;
	}

})(window);
