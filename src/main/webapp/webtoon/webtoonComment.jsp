<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>JAVA COMICS</title>
<link rel="stylesheet" href="/JAVACOMICS/css/reset.css">
<link rel="stylesheet" href="/JAVACOMICS/css/webtoonComment.css">
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
</head>
<body>
<input type="hidden" id="episodeCode" value="${param.episodeCode}">
<div id="webtoonComment_header">
	<a onclick="history.back(-1)"><p><img src="../image/webtoonComment_image/backicon.PNG"/></p></a>
	<p>댓글<span></span></p>
	<p id="sortBtn"><img src="../image/webtoonComment_image/sorticon.png"></p>
</div>

<form id="webtoonComment_inputForm">
   <div id="webtoonComment_input">
      <input name="webtoonComment_inputText" id="webtoonComment_inputText" placeholder="댓글을 입력해 주세요" type="text">
      <input type="submit" id="webtoonComment_inputBtn" value="입력" /> 
   </div>
</form>

<ul id="webtoonComment_list">
</ul>

<input id="sessionid" type="hidden" value="${sessionScope.toonMemId }"/>


<script type="text/javascript" src="http://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">


$(function(){
//댓글목록출력
	//swal("a","a");
	$('#webtoonComment_list').attr('value','sortGood');
		$.ajax({
			url: '/JAVACOMICS/tooncomment/getToonCommentList',
			type: 'post',
			data:'episodeCode='+$('#episodeCode').val(),
			dataType: 'json',
			success: function(data){
			 	$.each(data, function(index, items){
							addComment(items.id, items.content, items.logtime
								, items.totalgood, items.totalbad, items.reply
								, items.commentSeq);
				});						
			},
			error: function(err){
				console.log(err);	
			}
		});
//댓글 총 개수 가져오기
		$.ajax({
			url: '/JAVACOMICS/tooncomment/getToonCommentCount',
			type: 'post',
			data:'episodeCode='+$('#episodeCode').val(),
			dataType: 'json',
			success: function(data){
					$('#webtoonComment_header p:nth-child(2) span').html(' '+data);
			},
			error: function(err){
				console.log(err);	
			}
		});
});
//최신순 정렬
function sortLatest(){
	$('#webtoonComment_list').attr('value','sortLatest');
$('#webtoonComment_list').empty();
$.ajax({
	url: '/JAVACOMICS/tooncomment/sortLatest',
	type: 'post',
	data:'episodeCode='+$('#episodeCode').val(),
	dataType: 'json',
	success: function(data){
		 	$.each(data, function(index, items){
					addComment(items.id, items.content, items.logtime
						, items.totalgood, items.totalbad, items.reply
						, items.commentSeq);
		}) 
			
	},
	error: function(err){
		console.log(err);	
	}
});
//댓글 총 개수 가져오기
$.ajax({
	url: '/JAVACOMICS/tooncomment/getToonCommentCount',
	type: 'post',
	data:'episodeCode='+$('#episodeCode').val(),
	dataType: 'json',
	success: function(data){
			$('#webtoonComment_header p:nth-child(2) span').html(' '+data);
	},
	error: function(err){
		console.log(err);	
	}
});

}
 
$('#sortBtn').click(function(){

	if($('#webtoonComment_list').attr('value') == 'sortGood'){
			$('#webtoonComment_list').empty();
			swal("최신순으로 정렬됩니다.", {
					  buttons: false,
					  timer: 1000
					});
			$.ajax({
				url: '/JAVACOMICS/tooncomment/sortLatest',
				type: 'post',
				data:'episodeCode='+$('#episodeCode').val(),
				dataType: 'json',
				success: function(data){
				
					 	$.each(data, function(index, items){
								addComment(items.id, items.content, items.logtime
									, items.totalgood, items.totalbad, items.reply
									, items.commentSeq);
						});
						
				},
				error: function(err){
					console.log(err);	
				}
			});
			$('#webtoonComment_list').attr('value','sortLatest');
			return;
		
		}else if($('#webtoonComment_list').attr('value') == 'sortLatest'){
			$('#webtoonComment_list').empty();
				swal("좋아요순으로 정렬됩니다.", {
					  buttons: false,
					  timer: 1000
					});
			$.ajax({
				url: '/JAVACOMICS/tooncomment/getToonCommentList',
				type: 'post',
				data:'episodeCode='+$('#episodeCode').val(),
				dataType: 'json',
				success: function(data){
				 	$.each(data, function(index, items){
								addComment(items.id, items.content, items.logtime
									, items.totalgood, items.totalbad, items.reply
									, items.commentSeq);
					});
		
				},
				error: function(err){
					console.log(err);	
				}
			});
			$('#webtoonComment_list').attr('value','sortGood');
			$('#sortGooddiv').show(10000);
			return;
		}
	});
	

