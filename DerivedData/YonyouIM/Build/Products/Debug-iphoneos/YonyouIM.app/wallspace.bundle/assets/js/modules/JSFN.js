/**
* Android 回调 webview js
*/
(function (global){
    global.JSFN = {
    	/*拍照*/
    	getJIDCallback:function(data_cbk){
    		global.jid = data_cbk;
    	},
		fileChooseCallback: function(data_cbk){
//			var imgs = data_cbk.split(',');
//			var	_img;
			for(var i in data_cbk){
				var _p = document.createElement("p");
				_p.style.backgroundImage = "url("+data_cbk[i]+")";//'<p style="background:url('+filePath+')"></p>'
				/*_img = document.createElement("img");
				_img.attributes['picType'] = 'pic';
				_img.src = data_cbk[i];
				_img.style.width = '40%';
				_img.style.margin = '0 5%';
				_img.style.float = 'left';*/
//				document.getElementById('imgcont').appendChild(_p);
				$('#imgcont').addClass('hascont').append(_p);
				global.sendMsgScroll.refresh();
			}
		},
		/*动态列表页刷新*/
		postRefreshCallback:function(data_cbk){
			if(!data_cbk.length){
				if(1==window.cur_page){
					$('#thelist').html('<div style="text-align:center;margin-top:20px;">还没有新动态.<span id="befirstposter" style="color:#64bffe;margin-left:20px;">发一条</span></div>');
				}
				return false;
			}
			var data = {
						con_lists: data_cbk
				};
//			alert("获取的数据条数："+data_cbk.length);
			var html = template('convs', data);
//				$('#thelist').html(html);
			var $conDOM = $(html);
			var $tem_imgs = $conDOM.find('img');
			$tem_imgs.each(function(i){
				var imgsrc = $(this).attr('src');

//					if(imgsrc.indexOf('http') !== 0){
				if(imgsrc.indexOf('http') >= 0){
//						$(this).attr('src', window.ESN_HOST + imgsrc);
				}
			})
			if(1==window.cur_page){
				$('#thelist').html($conDOM);
			}else{
				$('#thelist').append($conDOM);
			}
			//判断下拉刷新
			if (window.spacePullType == 1) {
				var hasClass = $('#notMore').hasClass('hidden');
				if (!hasClass) {
					$('#notMore').addClass('hidden');
				}
			}
			//20 为每页刷新的条数，随着请求参数pageSize的变化而变化
			if(data_cbk.length < 20){
				$('#notMore').removeClass('hidden');
//				showMessage("已到最后一条");
			}
//				window.myScroll.refresh()/*replace_the_iscroll*/
//				setTimeout(function(){
//					global.myScroll.refresh();
//				},1000);
		},
		/*加载更多动态*/
		loadPostCallback:function(data_cbk){
			
		},
		/*点赞*/
		praiseCallback:function(data_cbk){
		},
		/*发布动态*/
		publishPostCallback : function(data_cbk){
			refreshPage();
			$("#imgcont").html('');
		},
		/*圈子列表*/
		listSpacesCallback:function(data_cbk){
			var data = {
				space_list:data_cbk
			};
			var template_invoke = template('spaces',data);
			$('#allspaces').html(template_invoke);
			global.spcScroll.refresh();
		},
		/*创建圈子*/
		createSpaceCallback:function(data_cbk){
			$('#space_creat').removeClass('act');
			if(data_cbk.result){
				showMessage('创建成功');
			}else{
				showMessage('创建失败');
			}
			location.reload()
		},
		/*加入圈子*/
		joinSpaceCallback:function(data_cbk){
			if(data_cbk.result){
				if(data_cbk.state==1){
						showMessage('加入成功');
						if($('.todeal').closest('ul').hasClass('sps-srh-res')){
							$('.todeal').find('.join-sts').addClass('joined').removeClass('todeal unjoined');
						}else{
							var $cloned_spc = $('.all-spc .todeal').clone();
							$cloned_spc .find('.join-sts').removeClass('unjoined todeal').addClass('joined');
							$('.my-spc').append($cloned_spc); 
							$('.all-spc .todeal').find('.join-sts').addClass('joined').removeClass('unjoined');
							$('.todeal').removeClass('todeal');
							global.spcScroll.refresh();
						}
				}else if(data_cbk.state==0){
					showMessage('申请已提交');
				$('.todeal').removeClass('todeal');
				}
			}else{
				 showMessage(data_cbk.state==-10?'申请正在审核中。。。':'操作失败！');
				$('.todeal').removeClass('todeal');
				if($('#space_apply').hasClass('act')){
					$('#space_apply').removeClass('act');
					setTimeout(function(){$('#space_apply').addClass('hidden')},300);
				}
				//location.reload();
			}
		},
		applyInSpaceCallback:function(data_cbk){
			global.JSFN.joinSpaceCallback(data_cbk);
		},
		/*退出圈子*/
		quitSpaceCallback:function(data_cbk){
			if(data_cbk.result){
				showMessage('您已退出圈子');
				if($('.todeal').closest('ul').hasClass('sps-srh-res')){
					$('.todeal').find('.join-sts').addClass('unjoined').removeClass('todeal joined');
				}else{
					global.refreshSpaces();
				}
			}else{
				showMessage(data_cbk.result);
			}
			$('.todeal').removeClass('todeal');
		},
		/*删除圈子*/
		deleteSpaceCallback:function(data_cbk){
			if(data_cbk.result){
				showMessage('圈子删除成功');
			}else{
				showMessage('操作失败');
			}
			$('#space_edit .arr-back').trigger('tap');
			global.refreshSpaces();
		},
		/*我加入的圈子列表*/
		mySpacesCallback:function(data_cbk){
			var data = {
				myspaces:data_cbk
			};
			
			var template_invoke = template('myspsmenu',data);
			$('.switch-space .drop-menu').prepend(template_invoke);
		},
		/*回复*/
		replyCallback:function(data_cbk){
			global.isCanReply = true;
			if(data_cbk.result){
				var str = "<p class='reply-item' fromid='"+global.jid+"'><a class='reply'>我</a>";
				str+="<span style='margin:0 2px;'>回复</span><a>"+global.cache.replyName+"</a>";
				str+=": "+global.cache.replyCont+" </p>";
				$(".post-item.ing .reply-blk").removeClass("hidden").append(str);
				var $reply_num = $('.post-item.ing').find('.reply-icon');
				$reply_num.html(parseInt($reply_num.html(),10)+1);
				clearState();
			}
		},
		/*圈子搜索结果*/
		spaceSearchCallback:function(data_cbk){
			if(data_cbk){
				if (data_cbk.length == 0) {
					showMessage("没有搜索到圈子,修改下key吧")
				}else if (data_cbk.length == 100) {
					showMessage("搜索结果超过100条限制，修改下key使搜索更精确吧")
				}
				var data = {
					space_list:data_cbk
				};
				var template_invoke = template('sps-srh-res',data);
				$('#sps_search_result').html(template_invoke);
			}else{
				showMessage("没有搜索到圈子");
			}
		},
		/*通知列表*/
		getNotifyListCallback:function(data_cbk){
			
			var data ={
				notify_list:data_cbk.notifyList
			};
			var template_invoke = template('notify-list',data);
			$('#notice_list').html(template_invoke);
		},
		/*通知相关的动态详情*/
		getSingleDynamicCallback:function(data_cbk){
			var spc_name = data_cbk.space.name;
			$('.space-link .pie').addClass('rainbow-'+getFirstLetter(spc_name));
			$('.space-link .pie').html(spc_name.substr(spc_name.length-2,2));
			$('.space-link').attr('wsid',data_cbk.space.id);
			$('.space-link').find('.space-name').html(spc_name);
			var data = {
				post: data_cbk.post
			}
			var template_involke = template('notice-detail',data);
			$('.post-detail').html(template_involke);
			window.noticeScroll.refresh()
		},
		/*获取圈子成员*/
		getSpaceMembersCallback:function(data_cbk){
			var data = {
				userList:data_cbk.userList
			}
			var template_involke = template('spc-member',data);
			$('.usr-list').prepend(template_involke);
		},
		/*搜索用户*/
		searchUserCallback:function(data_cbk){
			
			if(data_cbk){
				if (data_cbk.users.length == 0) {
					showMessage("没有搜索到用户,修改下key吧")
				}else if (eval(data_cbk.users.length) == 100) {
					showMessage("搜索结果超过100条限制，修改下key使搜索更精确吧")
				}
				var data = {userList:data_cbk.users}
				var template_involke = template('user-srh-res',data);
				$('#user_search_result').html(template_involke);
			}else{
				showMessage("没有搜索到用户");
			}
		},
		/*将用户批量加入圈子*/
		batchPullInSpaceCallback:function(data_cbk){
			$('#usr_search_page').removeClass('act');
			setTimeout(function(){
				$('#usr_search_page').addClass('hidden')
			},300);
			location.reload();
		},
		/*修改圈子信息*/
		modifyWallSpaceCallback:function(data_cbk){
			if(data_cbk.result){
				showMessage('修改成功')
			}else{
				showMessage('操作失败，您没有相关权限！')
			}
			$('#space_edit').removeClass('act');
			setTimeout(function(){
				$('#space_edit').addClass('hidden')
			},300);
			if(data_cbk.result){
				refreshSpaces();
			}
		},
		/*查询申请审批状态*/
		checkApplyStatusCallback:function(data_cbk){
			if(data_cbk.result && (data_cbk.sur.status!=0)){
				$('.operations .opt2').removeClass('hidden');
				$('.operations .opt1').addClass('hidden');
			}else if(data_cbk.result && (data_cbk.sur.status==0)){
				$('.operations .opt1').removeClass('hidden');
				$('.operations .opt2').addClass('hidden');
			}
		},
		/*审批圈子加入申请（同意）*/
		batchDenyAppliesCallback:function(data_cbk){
			if(data_cbk.result){
				showMessage('操作成功。')
			}else{
				showMessage('操作失败！')
			}
			setTimeout(function(){
				$('.refer-page').trigger('tap');
			},300);
		},
		/*审批圈子加入申请（拒绝）*/
		batchAgreeAppliesCallback:function(data_cbk){
			global.JSFN.batchDenyAppliesCallback(data_cbk);
		}
	}
})(window);