//저장
$(function(){
	$('#webtoonComment_inputForm').submit(function(){
	      
	      if($('#sessionid').val()==''){
	    	  alert('로그인 하세요');
	    	  return false;
	      }
	      if(!$('#webtoonComment_inputText').val()){
	         alert('내용을 입력하세요.');
	         $('#webtoonComment_inputText').focus();
	         return false;
	      }else{
	  		$.ajax({
				type: 'post',
				url: '/JAVACOMICS/tooncomment/toonCommentWrite',
				data:'content='+ $('#webtoonComment_inputText').val()+'&episodeCode='+$('#episodeCode').val(),
				success: function(){
					//$('#webtoonComment_inputText').val()='';
					sortLatest();
				},
				error: function(err){
					console.log(err);
				}
			});
		}
	    	  
		return false;
	});
}); 


function addComment(id, content, logtime, totalgood, totalbad, reply, commentSeq){
	var webtoonComment_li = $('<li>');
	webtoonComment_li.attr('data-num', commentSeq);
	webtoonComment_li.addClass('webtoonComment_li');
	
	/* 베스트, 아이디, 날짜, 내용 div  */
	var webtoonComment_BIDC_div = $('<div>');
	webtoonComment_BIDC_div.addClass('webtoonComment_BIDC_div');
	
	var webtoonComment_Best_Id_Date_div = $('<div>');
	webtoonComment_Best_Id_Date_div.addClass('webtoonComment_Best_Id_Date_div');
	
	var webtoonComment_Best_p =$('<p>');
	webtoonComment_Best_p.addClass('webtoonComment_Best_p');
	webtoonComment_Best_p.html('BEST');

	var webtoonComment_Id_p=$('<p>');
	webtoonComment_Id_p.addClass('webtoonComment_Id_p');
	webtoonComment_Id_p.html(id);
	
	var webtoonComment_Date_p = $('<p>');
	webtoonComment_Date_p.html(logtime);
	webtoonComment_Date_p.addClass('webtoonComment_Date_p');
	
	var webtoonComment_Content_div = $('<div>');
	webtoonComment_Content_div.addClass('webtoonComment_Content_div');
	webtoonComment_Content_div.html(content);

	
	/* 좋아요, 싫어요, 답글 버튼 div  */
	var webtoonComment_GBRbtn_div = $('<div>');
	webtoonComment_GBRbtn_div.addClass('webtoonComment_GBRbtn_div');
/* 	
	var webtoonComment_Good_btn = $('<input>');
	webtoonComment_Good_btn.attr({
		'type' : 'button',
		'value' : '좋아요 '+totalgood,
	});
	webtoonComment_Good_btn.addClass('webtoonComment_Good_btn');
 */	
/*	if($('#sessionid').val()!=''){
		$.ajax({
			url: '/JAVACOMICS/commentGoodBad/commentGoodBadCheck',
			type: 'post',
			dataType: 'json',
			success: function(data){
				//alert(JSON.stringify(data));
				$.each(data, function(index, items){
					if(items.commentSeq==commentSeq){
						if(items.commentgood == 'T'){ 
							 	
	
							
							
							
						 
							
							
							//$('.webtoonComment_li').attr('data-num') == items.commentseq) $(this).css('color','red');
							}
						
					//if(items.commentbad == 'T') $(this).css('color','red');
					}
				});//each			
			},
			error: function(err){
				alert('에러');	
			}
		});
	}*/
	//else{ 
		var webtoonComment_Good_btn = $('<input>');
		webtoonComment_Good_btn.attr({
			'type' : 'button',
			'value' : '좋아요 '+totalgood,
		});
		webtoonComment_Good_btn.addClass('webtoonComment_Good_btn');
	 
	//}
	

	var webtoonComment_Bad_btn = $('<input>');
	webtoonComment_Bad_btn.attr({
		'type' : 'button',
		'value' : '싫어요 '+totalbad
	});
	webtoonComment_Bad_btn.addClass('webtoonComment_Bad_btn');
	
	var webtoonComment_Reply_btn = $('<input>');
	webtoonComment_Reply_btn.attr({
		'type' : 'button',
		'value' : '답글 '+reply
	});

	/* 삭제하기 일단 냅둠 */
	var del_input = $('<input>');
	del_input.attr({
		'type' : 'button',
		'value' : '삭제하기'
	});
	del_input.addClass('delete_btn');
 
	
	if(totalgood>10){
		webtoonComment_Best_Id_Date_div.append(webtoonComment_Best_p).append(webtoonComment_Id_p).append(webtoonComment_Date_p);
		webtoonComment_BIDC_div.append(webtoonComment_Best_Id_Date_div).append(webtoonComment_Content_div);
		webtoonComment_GBRbtn_div.append(webtoonComment_Good_btn).append(webtoonComment_Bad_btn).append(webtoonComment_Reply_btn);
		webtoonComment_li.append(webtoonComment_BIDC_div).append(webtoonComment_GBRbtn_div);
		$('#webtoonComment_list').append(webtoonComment_li);
	}else{
		//webtoonComment_Best_Id_Date_div.append(webtoonComment_Best_p).append(webtoonComment_Id_p).append(webtoonComment_Date_p);
		webtoonComment_Best_Id_Date_div.append(webtoonComment_Id_p).append(webtoonComment_Date_p);
		webtoonComment_BIDC_div.append(webtoonComment_Best_Id_Date_div).append(webtoonComment_Content_div);
		webtoonComment_GBRbtn_div.append(webtoonComment_Good_btn).append(webtoonComment_Bad_btn).append(webtoonComment_Reply_btn);
		webtoonComment_li.append(webtoonComment_BIDC_div).append(webtoonComment_GBRbtn_div);
		$('#webtoonComment_list').append(webtoonComment_li);
	} 
 	
	 

}

//좋아요
$(document).on('click', '.webtoonComment_Good_btn', function(){
	var good = $(this);
	if($('#sessionid').val()==''){
  	  alert('로그인 하세요');
  	  return false;
    }else{
	var commentSeq= $(this).parents('li').attr('data-num');
		$.ajax({
			type: 'post',
			url: '/JAVACOMICS/commentGoodBad/checkGoodId',
			data:'commentSeq='+commentSeq,
			success: function(data){
				if(data == 'exist'){
					
					$.ajax({
						type: 'post',
						url: '/JAVACOMICS/commentGoodBad/commentGoodDelete',
						data:'commentSeq='+commentSeq,
						success: function(){
							
							$.ajax({
								url: '/JAVACOMICS/tooncomment/getCommentGood',
								type: 'post',
								data:'commentSeq='+commentSeq,
								dataType: 'json',
								success: function(data){
									good.css('color', '#777777');
									good.attr('value','좋아요 '+data.totalgood);	
								
												
								},
								error: function(err){
									console.log(err);	
								}
							});
						},
						error: function(err){
							alert('좋아요취소에러');
						}
					});	

				}else if(data == 'non_exist'){
					$.ajax({
						type: 'post',
						url: '/JAVACOMICS/commentGoodBad/commentGood',
						data:'commentSeq='+commentSeq,
						success: function(){
							$.ajax({
								url: '/JAVACOMICS/tooncomment/getCommentGood',
								type: 'post',
								data:'commentSeq='+commentSeq,
								dataType: 'json',
								success: function(data){
									//alert(JSON.stringify(data));
									//alert($(data.totalgood));
									good.css('color','red');
									good.attr('value','좋아요 '+data.totalgood);	
								 	
												
								},
								error: function(err){
									console.log(err);	
								}
							});
						},
						error: function(err){
							alert('인서트에러');
						}
					});		
				
						
							
				}
			},			 
			error: function(err){
				alert('에러');
			}
		});
	
	}
});

//싫어요
$(document).on('click', '.webtoonComment_Bad_btn', function(){
	var bad = $(this);
	if($('#sessionid').val()==''){
  	  alert('로그인 하세요');
  	  return false;
    }else{
	var commentSeq= $(this).parents('li').attr('data-num');
		$.ajax({
			type: 'post',
			url: '/JAVACOMICS/commentGoodBad/checkBadId',
			data:'commentSeq='+commentSeq,
			success: function(data){
				if(data == 'exist'){
					//alert('싫어요취소');
					
					$.ajax({
						type: 'post',
						url: '/JAVACOMICS/commentGoodBad/commentBadDelete',
						data:'commentSeq='+commentSeq,
						success: function(){
							$.ajax({
								url: '/JAVACOMICS/tooncomment/getCommentGood',
								type: 'post',
								data:'commentSeq='+commentSeq,
								dataType: 'json',
								success: function(data){
							
									bad.css('color', '#777777');
									bad.attr('value','싫어요 '+data.totalbad);	
								 	/* $.each(data, function(index, items){
								 		bad.attr('value','싫어요 '+items.totalbad);	
									}); */
												
								},
								error: function(err){
									console.log(err);	
								}
							});
						},
						error: function(err){
							alert('싫어요취소에러');
						}
					});	

				}else if(data == 'non_exist'){
					$.ajax({
						type: 'post',
						url: '/JAVACOMICS/commentGoodBad/commentBad',
						data:'commentSeq='+commentSeq,
						success: function(){
							$.ajax({
								url: '/JAVACOMICS/tooncomment/getCommentGood',
								type: 'post',
								data:'commentSeq='+commentSeq,
								dataType: 'json',
								success: function(data){
								
									bad.css('color', 'red');
									bad.attr('value','싫어요 '+data.totalbad);
								
												
								},
								error: function(err){
									console.log(err);	
								}
							});
						},
						error: function(err){
							alert('인서트에러');
						}
					});			
				}
			},			 
			error: function(err){
				alert('에러');
			}
		});
	}
});




</script>
</body>
</html>